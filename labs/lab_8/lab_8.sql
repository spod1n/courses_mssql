DECLARE @name NVARCHAR(20);

DECLARE @name NVARCHAR(20), @age INT;

DECLARE @name NVARCHAR(20), @age INT;
SET @name = 'Tom';
SET @age = 18;

PRINT 'Hello World';

DECLARE @name NVARCHAR(20), @age INT;
SET @name = 'Tom';
SET @age = 18;
PRINT 'Name: ' + @Name;
PRINT 'Age: ' + CONVERT(CHAR, @age);

DECLARE @name NVARCHAR(20), @age INT;
SET @Name = 'Tom';
SET @age = 18;
SELECT @name, @age;

-- VARIABLES IN QUERIES
DECLARE @maxPrice MONEY,
    @minPrice MONEY,
    @dif MONEY,
    @count INT;

SET @count = (SELECT SUM(ProductCount)
              FROM Orders);

SELECT @MinPrice = MIN(Price),
       @maxPrice = MAX(Price)
FROM [Products];

SET @dif = @maxPrice - @minPrice;

PRINT 'Всього продано: ' + STR(@count, 5) + ' товарa (ів)';
PRINT 'Різниця між максимальною і мінімальною ціною: ' + STR(@dif);


DECLARE @sum MONEY,
    @id INT,
    @prodid INT,
    @name NVARCHAR(20);

SET @Id = 2;

SELECT @sum = SUM([Orders].[Price] * [Orders].[ProductCount]),
       @Name = [Products].[ProductName],
       @prodid = [Products].[Id]
FROM [Orders]
         INNER JOIN [Products] ON [ProductId] = [Products].[Id]
GROUP BY [Products].[ProductName], [Products].[Id]
HAVING [Products].[Id] = @id;

PRINT 'Товар ' + @name + ' Проданий на суму ' + STR(@sum);

-- TABULAR VARIABLES
DECLARE @ABrends TABLE
                 (
                     [ProductId]   INT,
                     [ProductName] NVARCHAR(20)
                 );
INSERT INTO @ABrends
VALUES (1, 'iPhone 8'),
       (2, 'Samsumg Galaxy S8')
SELECT *
FROM @ABrends;

-- CONDITIONAL EXPRESSIONS
DECLARE @lastDate DATE;
SELECT @lastDate = MAX([CreatedAt]);
FROM [Orders];

IF DATEDIFF(day, @lastDate, GETDATE()) > 10
    PRINT 'За останні десять днів не було замовлень';


DECLARE @lastDate DATE;
SELECT @lastDate = MAX([CreatedAt])
FROM [Orders];

IF DATEDIFF(day, @lastDate, GETDATE()) > 10
    PRINT 'За останні десять днів не було замовлень'
ELSE
    PRINT 'За останні десять днів були замовлення';


DECLARE @lastDate DATE,
    @count INT, @sum MONEY;

SELECT @lastDate = MAX([CreatedAt]),
       @count = SUM([ProductCount]),
       @sum = SUM([ProductCount] * [Price])
FROM [Orders]

IF @count > 0
    BEGIN
        PRINT 'Дата останнього замовлення: ' + CONVERT(NVARCHAR, @lastDate)
        PRINT 'Продано ' + CONVERT(NVARCHAR, @count) + ' одиниць (и)'
        PRINT 'На загальну суму ' + CONVERT(NVARCHAR, @sum)
    END;
ELSE
    PRINT 'Замовлення в базі даних відсутні';


-- CYCLES
DECLARE @rate FLOAT=0.015,
    @period INT=5,
    @sum MONEY=1000;

WHILE @period > 0
    BEGIN
        SET @sum = @sum + @sum * @rate
        PRINT 'Сума на кінець року = ' + CONVERT(varchar, @sum) + '$'
        SET @period = @period - 1
    END;


DECLARE @number INT,
    @factorial INT
SET @factorial = 1;
SET @number = 5;

WHILE @number > 0
    BEGIN
        SET @factorial = @factorial * @number
        SET @number = @number - 1
    END;
PRINT @factorial
PRINT 1 * 2 * 3 * 4 * 5


DECLARE @rate FLOAT=0.015,
    @period INT=5,
    @sum MONEY=1000,
    @year_rah INT=1

WHILE @period > 0
    BEGIN
        SET @sum = @sum + @sum * @rate
        PRINT 'Сума на кінець ' + CONVERT(varchar, @year_rah) +
              '-го року = ' + CONVERT(varchar, @sum) + '$'
        SET @period = @period - 1
        SET @year_rah += 1
    END;


CREATE TABLE #Accounts
(
    [CreatedAt] DATE,
    [Balance]   MONEY
);

DECLARE @rate FLOAT=0.015,
    @period INT=5,
    @sum MONEY=1000,
    @date_begin DATE=GETDATE();

WHILE @period > 0
    BEGIN
        INSERT INTO #Accounts VALUES (@date_begin, @sum)
        SET @date_begin = DATEADD(year, 1, @date_begin)
        SET @sum = @sum + @sum * @rate
        SET @period = @period - 1
    END;
SELECT *
FROM #Accounts;

-- BREAK & CONTINUE
DECLARE @number INT;
SET @number = 1;

WHILE @number < 10
    BEGIN
        PRINT CONVERT(NVARCHAR, @number)
        SET @number = @number + 1
        IF @number = 7
            BREAK;
        IF @number = 4
            CONTINUE;
        PRINT 'Кінець ітерації'
    END;

-- ERROR HANDLING
    -- ERROR_NUMBER
    -- ERROR_MESSAGE
    -- ERROR_SEVERITY
    -- ERROR_STATE

CREATE TABLE Accounts
(
    [FirstName] NVARCHAR NOT NULL,
    [Age]       INT      NOT NULL
);

BEGIN TRY
    INSERT INTO Accounts VALUES (NULL, NULL);
    PRINT 'Дані успішно додані!';
END TRY
BEGIN CATCH
    PRINT 'Error ' + CONVERT(VARCHAR, ERROR_NUMBER()) + ': ' + ERROR_MESSAGE();
END CATCH

