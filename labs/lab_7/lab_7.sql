USE [productsdb]
GO


CREATE VIEW [OrdersProductsCustomers] AS
SELECT [Orders].[CreatedAt]     AS 'OrderDate',
       [Customers].[FirstName]  AS 'Customer',
       [Products].[ProductName] As 'Product'
FROM [Orders]
         INNER JOIN [Products] ON [Orders].[ProductId] = [Products].[Id]
         INNER JOIN [Customers] ON [Orders].[CustomerId] = [Customers].[Id];

SELECT *
FROM [OrdersProductsCustomers];

CREATE VIEW [OrdersProductsCustomers2] ([OrderDate], [Customer], [Product])
AS
SELECT [Orders].[CreatedAt],
       [Customers].[FirstName],
       [Products].[ProductName]
FROM [Orders]
         INNER JOIN [Products] ON [Orders].[ProductId] = [Products].[Id]
         INNER JOIN [Customers] ON [Orders].[CustomerId] = [Customers].[Id];

SELECT *
FROM [OrdersProductsCustomers2];

ALTER VIEW [OrdersProductsCustomers]
    AS SELECT [Orders].[CreatedAt]      AS 'OrderDate',
              [Customers].[FirstName]   AS 'Customer',
              [Products].[ProductName]  AS 'Product',
              [Products].[Manufacturer] AS 'Manufacturer'
       FROM [Orders]
                INNER JOIN [Products] ON [Orders].[ProductId] = [Products].[Id]
                INNER JOIN [Customers] ON [Orders].[CustomerId] = [Customers].[Id];

DROP VIEW [OrdersProductsCustomers];
DROP VIEW [OrdersProductsCustomers2];

-- REFRESHABLE VIEW
CREATE VIEW [ProductView]
AS
SELECT [ProductName] AS 'Product', [Manufacturer], [Price]
FROM [Products];

INSERT INTO [ProductView] ([Product], [Manufacturer], [Price])
VALUES ('Nokia 8', 'HDC Global', 18000)

SELECT *
FROM [ProductView];

UPDATE [ProductView]
SET [Price] = 15000
WHERE [Product] = 'Nokia 8';

DELETE
FROM [ProductView]
WHERE [Product] = 'Nokia 8';

-- TEMPORARY AND DERIVED TABLES
CREATE TABLE #ProductSummary
(
    [ProdId]   INT IDENTITY,
    [ProdName] NVARCHAR(20),
    [Price]    MONEY
);

INSERT INTO #ProductSummary
VALUES ('Nokia 8', 18000),
       ('IPhone 8', 56000);

SELECT *
FROM #ProductSummary;

SELECT [ProductId],
       SUM([ProductCount])           AS 'TotalCount',
       SUM([ProductCount] * [Price]) AS 'TotalSum'
INTO #OrdersSummary
FROM [Orders]
GROUP BY [ProductId];

SELECT [Products].[ProductName],
       #OrdersSummary.[TotalCount],
       #OrdersSummary.[TotalSum]
FROM [Products]
         JOIN #OrdersSummary ON [Products].[Id] = #OrdersSummary.[ProductId];

CREATE TABLE ##OrderDetails
(
    [ProductId]  INT,
    [TotalCount] INT,
    [TotalSum]   MONEY
);

INSERT INTO ##OrderDetails
SELECT [ProductId], SUM([ProductCount]), SUM([ProductCount] * [Price])
FROM [Orders]
GROUP BY [ProductId];

SELECT *
FROM ##OrderDetails;

-- DERIVED TABLES
WITH OrdersInfo AS
         (SELECT [ProductId],
                 SUM([ProductCount])           AS 'TotalCount',
                 SUM([ProductCount] * [Price]) AS 'TotalSum'
          FROM [Orders]
          GROUP BY [ProductId])
SELECT *
FROM [OrdersInfo]  -- OK
SELECT *
FROM [OrdersInfo]  -- ERROR
SELECT *
FROM [OrdersInfo]; -- ERROR
