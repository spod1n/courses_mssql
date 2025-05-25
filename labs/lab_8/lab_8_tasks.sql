/*
1. Проробити всі приклади коду з лабораторної роботи.
2. Написати код, який без вбудованих запитів (замінити на змінну) виведе всі товари,
   вартість яких вище середньої вартості товарів по таблиці.
3. Вивести Ім’я користувача та всі його замовлення на основі його id, яке визначається у змінній.
4. Вивести за допомогою циклу суму замовлень за січень, лютий, ..., грудень 2021 року.
5. Написати код, який на основі значень A, B, C порахує корені квадратного тричлену (Ax2 + Bx + C = 0),
   якщо корені відсутні, то вивести напис «Корені відсутні».
6. Написати код, який створить таблицю (перед створенням перевірити її наявність та видалити, якщо наявна),
   в яку вставить 1000 випадкових цілих значень A, B, C та float X1, X2, де A, B, C параметри квадратного тричлену
   (Ax2 + Bx + C = 0), X1 та X2 – корені (NULL – якщо відсутній корінь).
7. Вивести дані про користувача (ім'я та телефон) та його максимальне замовлення (сума і остання дата) за його id,
   якщо замовлень не було, вивести фразу: "У користувача @name (код @id) замовлень не було"
   (де замість @id - поставити код користувача, замість @name - його ім'я)
8.* Створити тимчасову таблицю і занести в неї дані (без використання PIVOT) з кількості проданих товарів
    для кожного місяця 2021 року (перелік полів: id, Name, Manufacturer, Sum_2021_01, Sum_2021_02, …, Sum_2021_12).
    Вивести цю таблицю на екран.
9*. Виконати задачу 5 за умови унікальності трійки значень A, B, C та цілого типу значення кореня дискримінанту.
10*. Порахувати, на скільки відрізняється число товарів, менших середньої ціни, від числа товарів,
     більше середньої ціни (товари, ціна яких співпадає з середньою не враховувати)
11. Вивести на екран (без використання підзапитів) виробника товару з найбільшоу вартістю
    (якщо є декілька таких компаній виробників, то вивести про це повідомлення) і суму,
    на яку продано товарів даного виробника. Інформацію виводмимо у форматі: «Виробник, товар якого найдорожчий,
    - це … , вже продано його товарів на суму - …» або «Багато компаній, які випускають найдорожчі продукти».
*/

-- 2
DECLARE @AveragePrice MONEY;

SELECT @AveragePrice = AVG([Price])
FROM [Products];

SELECT *
FROM [Products]
WHERE [Price] > @AveragePrice;

-- 3
DECLARE @CustomerId INT = 1;

SELECT c.[FirstName] AS [CustomerName], o.*
FROM [Customers] c
         LEFT JOIN [Orders] o ON c.[Id] = o.[CustomerId]
WHERE c.[Id] = @CustomerId;

-- 4
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
    END;

-- 5
DECLARE @A FLOAT = 1,
    @B FLOAT = -3,
    @C FLOAT = 2,
    @Discriminant FLOAT,
    @X1 FLOAT,
    @X2 FLOAT;

SET @Discriminant = @B * @B - 4 * @A * @C;

IF @Discriminant < 0
    PRINT 'Корені відсутні';
ELSE
    IF @Discriminant = 0
        BEGIN
            SET @X1 = -@B / (2 * @A);
            PRINT CONCAT('Один корінь: X = ', @X1);
        END
    ELSE
        BEGIN
            SET @X1 = (-@B + SQRT(@Discriminant)) / (2 * @A);
            SET @X2 = (-@B - SQRT(@Discriminant)) / (2 * @A);
            PRINT CONCAT('Корені: X1 = ', @X1, ', X2 = ', @X2);
        END;

-- 6
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

-- 7
DECLARE @CustomerId INT = 1,
    @CustomerName NVARCHAR(30);

SELECT @CustomerName = [FirstName]
FROM [Customers]
WHERE [Id] = @CustomerId;

IF NOT EXISTS (SELECT 1
               FROM [Orders]
               WHERE [CustomerId] = @CustomerId)
    BEGIN
        PRINT CONCAT('У користувача ', @CustomerName, ' (код ', @CustomerId, ') замовлень не було');
    END
ELSE
    BEGIN
        SELECT TOP 1 @CustomerName                 AS 'CustomerName',
                     MAX([Price] * [ProductCount]) AS 'MaxOrderSum',
                     MAX([CreatedAt])              AS 'LastOrderDate'
        FROM [Orders]
        WHERE [CustomerId] = @CustomerId
        GROUP BY [CustomerId];
    END;

-- 8
CREATE TABLE #SalesSummary
(
    [Id]           INT,
    [Name]         NVARCHAR(30),
    [Manufacturer] NVARCHAR(20),
    [Sum_2021_01]  INT DEFAULT 0,
    [Sum_2021_02]  INT DEFAULT 0,
    [Sum_2021_03]  INT DEFAULT 0,
    [Sum_2021_04]  INT DEFAULT 0,
    [Sum_2021_05]  INT DEFAULT 0,
    [Sum_2021_06]  INT DEFAULT 0,
    [Sum_2021_07]  INT DEFAULT 0,
    [Sum_2021_08]  INT DEFAULT 0,
    [Sum_2021_09]  INT DEFAULT 0,
    [Sum_2021_10]  INT DEFAULT 0,
    [Sum_2021_11]  INT DEFAULT 0,
    [Sum_2021_12]  INT DEFAULT 0
);

