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


SELECT *
FROM [Orders],
     [Customers];

SELECT *
FROM [Orders],
     [Customers]
WHERE [Orders].[CustomerId] = [Customers].[Id];

SELECT [Customers].[FirstName],
       [Products].[ProductName],
       [Orders].[CreatedAt]
FROM [Orders],
     [Customers],
     [Products]
WHERE [Orders].[CustomerId] = [Customers].[Id]
  AND [Orders].[ProductId] = [Products].[Id];

SELECT C.[FirstName],
       P.[ProductName],
       O.[CreatedAt]
FROM [Orders] AS O,
     [Customers] AS C,
     [Products] AS P
WHERE O.[CustomerId] = C.[Id]
  AND O.[ProductId] = P.[Id];

SELECT C.[FirstName],
       P.[ProductName],
       O.*
FROM [Orders] AS O,
     [Customers] AS C,
     [Products] AS P
WHERE O.[CustomerId] = C.[Id]
  AND O.[ProductId] = P.[Id]

-- INNER JOIN
SELECT [Orders].[CreatedAt],
       [Orders].[ProductCount],
       [Products].[ProductName]
FROM [Orders]
         JOIN [Products] ON [Products].[Id] = [Orders].[ProductId];

SELECT O.[CreatedAt],
       O.[ProductCount],
       P.[ProductName]
FROM [Orders] AS O
         JOIN [Products] AS P
              ON P.[Id] = O.[ProductId];

SELECT [Orders].[CreatedAt],
       [Customers].[FirstName],
       [Products].[ProductName]
FROM [Orders]
         JOIN [Products] ON [Products].[Id] = [Orders].[ProductId]
         JOIN [Customers] ON [Customers].[Id] = [Orders].[CustomerId];

SELECT [Orders].[CreatedAt],
       [Customers].[FirstName],
       [Products].[ProductName]
FROM [Orders]
         JOIN [Products] ON [Products].[Id] = [Orders].[ProductId]
         JOIN [Customers] ON [Customers].[Id] = [Orders].[CustomerId]
WHERE [Products].[Price] < 45000
ORDER BY [Customers].[FirstName];

SELECT [Orders].[CreatedAt],
       [Customers].[FirstName],
       [Products].[ProductName]
FROM [Orders]
         JOIN [Products] ON [Products].[Id] = [Orders].[ProductId] AND [Products].[Manufacturer] = 'Apple'
         JOIN [Customers] ON [Customers].[Id] = [Orders].[CustomerId]
ORDER BY [Customers].[FirstName];

-- OUTER JOIN
SELECT [FirstName],
       [CreatedAt],
       [ProductCount],
       [Price],
       [ProductId]
FROM [Orders]
         LEFT JOIN [Customers] ON [Orders].[CustomerId] = [Customers].[Id];

-- INNER JOIN
SELECT [FirstName],
       [CreatedAt],
       [ProductCount],
       [Price]
FROM [Customers]
         JOIN [Orders] ON [Orders].[CustomerId] = [Customers].[Id];

-- LEFT JOIN
SELECT [FirstName],
       [CreatedAt],
       [ProductCount],
       [Price]
FROM [Customers]
         LEFT JOIN [Orders] ON [Orders].[CustomerId] = [Customers].[Id];

SELECT [FirstName],
       [CreatedAt],
       [ProductCount],
       [Price],
       [ProductId]
FROM [Orders]
         RIGHT JOIN [Customers] ON [Orders].[CustomerId] = [Customers].[Id];

SELECT [Customers].[FirstName],
       [Orders].[CreatedAt],
       [Products].[ProductName],
       [Products].[Manufacturer]
FROM [Orders]
         LEFT JOIN [Customers] ON [Orders].[CustomerId] = [Customers].[Id]
         LEFT JOIN [Products] ON [Orders].[ProductId] = [Products].[Id];

SELECT [Customers].[FirstName],
       [Orders].[CreatedAt],
       [Products].[ProductName],
       [Products].[Manufacturer]
FROM [Orders]
         LEFT JOIN [Customers] ON [Orders].[CustomerId] = [Customers].[Id]
         LEFT JOIN [Products] ON [Orders].[ProductId] = [Products].[Id]
WHERE [Products].[Price] < 45000
ORDER BY [Orders].[CreatedAt];

SELECT [FirstName]
FROM [Customers]
         LEFT JOIN [Orders] ON [Customers].[Id] = [Orders].[CustomerId]
WHERE [Orders].[CustomerId] IS NULL;

SELECT [Customers].[FirstName],
       [Orders].[CreatedAt],
       [Products].[ProductName],
       [Products].[Manufacturer]
FROM [Orders]
         JOIN [Products] ON [Orders].[ProductId] = [Products].[Id] AND [Products].[Price] < 45000
         LEFT JOIN [Customers] ON [Orders].[CustomerId] = [Customers].[Id]
ORDER BY [Orders].[CreatedAt];

-- CROSS JOIN
SELECT *
FROM [Orders]
         CROSS JOIN [Customers];

SELECT *
FROM [Orders],
     [Customers];

-- GROUPING IN CONNECTIONS
SELECT [FirstName],
       COUNT([Orders].[Id])
FROM [Customers]
         JOIN [Orders] ON [Orders].[CustomerId] = [Customers].[Id]
GROUP BY [Customers].[Id], [Customers].[FirstName];

SELECT [FirstName],
       COUNT([Orders].[Id])
FROM [Customers]
         LEFT JOIN [Orders] ON [Orders].[CustomerId] = [Customers].[Id]
GROUP BY [Customers].[Id], [Customers].[FirstName];

SELECT [Products].[ProductName],
       [Products].[Manufacturer],
       SUM([Orders].[ProductCount] * [Orders].[Price]) AS 'Units'
FROM [Products]
         LEFT JOIN [Orders] ON [Orders].[ProductId] = [Products].[Id]
GROUP BY [Products].[Id], [Products].[ProductName], [Products].[Manufacturer];
