/*
1.	Проробити всі приклади з роботи
2.	Створити функцію для отримання суми закупок за кодом замовника.
3.	Створити функцію для отримання імені замовника за його id. Використати дану функцію для таблиці Orders.
4.	Створити функцію для отримання максимальної вартості замовлення за id замовника (CustomerId).
    Використати дану функцію для таблиці Customers.
5.	*Створити користувацькі функції для отримання з повного імені окремо значення Імені та окремо По батькові
    (dbo.want_name2 для імені, dbo.want_name3 – для По батькові).
6.	*Модифікувати таблицю Customers і додати поля Name2, Name3 (відповідно для Імені і для По батькові),
    куди через UPDATE з використанням нових функцій занести данні.
7.	*Створити наступні функції та перевірити їх роботу
a.	підрахунок сум продажів по id продукту
b.	підрахунок числа замовлень по id продукту
c.	підрахунок сум продажів по id продукту за останніх 10 днів
d.	підрахунок числа замовлень по id продукту за останніх 10 днів
e.	підрахунок сум продажів по id продукту за останніх N днів
f.	підрахунок числа замовлень по id продукту за останніх N днів
8.	*Об'єднати всі 6 функцій, вибираючи виконання по переданому параметру
*/

-- 2
CREATE FUNCTION [GetTotalPurchasesByCustomerId](@CustomerId INT)
    RETURNS MONEY
AS
BEGIN
    DECLARE @Total MONEY;

    SELECT @Total = SUM([Price] * [ProductCount])
    FROM [Orders]
    WHERE [CustomerId] = @CustomerId;

    RETURN ISNULL(@Total, 0)
END
GO

SELECT dbo.[GetTotalPurchasesByCustomerId](1) AS 'TotalPurchases';

-- 3
CREATE FUNCTION [GetCustomerNameById](@CustomerId INT)
    RETURNS NVARCHAR(30)
AS
BEGIN
    DECLARE @CustomerName NVARCHAR(30);

    SELECT @CustomerName = [FirstName]
    FROM [Customers]
    WHERE Id = @CustomerId;

    RETURN @CustomerName
END
GO

SELECT o.[Id]                                    AS 'OrderId',
       dbo.[GetCustomerNameById](o.[CustomerId]) AS 'CustomerName',
       o.[Price]
FROM [Orders] o;

-- 4
CREATE FUNCTION [GetMaxOrderPriceByCustomerId](@CustomerId INT)
    RETURNS MONEY
AS
BEGIN
    DECLARE @MaxPrice MONEY;

    SELECT @MaxPrice = MAX([Price])
    FROM [Orders]
    WHERE [CustomerId] = @CustomerId;

    RETURN ISNULL(@MaxPrice, 0)
END
GO

SELECT c.[Id]                                   AS 'CustomerId',
       c.[FirstName],
       dbo.[GetMaxOrderPriceByCustomerId](c.Id) AS 'MaxOrderPrice'
FROM [Customers] c;

-- 5
CREATE OR ALTER FUNCTION [want_name2](@FullName NVARCHAR(60))
    RETURNS NVARCHAR(30)
AS
BEGIN
    IF CHARINDEX(' ', @FullName) = 0
        RETURN @FullName;
    RETURN LEFT(@FullName, CHARINDEX(' ', @FullName) - 1);
END
GO

CREATE OR ALTER FUNCTION [want_name3](@FullName NVARCHAR(60))
    RETURNS NVARCHAR(30)
AS
BEGIN
    IF CHARINDEX(' ', @FullName) = 0
        RETURN NULL
    RETURN SUBSTRING(@FullName, CHARINDEX(' ', @FullName) + 1, LEN(@FullName))
END
GO

SELECT [dbo].[want_name2]([FirstName]) AS 'FirstName',
       [dbo].[want_name3]([FirstName]) AS 'MiddleName'
FROM [Customers];

-- 6
ALTER TABLE Customers
    ADD Name2 NVARCHAR(30),
        Name3 NVARCHAR(30)
GO

UPDATE [Customers]
SET [Name2] = [dbo].[want_name2]([FirstName]),
    [Name3] = [dbo].[want_name3]([FirstName])
GO

SELECT *
FROM Customers;

-- 7
-- a
CREATE FUNCTION [GetSalesSumByProductId](@ProductId INT)
    RETURNS MONEY