INSERT INTO #SalesSummary ([Id], [Name], [Manufacturer],
                           [Sum_2021_01], [Sum_2021_02], [Sum_2021_03],
                           [Sum_2021_04], [Sum_2021_05], [Sum_2021_06],
                           [Sum_2021_07], [Sum_2021_08], [Sum_2021_09],
                           [Sum_2021_10], [Sum_2021_11], [Sum_2021_12])
SELECT p.[Id],
       p.[ProductName]                                                                         AS 'Name',
       p.[Manufacturer],
       -- Підрахунок кількості продажів за кожен місяць 2021 року
       SUM(IIF(MONTH(o.[CreatedAt]) = 1 AND YEAR(o.[CreatedAt]) = 2021, o.[ProductCount], 0))  AS 'Sum_2021_01',
       SUM(IIF(MONTH(o.[CreatedAt]) = 2 AND YEAR(o.[CreatedAt]) = 2021, o.[ProductCount], 0))  AS 'Sum_2021_02',
       SUM(IIF(MONTH(o.[CreatedAt]) = 3 AND YEAR(o.[CreatedAt]) = 2021, o.[ProductCount], 0))  AS 'Sum_2021_03',
       SUM(IIF(MONTH(o.[CreatedAt]) = 4 AND YEAR(o.[CreatedAt]) = 2021, o.[ProductCount], 0))  AS 'Sum_2021_04',
       SUM(IIF(MONTH(o.[CreatedAt]) = 5 AND YEAR(o.[CreatedAt]) = 2021, o.[ProductCount], 0))  AS 'Sum_2021_05',
       SUM(IIF(MONTH(o.[CreatedAt]) = 6 AND YEAR(o.[CreatedAt]) = 2021, o.[ProductCount], 0))  AS 'Sum_2021_06',
       SUM(IIF(MONTH(o.[CreatedAt]) = 7 AND YEAR(o.[CreatedAt]) = 2021, o.[ProductCount], 0))  AS 'Sum_2021_07',
       SUM(IIF(MONTH(o.[CreatedAt]) = 8 AND YEAR(o.[CreatedAt]) = 2021, o.[ProductCount], 0))  AS 'Sum_2021_08',
       SUM(IIF(MONTH(o.[CreatedAt]) = 9 AND YEAR(o.[CreatedAt]) = 2021, o.[ProductCount], 0))  AS 'Sum_2021_09',
       SUM(IIF(MONTH(o.[CreatedAt]) = 10 AND YEAR(o.[CreatedAt]) = 2021, o.[ProductCount], 0)) AS 'Sum_2021_10',
       SUM(IIF(MONTH(o.[CreatedAt]) = 11 AND YEAR(o.[CreatedAt]) = 2021, o.[ProductCount], 0)) AS 'Sum_2021_11',
       SUM(IIF(MONTH(o.[CreatedAt]) = 12 AND YEAR(o.[CreatedAt]) = 2021, o.[ProductCount], 0)) AS 'Sum_2021_12'
FROM [Products] p
         JOIN
     [Orders] o ON p.[Id] = o.[ProductId]
GROUP BY p.[Id], p.[ProductName], p.[Manufacturer];

SELECT *
FROM #SalesSummary;


-- 9
DECLARE @A INT, @B INT, @C INT;
DECLARE @D INT;
DECLARE @sqrt_D INT;

SET @A = 1;
SET @B = -3;
SET @C = 2;
SET @D = @B * @B - 4 * @A * @C;
SET @sqrt_D = CAST(SQRT(@D) AS INT);

IF @D < 0
    PRINT 'Корені відсутні';
ELSE
    IF @D = 0
        PRINT 'Єдиний корінь: ' + CAST(-@B / (2 * @A) AS NVARCHAR(50));
    ELSE
        IF @sqrt_D * @sqrt_D = @D
            BEGIN
                DECLARE @X1 FLOAT, @Ч2 FLOAT;
                SET @X1 = (-@B + @sqrt_D) / (2 * @A);
                SET @X2 = (-@B - @sqrt_D) / (2 * @A);
                PRINT CONCAT('Корені: X1 = ', @X1, ', X2 = ', @X2);
            END;
        ELSE
            PRINT 'Корені відсутні';


-- 10
DECLARE @AveragePrice MONEY;
DECLARE @BelowCount INT, @AboveCount INT;

SELECT @AveragePrice = AVG(Price)
FROM [Products];

SELECT @BelowCount = COUNT(1)
FROM [Products]
WHERE [Price] < @AveragePrice;

SELECT @AboveCount = COUNT(1)
FROM [Products]
WHERE [Price] > @AveragePrice;

PRINT CONCAT('Різниця: ', @AboveCount - @BelowCount);

-- 11
WITH [MaxPriceCTE] AS (SELECT [Manufacturer], MAX([Price]) AS 'MaxPrice'
                       FROM [Products]
                       GROUP BY [Manufacturer]),
     [SalesCTE] AS (SELECT p.[Manufacturer], SUM(o.[Price] * o.[ProductCount]) AS 'TotalSales'
                    FROM [Products] p
                             JOIN [Orders] o ON p.[Id] = o.[ProductId]
                    GROUP BY p.[Manufacturer])
SELECT TOP 1 IIF((SELECT COUNT(1)
                  FROM [MaxPriceCTE]
                  WHERE [MaxPrice] = (SELECT MAX([MaxPrice]) FROM [MaxPriceCTE])) > 1,
                 'Багато компаній, які випускають найдорожчі продукти',
                 CONCAT('Виробник, товар якого найдорожчий, - це ',
                        [MaxPriceCTE].[Manufacturer],
                        ', вже продано його товарів на суму - ',
                        [SalesCTE].[TotalSales])) AS 'Result'
FROM [MaxPriceCTE]
         JOIN [SalesCTE] ON [MaxPriceCTE].[Manufacturer] = [SalesCTE].[Manufacturer];
