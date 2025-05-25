/*
CREATE DATABASE [productsdb]
GO
USE productsdb
GO

DROP TABLE [Orders];
DROP TABLE [Products];
DROP TABLE [Customers];
*/

-- DDL
CREATE TABLE [Products]
(
    [Id]           INT IDENTITY PRIMARY KEY,
    [ProductName]  NVARCHAR(30) NOT NULL,
    [Manufacturer] NVARCHAR(20) NOT NULL,
    [ProductCount] INT DEFAULT 0,
    [Price]        MONEY        NOT NULL
);
CREATE TABLE [Customers]
(
    [Id]        INT IDENTITY PRIMARY KEY,
    [FirstName] NVARCHAR(30) NOT NULL
);
CREATE TABLE [Orders]
(
    [Id]           INT IDENTITY PRIMARY KEY,
    [ProductId]    INT   NOT NULL REFERENCES Products (Id),
    [CustomerId]   INT   NOT NULL REFERENCES Customers (Id),
    [CreatedAt]    DATE  NOT NULL,
    [ProductCount] INT DEFAULT 1,
    [Price]        MONEY NOT NULL
);

INSERT INTO [Products]
VALUES ('IPhone 11', 'Apple', 2, 21999),
       ('IPhone 12 Pro', 'Apple', 2, 56000),
       ('IPhone 12', 'Apple', 5, 28999),
       ('Galaxy S21 Ultra', 'Samsung', 2, 39999),
       ('Galaxy Z Fold2', 'Samsung', 1, 60000),
       ('Xiaomi Mi 11', 'Xiaomi', 2, 26999),
       ('OnePlus 8', 'OnePlus', 6, 17775);

INSERT INTO [Customers]
VALUES ('Tom'),
       ('Bob'),
       ('Sam');

INSERT INTO [Orders]
VALUES (4, 2, '2021-02-11', 2, 39999),
       (2, 2, '2021-02-11', 2, 56000),
       (4, 1, '2021-02-13', 1, 39999),
       (7, 1, '2021-02-14', 5, 17775);

/* BUILT-IN FUNCTIONS */
-- LEN
SELECT LEN('Apple');

-- LTRIM
SELECT LTRIM('Apple');

-- RTRIM
SELECT RTRIM('Apple');

-- CHARINDEX
SELECT CHARINDEX('pl', 'Apple');

-- PATINDEX
SELECT PATINDEX('%p_e%', 'Apple');

-- LEFT
SELECT LEFT('Apple', 3);

-- RIGHT
SELECT RIGHT('Apple', 3);

-- SUBSTRING
SELECT SUBSTRING('Galaxy S21 Ultra', 8, 2);

-- REPLACE
SELECT REPLACE('Galaxy S21 Ultra', 'S21 Ultra', 'Note 8');

-- REVERSE
SELECT REVERSE('123456789');

-- CONCAT
SELECT CONCAT('Tom', '', 'Smith');

-- LOWER
SELECT LOWER('Apple');

-- UPPER
SELECT UPPER('Apple');

-- SPACE
SELECT UPPER(LEFT(Manufacturer, 2))           AS Abbreviation,
       CONCAT(ProductName, '-', Manufacturer) AS FullProdName
FROM Products
ORDER BY Abbreviation;

-- ROUND
SELECT ROUND(1342.345, 2);
SELECT ROUND(1342.345, -2);

-- ISNUMERIC
SELECT ISNUMERIC(1342.345);
SELECT ISNUMERIC('1342.345');
SELECT ISNUMERIC('SQL');
SELECT ISNUMERIC('13-04-2020 ');

-- ABS
SELECT ABS(-123);

-- CEILING
SELECT CEILING(-123.45);
SELECT CEILING(123.45);

-- FLOOR
SELECT FLOOR(-123.45);
SELECT FLOOR(123.45);

-- SQUARE
SELECT SQUARE(5);