AS
BEGIN
    DECLARE @Total MONEY;

    SELECT @Total = SUM([Price] * [ProductCount])
    FROM [Orders]
    WHERE [ProductId] = @ProductId;

    RETURN ISNULL(@Total, 0)
END
GO

-- b
CREATE FUNCTION [GetOrderCountByProductId](@ProductId INT)
    RETURNS INT
AS
BEGIN
    RETURN (SELECT COUNT(1) FROM [Orders] WHERE [ProductId] = @ProductId)
END
GO

-- c
CREATE FUNCTION [GetSalesSumByProductIdLast10Days](@ProductId INT)
    RETURNS MONEY
AS
BEGIN
    DECLARE @Total MONEY;
    SELECT @Total = SUM([Price] * [ProductCount])
    FROM [Orders]
    WHERE [ProductId] = @ProductId
      AND [CreatedAt] >= DATEADD(DAY, -10, GETDATE());
    RETURN ISNULL(@Total, 0);
END
GO

-- d
CREATE FUNCTION [GetOrderCountByProductIdLast10Days](@ProductId INT)
    RETURNS INT
AS
BEGIN
    RETURN (SELECT COUNT(1)
            FROM [Orders]
            WHERE [ProductId] = @ProductId
              AND [CreatedAt] >= DATEADD(DAY, -10, GETDATE()));
END
GO

-- e
CREATE FUNCTION [GetSalesSumByProductIdLastNDays](@ProductId INT, @NDays INT)
    RETURNS MONEY
AS
BEGIN
    DECLARE @Total MONEY;
    SELECT @Total = SUM([Price] * [ProductCount])
    FROM [Orders]
    WHERE [ProductId] = @ProductId
      AND [CreatedAt] >= DATEADD(DAY, -@NDays, GETDATE());
    RETURN ISNULL(@Total, 0)
END
GO

-- f
CREATE FUNCTION [GetOrderCountByProductIdLastNDays](@ProductId INT, @NDays INT)
    RETURNS INT
AS
BEGIN
    RETURN (SELECT COUNT(1)
            FROM [Orders]
            WHERE [ProductId] = @ProductId
              AND [CreatedAt] >= DATEADD(DAY, -@NDays, GETDATE()));
END
GO

SELECT [Id],
       [dbo].[GetSalesSumByProductId](Id)                AS 'TotalSales',
       [dbo].[GetOrderCountByProductId](Id)              AS 'TotalOrders',
       [dbo].[GetSalesSumByProductIdLast10Days](Id)      AS 'SalesLast10Days',
       [dbo].[GetOrderCountByProductIdLast10Days](Id)    AS 'OrdersLast10Days',
       [dbo].[GetSalesSumByProductIdLastNDays](Id, 30)   AS 'SalesLastNDays',
       [dbo].[GetOrderCountByProductIdLastNDays](Id, 30) AS 'OrdersLastNDays'
FROM [Products];

-- 8
CREATE FUNCTION GetProductStats(@ProductId INT, @NDays INT, @Option NVARCHAR(10))
    RETURNS MONEY
AS
BEGIN
    DECLARE @Result MONEY;

    IF @Option = 'SalesSum'
        SET @Result = dbo.GetSalesSumByProductIdLastNDays(@ProductId, @NDays);
    ELSE
        IF @Option = 'OrderCount'
            SET @Result = dbo.GetOrderCountByProductIdLastNDays(@ProductId, @NDays);
        ELSE
            IF @Option = 'TotalSales'
                SET @Result = dbo.GetSalesSumByProductId(@ProductId);
            ELSE
                IF @Option = 'TotalOrders'
                    SET @Result = dbo.GetOrderCountByProductId(@ProductId);
                ELSE
                    SET @Result = NULL;
    RETURN @Result
END
GO

SELECT [Id],
       [dbo].[GetProductStats](Id, 10, 'SalesSum') AS 'SalesLast10Days',
       [dbo].[GetProductStats](Id, 30, 'OrderCount') AS 'OrdersLast30Days',
       [dbo].[GetProductStats](Id, 0, 'TotalSales') AS 'TotalSales',
       [dbo].[GetProductStats](Id, 0, 'TotalOrders') AS 'TotalOrders'
FROM [Products];

SELECT [Id],
       [dbo].[GetProductStats](Id, 10, 'SalesSum') AS 'SalesLast10Days'
FROM [Products]
WHERE [dbo].[GetProductStats](Id, 10, 'SalesSum') > 1000
ORDER BY [SalesLast10Days] DESC;
