/*
CREATE DATABASE [productsdb]
GO

DROP DATABASE [productsdb]

DROP TABLE [Orders];
DROP TABLE [Products];
DROP TABLE [Customers];
*/

USE [productsdb]
GO

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
    [ProductId]    INT   NOT NULL REFERENCES [Products] ([Id]) ON DELETE CASCADE,
    [CustomerId]   INT   NOT NULL REFERENCES [Customers] ([Id]) ON DELETE CASCADE,
    [CreatedAt]    DATE  NOT NULL,
    [ProductCount] INT DEFAULT 1,
    [Price]        MONEY NOT NULL
);

INSERT [Products]
VALUES ('IPhone 7', 'Apple', 5, 5200);

INSERT INTO [Products] ([ProductName], [Price], [Manufacturer])
VALUES ('IPhone 6S', 4100, 'Apple');

INSERT INTO [Products]
VALUES ('IPhone 6', 'Apple', 3, 3600),
       ('Galaxy S8', 'Samsung', 2, 4600),
       ('Galaxy S8 Plus', 'Samsung', 1, 5600);

INSERT INTO [Products] ([ProductName], [Manufacturer], [ProductCount], [Price])
VALUES ('Mi6', 'Xiaomi', DEFAULT, 2800);

/* SELECT */
INSERT INTO [Products]
VALUES ('IPhone 11', 'Apple', 2, 21999),
       ('IPhone 12 Pro', 'Apple', 2, 56000),
       ('IPhone 12', 'Apple', 5, 28999),
       ('Galaxy S21 Ultra', 'Samsung', 2, 39999),
       ('Galaxy Z Fold2', 'Samsung', 1, 60000),
       ('Xiaomi Mi 11', 'Xiaomi', 2, 26999),
       ('OnePlus 8', 'OnePlus', 6, 17775);

SELECT *
FROM [Products];

SELECT [ProductName],
       [Price]
FROM [Products];

SELECT [ProductName] + '(' + [Manufacturer] + ')',
       [Price],
       [Price] * [ProductCount]
FROM [Products];

SELECT [ProductName] + '(' + [Manufacturer] + ')' AS 'ModelName',
       [Price],
       [Price] * [ProductCount]                   AS 'TotalSum'
FROM [Products];

/* DISTINCT */
SELECT DISTINCT [Manufacturer]
FROM [Products];

/* SELECT TO INTO */
SELECT [ProductName] + '(' + [Manufacturer] + ')' AS 'ModelName',
       [Price]
INTO [ProductSummary]
FROM [Products];

SELECT *
FROM [ProductSummary];

INSERT INTO [ProductSummary]
SELECT [ProductName] + '(' + [Manufacturer] + ')' AS 'ModelName',
       [Price]
FROM [Products]
;

/* SORTING */
SELECT *
FROM [Products]
ORDER BY [ProductName];

SELECT [ProductName],
       [ProductCount] * [Price] AS 'TotalSum'
FROM [Products]
ORDER BY [TotalSum];

SELECT [ProductName]
FROM [Products]
ORDER BY [ProductName] DESC;

SELECT [ProductName]
FROM [Products]
ORDER BY [ProductName] ASC;

SELECT [ProductName],
       [Price],
       [Manufacturer]
FROM [Products]
ORDER BY [Manufacturer], [ProductName];

SELECT [ProductName],
       [Price],
       [Manufacturer]
FROM [Products]
ORDER BY [Manufacturer] ASC,
         [ProductName] DESC;

SELECT [ProductName],
       [Price],
       [ProductCount]
FROM [Products]
ORDER BY [ProductCount] * [Price];

/* TOP */
SELECT TOP 4 [ProductName]
FROM [Products];

SELECT TOP 75 PERCENT [ProductName]
FROM [Products];

/* OFFSET & FETCH */
SELECT *
FROM [Products]
ORDER BY [Id]
OFFSET 2 ROWS;

SELECT *
FROM [Products]
ORDER BY Id
OFFSET 2 ROWS FETCH NEXT 3 ROWS ONLY;

/* FILTER */
SELECT *
FROM [Products]
WHERE [Manufacturer] = 'Samsung';

SELECT *
FROM [Products]
WHERE [Price] > 45000;

SELECT *
FROM [Products]
WHERE [Price] * [ProductCount] > 200000;

/* LOGICAL OPERATORS */
SELECT *
FROM [Products]
WHERE [Manufacturer] = 'Samsung'
  AND [Price] > 50000;

SELECT *
FROM [Products]
WHERE [Manufacturer] = 'Samsung'
   OR [Price] > 50000;

SELECT *
FROM [Products]
WHERE NOT [Manufacturer] = 'Samsung';

SELECT *
FROM [Products]
WHERE [Manufacturer] <> 'Samsung';

SELECT *
FROM [Products]
WHERE [Manufacturer] = 'Samsung'
   OR [Price] > 30000 AND [ProductCount] > 2;

SELECT *
FROM [Products]
WHERE ([Manufacturer] = 'Samsung' OR [Price] > 30000)
  AND [ProductCount] > 2;

/* IS NULL */
SELECT *
FROM [Products]
WHERE [ProductCount] IS NULL;

SELECT *
FROM [Products]
WHERE [ProductCount] IS NOT NULL;

SELECT *
FROM [Products]
WHERE [Manufacturer] IN ('Samsung', 'Xiaomi', 'Huawei');

SELECT *
FROM [Products]
WHERE [Manufacturer] = 'Samsung'
   OR [Manufacturer] = 'Xiaomi'
   OR [Manufacturer] = 'Huawei';

SELECT *
FROM [Products]
WHERE [Manufacturer] NOT IN ('Samsung', 'Xiaomi', 'Huawei')

/* BETWEEN */
SELECT *
FROM [Products]
WHERE [Price] BETWEEN 20000 AND 40000;

SELECT *
FROM [Products]
WHERE [Price] NOT BETWEEN 20000 AND 40000;

SELECT *
FROM [Products]
WHERE [Price] * [ProductCount] BETWEEN 100000 AND 200000;

/* LIKE */
-- WHERE ProductName LIKE 'Galaxy%'
-- WHERE ProductName LIKE 'Galaxy S_'
-- WHERE ProductName LIKE 'iPhone [78]'
-- WHERE ProductName LIKE 'iPhone [6-8]'
-- WHERE ProductName LIKE 'iPhone [^7]%'
-- WHERE ProductName LIKE 'iPhone [^1-6]%'

SELECT *
FROM [Products]
WHERE [ProductName] LIKE 'IPhone [6-8]%';

/* UPDATE */
UPDATE [Products]
SET [Price] = [Price] + 5000;

UPDATE [Products]
SET [Manufacturer] = 'Samsung Inc.'
WHERE [Manufacturer] = 'Samsung';

UPDATE [Products]
SET [Manufacturer] = 'Apple Inc.'
FROM (SELECT TOP 2 [Products].[Id] FROM [Products] WHERE [Manufacturer] = 'Apple') AS Selected
WHERE [Products].[Id] = [Selected].[Id];

/* DELETE */
DELETE [Products]
WHERE [Id] = 9;

DELETE [Products]
WHERE [Manufacturer] = 'Xiaomi'
  AND [Price] < 15000;

DELETE [Products]
FROM (SELECT TOP 2 *
      FROM [Products]
      WHERE Manufacturer = 'Apple]') AS Selected
WHERE [Products].[Id] = [Selected].[Id];

DELETE [Products];
