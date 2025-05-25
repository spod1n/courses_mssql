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
    [ProductId]    INT   NOT NULL REFERENCES [Products] ([Id]),
    [CustomerId]   INT   NOT NULL REFERENCES [Customers] ([Id]),
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


-- AVG: Знаходить середнє значення
-- SUM: Знаходить суму значень
-- MIN: Знаходить найменше значення
-- MAX: Знаходить найбільше значення
-- COUNT: Знаходить кількість рядків в запиті

/* AVG */
SELECT AVG([Price]) AS 'Average_Price'
FROM [Products];

SELECT AVG([Price])
FROM [Products]
WHERE [Manufacturer] = 'Apple';

SELECT AVG([Price] * [ProductCount])
FROM [Products];

/* COUNT */
SELECT COUNT(*)
FROM [Products];

SELECT COUNT([Manufacturer])
FROM [Products];

/* MIN & MAX */
SELECT MIN([Price])
FROM [Products];

SELECT MAX([Price])
FROM [Products];

/* SUM */
SELECT SUM([ProductCount])
FROM [Products];

/* ALL & DISTINCT */
SELECT AVG(DISTINCT [ProductCount]) AS 'Average_Price'
FROM [Products];

SELECT AVG(ALL [ProductCount]) AS 'Average_Price'
FROM [Products];

/* COMBINING FUNCTIONS */
SELECT COUNT(*)            AS 'ProdCount',
       SUM([ProductCount]) AS 'TotalCount',
       MIN([Price])        AS 'MinPrice',
       MAX(Price)          AS 'MaxPrice',
       AVG([Price])        AS 'AvgPrice'
FROM [Products];

/* GROUP BY */
SELECT [Manufacturer],
       COUNT(*) AS 'ModelsCount'
FROM [Products]
GROUP BY [Manufacturer];

SELECT [Manufacturer],
       COUNT(*) AS 'ModelsCount'
FROM [Products];

SELECT [Manufacturer],
       [ProductCount],
       COUNT(*) AS 'ModelsCount'
FROM [Products]
GROUP BY [Manufacturer], [ProductCount];

/* GROUP FILTER */
SELECT [Manufacturer],
       COUNT(*) AS 'ModelsCount'
FROM [Products]
GROUP BY [Manufacturer]
HAVING COUNT(*) > 1;

SELECT [Manufacturer],
       COUNT(*) AS 'ModelsCount'
FROM [Products]
WHERE [Price] * [ProductCount] > 80000
GROUP BY [Manufacturer]
HAVING COUNT(*) > 1;

SELECT [Manufacturer],
       COUNT(*)            AS 'Models',
       SUM([ProductCount]) AS 'Units'
FROM [Products]
WHERE [Price] * [ProductCount] > 80000
GROUP BY [Manufacturer]
HAVING SUM([ProductCount]) > 2
ORDER BY [Units] DESC;

/* EXTENSION GROUP */
SELECT [Manufacturer],
       COUNT(*)            AS 'Models',
       SUM([ProductCount]) AS 'Units'
FROM [Products]
GROUP BY [Manufacturer]
WITH ROLLUP;

SELECT [Manufacturer],
       COUNT(*)            AS 'Models',
       SUM([ProductCount]) AS 'Units'
FROM [Products]
GROUP BY ROLLUP ([Manufacturer]);

SELECT [Manufacturer],
       COUNT(*)            AS 'Models',
       SUM([ProductCount]) AS 'Units'
FROM [Products]
GROUP BY [Manufacturer], [ProductCount]
WITH ROLLUP;

SELECT [Manufacturer],
       COUNT(*)          AS 'Models',
       SUM(ProductCount) AS 'Units'
FROM [Products]
GROUP BY [Manufacturer], [ProductCount]
WITH CUBE;
