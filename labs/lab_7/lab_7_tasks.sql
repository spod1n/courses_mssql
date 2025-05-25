/*
1.	Створити view, який буде містити дані про всі замовлення з вказанням імені користувача
2.	Створити view, який буде містити сумарну кількість замовлень за кожним замовником.
3.	Створити view, який буде містити кількість замовлень за кожен день.
4.	За допомогою view з завдання 2 знайти замовника з найбільшою кількістю замовлень.
5.	За допомогою view з завдання 3 знайти день з найбільшою кількістю замовлень.
6.	Зробити на базі таблиці Products view, який дозволить правити тільки назву продукту і виробника.
    Перевірити роботу через UPDATE.
7.	*Додати в таблицю Customers поле isDelted, яке буде означати, що записи з значенням 1 вважаються видаленими.
    Створити оновлюваний view, який не буде показувати видалені записи.
*/

-- 1
CREATE VIEW [OrdersWithCustomers] AS
SELECT
    o.[Id] AS 'OrderId',
    o.[ProductId],
    o.[CustomerId],
    c.[FirstName] AS 'CustomerName',
    o.[CreatedAt],
    o.[ProductCount],
    o.[Price]
FROM [Orders] o
JOIN [Customers] c ON o.[CustomerId] = c.[Id];

-- 2
CREATE VIEW [TotalOrdersPerCustomer] AS
SELECT
    c.[Id] AS 'CustomerId',
    c.[FirstName] AS 'CustomerName',
    COUNT(o.[Id]) AS 'TotalOrders'
FROM [Customers] c
LEFT JOIN [Orders] o ON o.[CustomerId] = c.[Id]
GROUP BY c.[Id], c.[FirstName];

-- 3
CREATE VIEW [TotalOrdersPerDay] AS
SELECT
    o.[CreatedAt] AS 'OrderDate',
    COUNT(o.[Id]) AS 'TotalOrders'
FROM [Orders] o
GROUP BY o.[CreatedAt];

-- 4
SELECT TOP 1 *
FROM [TotalOrdersPerCustomer]
ORDER BY [TotalOrders] DESC;

-- 5
SELECT TOP 1 *
FROM [TotalOrdersPerDay]
ORDER BY [TotalOrders] DESC;

-- 6
CREATE VIEW [EditableProductDetails]
WITH SCHEMABINDING
AS
SELECT
    [Id],
    [ProductName],
    [Manufacturer]
FROM [dbo].[Products];

UPDATE [EditableProductDetails]
SET [ProductName] = 'New Product Name',
    [Manufacturer] = 'New Manufacturer'
WHERE [Id] = 1;

-- 7
ALTER TABLE [Customers]
ADD [isDeleted] BIT DEFAULT 0;

CREATE VIEW [ActiveCustomers]
AS
SELECT
    [Id],
    [FirstName]
FROM [Customers]
WHERE [isDeleted] = 0
WITH CHECK OPTION;

UPDATE [ActiveCustomers]
SET [FirstName] = 'Updated Name'
WHERE [Id] = 1;

UPDATE [Customers]
SET [isDeleted] = 1
WHERE [Id] = 1;

SELECT * FROM [ActiveCustomers];
