/*
1. Створити процедуру, яка автоматизує наповнення таблиці Products даними (дані для INSERT можна взяти в роботі №3)
2. Створити процедуру, яка дозволить вивести Ім’я користувача та всі його замовлення на основі його id,
   яке буде передаватись до процедури.
3. Створити процедуру, яка дозволить отримати id користувача, з найбільшою кількістю замовлень у місяці MMM року YYY
   (MMM та YYY передавати при викликанні процедури).
4. За допомогою виклику процедури з завдання 3 як параметра процедури з завдання 2 дізнатись всі дані
   про користувача найбільшою кількістю замовлень за жовтень 2021 року.
5*. Зробити завдання 4. З минулої лабораторної роботи
    (4. Вивести за допомогою циклу суму замовлень за січень, лютий, ..., грудень 2021 року) через одну процедуру у циклі.
6*. Створити процедуру, яка буде запускати скрипт з задачі 6 Лабораторної роботи № 8
    (6. Написати код, який створить таблицю (перед створенням перевірити її наявність та видалити, якщо наявна),
    в яку вставить 1000 випадкових цілих значень A, B, C та float X1, X2, де A, B, C параметри квадратного тричлену
    (Ax2 + Bx + C = 0), X1 та X2 – корені (NULL – якщо відсутній корінь))
7*. Створити процедуру, яка наповнить таблицю Orders випадковими значеннями замовлень на основі таблиць
    Products та Customers (Для цього створити процедури додавання записів в таблицю товарів та користувачів).
8*. Написати скрипт, який запустить процедуру з п.7 100000 разів.
*/

-- 1
CREATE PROCEDURE [FillProducts]
AS
BEGIN
    INSERT INTO Products ([ProductName], [Manufacturer], [ProductCount], [Price])
    VALUES ('IPhone SE', 'Apple', 3, 19999),
           ('Samsung Galaxy A52', 'Samsung', 10, 15999),
           ('OnePlus 9', 'OnePlus', 5, 34999),
           ('Xiaomi Redmi Note 10', 'Xiaomi', 8, 12999),
           ('Huawei P40', 'Huawei', 2, 24999);
END
GO

EXEC [FillProducts];
--DROP PROCEDURE [FillProducts];

-- 2
CREATE PROCEDURE [GetCustomerOrders](@CustomerId INT)
AS
BEGIN
    SELECT c.[FirstName] AS CustomerName,
           o.[ProductId],
           o.[CreatedAt],
           o.[ProductCount],
           o.[Price]
    FROM [Customers] c
             JOIN [Orders] o ON c.[Id] = o.[CustomerId]
    WHERE c.[Id] = @CustomerId;
END
GO

EXEC [GetCustomerOrders] 1;
--DROP PROCEDURE [GetCustomerOrders];

-- 3
CREATE PROCEDURE [GetTopCustomerByOrders](@Year INT, @Month INT)
AS
BEGIN
    DECLARE @TopCustomerId INT;

    SELECT TOP 1 @TopCustomerId = o.[CustomerId]
    FROM [Orders] o
    WHERE o.[CreatedAt] >= DATEFROMPARTS(@Year, @Month, 1)
      AND o.[CreatedAt] < DATEADD(MONTH, 1, DATEFROMPARTS(@Year, @Month, 1))
    GROUP BY o.[CustomerId]
    ORDER BY COUNT(1) DESC;

    RETURN @TopCustomerId
END
GO

DECLARE @TopCustomerId INT;
EXEC @TopCustomerId = [GetTopCustomerByOrders] 2021, 2;
PRINT (@TopCustomerId)
--DROP PROCEDURE [GetTopCustomerByOrders];

-- 4
DECLARE @TopCustomerId INT;
EXEC @TopCustomerId = [GetTopCustomerByOrders] @Year = 2021, @Month = 2;
EXEC [GetCustomerOrders] @CustomerId = @TopCustomerId;