-- SQRT
SELECT SQRT(225);

-- RAND
SELECT RAND();
SELECT RAND();

-- COS
SELECT COS(1.0472);

-- SIN
SELECT SIN(1.5708);

-- TAN
SELECT TAN(0.7854);

-- GETDATE
SELECT GETDATE();

-- GETUTCDATE
SELECT GETUTCDATE();

-- SYSDATETIME
SELECT SYSDATETIME();

-- SYSUTCDATETIME
SELECT SYSUTCDATETIME();

-- SYSDATETIMEOFFSET
SELECT SYSDATETIMEOFFSET();

-- DAY
SELECT DAY(GETDATE());

-- MONTH
SELECT MONTH(GETDATE());

-- YEAR
SELECT YEAR(GETDATE());

-- DATENAME
SELECT DATENAME(month, GETDATE());

-- DATEPART
SELECT DATEPART(month, GETDATE());

-- DATEADD
SELECT DATEADD(month, 2, '2020-7-28');
SELECT DATEADD(day, 5, '2020-7-28');
SELECT DATEADD(day, -5, '2020-7-28');

-- DATEDIFF
SELECT DATEDIFF(year, '2020-7-28', '2021-9-28');
SELECT DATEDIFF(month, '2020-7-28', '2021-9-28');
SELECT DATEDIFF(day, '2020-7-28', '2021-9-28');

-- TODATETIMEOFFSET
SELECT TODATETIMEOFFSET('2020-7-28 1:10:22', '+03: 00');

-- SWITCHOFFSET;
SELECT SWITCHOFFSET(SYSDATETIMEOFFSET(), '+02: 30');

-- EOMONTH
SELECT EOMONTH('2020-02-05');
SELECT EOMONTH('2020-02-05', 3);

-- DATEFROMPARTS
SELECT DATEFROMPARTS(2020, 7, 28);

-- ISDATE
SELECT ISDATE('2020-07-28');
SELECT ISDATE('2020-28-07');
SELECT ISDATE('28-07-2020');
SELECT ISDATE('SQL');

SELECT *
FROM [Orders]
WHERE DATEDIFF(day, [CreatedAt], GETDATE()) = 16;

/* DATA CONVERSION */
-- CAST
SELECT [Id],
       CAST([CreatedAt] AS NVARCHAR) + '; total: ' + CAST([Price] * [ProductCount] AS NVARCHAR)
FROM [Orders];

-- CONVERT
SELECT CONVERT(NVARCHAR, [CreatedAt], 3),
       CONVERT(NVARCHAR, [Price] * [ProductCount], 1)
FROM [Orders];

SELECT CONVERT(INT, 'sql');

-- TRY_CONVERT
SELECT TRY_CONVERT(INT, 'sql');
SELECT TRY_CONVERT(INT, '22';

-- ADDITIONAL FUNCTIONS
SELECT STR(123.4567, 6, 2);
SELECT CHAR(219);
SELECT ASCII('И');
SELECT NCHAR(1067);
SELECT UNICODE('И');

-- CASE
SELECT [ProductName],
       [Manufacturer],
       CASE [ProductCount]
           WHEN 1 THEN 'Товар закінчується'
           WHEN 2 THEN 'Мало товару'
           WHEN 3 THEN 'Є в наявності'
           ELSE 'Багато товару'
           END AS 'EvaluateCount'
FROM [Products];

SELECT [ProductName],
       [Manufacturer],
       CASE
           WHEN Price > 50000 THEN 'Категорія A'
           WHEN Price BETWEEN 40000 AND 50000 THEN 'Категорія B'
           WHEN Price BETWEEN 30000 AND 40000 THEN 'Категорія C'
           ELSE 'Категорія D'
           END AS 'Category'
FROM [Products];

-- IIF
SELECT [ProductName],
       [Manufacturer],
       IIF([ProductCount] > 3, 'Багато товару', 'Мало товару')
FROM [Products];
