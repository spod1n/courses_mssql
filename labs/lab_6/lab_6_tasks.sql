/*
1.	Реалізувати всі запити з роботи
2.	Написати запит, щоб побачити, що купляв кожен з замовників (id замовника, ім’я замовника, назва товару).
3.	Написати запит, щоб показати, товари яких компаній купляли користувачі.
4.	Написати запит, щоб побачити суму замовлень по кожному замовнику (id замовника, ім’я замовника, сума).
5.	Вивести сумарну кількість продажів товарів фірми Apple (кількість і сума) за місяцами.
6.	Вивести суми, які витратили користувачі у 2021 році (id замовника, ім’я замовника, сума).
7.	Показати, всіх користувачів з товарами, які вони купляли, і кількістю цих товарів.
8.	Відобразити товари, які продавались на суму більше 100000 грн. в місяць.
9.	Вивести сумарну кількість продажів товарів фірми ‘Apple’ (кількість і сума) за місяцами.
10.	Знайти покупця, який витратив більше всього грошей у поточному місяці.
11.	*Написати запит, щоб побачити, який замовник/ки придбав більше всього товарів.
12.	*Хто з користувачів у 2021-му році замовив товарів Apple на найбільшу суму?
13.	*Які товари не продавав оператор з id=1 у 2021-му році.
*/

-- 2
SELECT c.[Id]          AS 'CustomerId',
       c.[FirstName]   AS 'CustomerName',
       p.[ProductName] AS 'ProductName'
FROM [Orders] o
         JOIN [Customers] c ON o.[CustomerId] = c.[Id]
         JOIN [Products] p ON o.[ProductId] = p.[Id];

-- 3
SELECT DISTINCT c.[FirstName]    AS 'CustomerName',
                p.[Manufacturer] AS 'Company'
FROM [Orders] o
         JOIN [Customers] c ON o.[CustomerId] = c.[Id]
         JOIN [Products] p ON o.[ProductId] = p.[Id];

-- 4
SELECT c.[Id]                            AS 'CustomerId',
       c.[FirstName]                     AS 'CustomerName',
       SUM(o.[Price] * o.[ProductCount]) AS 'TotalSpent'
FROM [Orders] o
         JOIN [Customers] c ON o.[CustomerId] = c.[Id]
GROUP BY c.[Id], c.[FirstName];

-- 5
SELECT DATEPART(YEAR, o.[CreatedAt])     AS 'Year',
       DATEPART(MONTH, o.[CreatedAt])    AS 'Month',
       SUM(o.[ProductCount])             AS 'TotalQuantity',
       SUM(o.[Price] * o.[ProductCount]) AS 'TotalRevenue'
FROM [Orders] o
         JOIN [Products] p ON o.[ProductId] = p.[Id]
WHERE p.[Manufacturer] = 'Apple'
GROUP BY DATEPART(YEAR, o.[CreatedAt]), DATEPART(MONTH, o.[CreatedAt])
ORDER BY 'Year', 'Month';

-- 6
SELECT c.[Id]                            AS 'CustomerId',
       c.[FirstName]                     AS 'CustomerName',
       SUM(o.[Price] * o.[ProductCount]) AS 'TotalSpent'
FROM [Orders] o
         JOIN [Customers] c ON o.[CustomerId] = c.[Id]
WHERE o.[CreatedAt] BETWEEN '2021-01-01' AND '2021-12-31'
GROUP BY c.[Id], c.[FirstName];

-- 7
SELECT c.[Id]                AS 'CustomerId',
       c.[FirstName]         AS 'CustomerName',
       p.[ProductName]       AS 'ProductName',
       SUM(o.[ProductCount]) AS 'TotalQuantity'
FROM [Orders] o
         JOIN [Customers] c ON o.[CustomerId] = c.[Id]
         JOIN [Products] p ON o.[ProductId] = p.[Id]
GROUP BY c.[Id], c.[FirstName], p.[ProductName];

-- 8
SELECT p.[ProductName],
       DATEPART(YEAR, o.[CreatedAt])     AS 'Year',
       DATEPART(MONTH, o.[CreatedAt])    AS 'Month',
       SUM(o.[Price] * o.[ProductCount]) AS 'TotalRevenue'
FROM [Orders] o
         JOIN [Products] p ON o.[ProductId] = p.[Id]
GROUP BY p.[ProductName], DATEPART(YEAR, o.[CreatedAt]), DATEPART(MONTH, o.[CreatedAt])
HAVING SUM(o.[Price] * o.[ProductCount]) > 100000
ORDER BY 'TotalRevenue' DESC;

-- 9
SELECT DATEPART(YEAR, o.[CreatedAt])     AS 'Year',
       DATEPART(MONTH, o.[CreatedAt])    AS 'Month',
       SUM(o.[ProductCount])             AS 'TotalQuantity',
       SUM(o.[Price] * o.[ProductCount]) AS 'TotalRevenue'
FROM [Orders] o
         JOIN [Products] p ON o.ProductId = p.Id
WHERE p.[Manufacturer] = 'Apple'
GROUP BY DATEPART(YEAR, o.[CreatedAt]), DATEPART(MONTH, o.[CreatedAt])
ORDER BY 'Year', 'Month';

-- 10
SELECT TOP 1 c.[Id]                            AS 'CustomerId',
             c.[FirstName]                     AS 'CustomerName',
             SUM(o.[Price] * o.[ProductCount]) AS 'TotalSpent'
FROM [Orders] o
         JOIN [Customers] c ON o.[CustomerId] = c.[Id]
WHERE o.[CreatedAt] >= DATEADD(DAY, 1 - DAY(GETDATE()), CAST(GETDATE() AS DATE))
  AND o.[CreatedAt] < DATEADD(MONTH, 1, DATEADD(DAY, 1 - DAY(GETDATE()), CAST(GETDATE() AS DATE)))
GROUP BY c.[Id], c.[FirstName]
ORDER BY 'TotalSpent' DESC;

-- 11
SELECT TOP 1 c.[Id]                AS 'CustomerId',
             c.[FirstName]         AS 'CustomerName',
             SUM(o.[ProductCount]) AS 'TotalProducts'
FROM [Orders] o
         JOIN [Customers] c ON o.[CustomerId] = c.[Id]
GROUP BY c.[Id], c.[FirstName]
ORDER BY 'TotalProducts' DESC;

-- 12
SELECT TOP 1 c.[Id]                            AS 'CustomerId',
             c.[FirstName]                     AS 'CustomerName',
             SUM(o.[Price] * o.[ProductCount]) AS 'TotalSpentOnApple'
FROM [Orders] o
         JOIN [Customers] c ON o.[CustomerId] = c.[Id]
         JOIN [Products] p ON o.[ProductId] = p.[Id]
WHERE p.[Manufacturer] = 'Apple'
  AND o.[CreatedAt] BETWEEN '2021-01-01' AND '2021-12-31'
GROUP BY c.[Id], c.[FirstName]
ORDER BY 'TotalSpentOnApple' DESC;

-- 13
SELECT p.[ProductName]
FROM [Products] p
         LEFT JOIN [Orders] o
                   ON o.[ProductId] = p.[Id]
                       AND o.[CustomerId] = 1
                       AND o.[CreatedAt] BETWEEN '2021-01-01' AND '2021-12-31'
WHERE o.[Id] IS NULL;