-- 5
CREATE PROCEDURE [GetMonthlyOrderSums]
AS
BEGIN
    DECLARE @Year INT = 2021;
    DECLARE @Month INT = 1;
    DECLARE @SumForMonth MONEY;

    WHILE @Month <= 12
        BEGIN
            SELECT @SumForMonth = SUM(o.[Price] * o.[ProductCount])
            FROM [Orders] o
            WHERE o.[CreatedAt] >= DATEFROMPARTS(@Year, @Month, 1)
              AND o.[CreatedAt] < DATEADD(MONTH, 1, DATEFROMPARTS(@Year, @Month, 1));

            PRINT CONCAT('Місяць: ', @Month, ', Сума: ', ISNULL(@SumForMonth, 0));

            SET @Month = @Month + 1;
        END
END
GO

EXEC [GetMonthlyOrderSums];
--DROP PROCEDURE [GetMonthlyOrderSums];


-- 6
CREATE PROCEDURE [CreateAndFillQuadraticTable]
AS
BEGIN
    IF OBJECT_ID('QuadraticEquations', 'U') IS NOT NULL
        DROP TABLE QuadraticEquations;

    CREATE TABLE [QuadraticEquations]
    (
        [Id] INT IDENTITY PRIMARY KEY,
        [A]  INT   NOT NULL,
        [B]  INT   NOT NULL,
        [C]  INT   NOT NULL,
        [X1] FLOAT NULL,
        [X2] FLOAT NULL
    );

    DECLARE @Counter INT = 0;
    WHILE @Counter < 1000
        BEGIN
            DECLARE @A INT = ROUND(RAND() * 10 - 5, 0);
            DECLARE @B INT = ROUND(RAND() * 10 - 5, 0);
            DECLARE @C INT = ROUND(RAND() * 10 - 5, 0);
            DECLARE @Discriminant FLOAT;
            DECLARE @X1 FLOAT = NULL;
            DECLARE @X2 FLOAT = NULL;

            IF @A <> 0
                BEGIN
                    SET @Discriminant = @B * @B - 4 * @A * @C;

                    IF @Discriminant >= 0
                        BEGIN
                            SET @X1 = (-@B + SQRT(@Discriminant)) / (2.0 * @A);
                            SET @X2 = (-@B - SQRT(@Discriminant)) / (2.0 * @A);
                        END
                END

            INSERT INTO QuadraticEquations (A, B, C, X1, X2)
            VALUES (@A, @B, @C, @X1, @X2);

            SET @Counter = @Counter + 1;
        END;

    SELECT *
    FROM [QuadraticEquations];
END
GO

EXEC [CreateAndFillQuadraticTable];
--DROP PROCEDURE [CreateAndFillQuadraticTable];

-- 7
CREATE PROCEDURE [FillOrders]
AS
BEGIN
    DECLARE @ProductId INT, @CustomerId INT, @CreatedAt DATE, @ProductCount INT, @Price MONEY;

    SET @CustomerId = (SELECT TOP 1 [Id] FROM [Customers] ORDER BY NEWID());
    SET @ProductId = (SELECT TOP 1 [Id] FROM [Products] ORDER BY NEWID());
    SET @CreatedAt = DATEADD(DAY, ABS(CHECKSUM(NEWID()) % 365), '2021-01-01');
    SET @ProductCount = ABS(CHECKSUM(NEWID()) % 5) + 1;
    SET @Price = (SELECT [Price] FROM [Products] WHERE Id = @ProductId) * @ProductCount;

    INSERT INTO [Orders] ([ProductId], [CustomerId], [CreatedAt], [ProductCount], [Price])
    VALUES (@ProductId, @CustomerId, @CreatedAt, @ProductCount, @Price);
END
GO

EXEC [FillOrders];
--DROP PROCEDURE [FillOrders];
SELECT * FROM [Orders];

-- 8
DECLARE @i INT = 0;

WHILE @i < 100000
    BEGIN
        EXEC [FillOrders];
        SET @i = @i + 1;
    END
GO