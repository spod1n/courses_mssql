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
FROM [Products]
WHERE [Price] = (SELECT MIN([Price]) FROM [Products]);

SELECT [CreatedAt],
       [Price],
       (SELECT [ProductName]
        FROM [Products]
        WHERE [Products].[Id] = [Orders].[ProductId]) AS 'Product'
FROM [Orders];

SELECT [ProductName],
       [Manufacturer],
       [Price],
       (SELECT AVG([Price])
        FROM [Products] AS 'SubProds'
        WHERE [SubProds].[Manufacturer] = [Prods].[Manufacturer]) AS 'AvgPrice'
FROM [Products] AS 'Prods'
WHERE [Price] >
      (SELECT AVG([Price])
       FROM [Products] AS 'SubProds'
       WHERE [SubProds].[Manufacturer] = [Prods].[Manufacturer]);



