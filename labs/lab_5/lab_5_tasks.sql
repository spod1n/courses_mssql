/*
1.	Додати при виведенні таблиці Orders поле з загальною кількістю замовлень в базі.
2.	Додати при виведенні таблиці Products поле з середньою вартістю товарів.
3.	Вивести товари, довжина назв яких довше середнього значення довжини.
4.	Вивести фірми продукції для кожного замовлення
5.	Вивести телефон і ім’я замовника у кожному замовленні (для цього в таблицю Cudtomers ввести поле Phone,
    якщо користувач не буде мати телефону (NULL або ‘’), то виводити в запиті повідомлення ‘Телефон відсутній’)
6.	Додати при виведенні користувачів поле з кількістю проведених замовлень
7.	Додати при виведенні таблиці Orders поле з загальною кількістю замовлень на день замовлення поточного продукту  (НЕ плутати з 1)
8.	Додати при виведенні таблиці Products поле з середньою вартістю товарів даної фірми (НЕ плутати з 2)
9.	Додати при виведенні користувачів поле з сумою за всіма замовленнями за поточний місяць.
10.	*Вивести таблицю, яка підрахує кількість замовлень, що містять товари фірми Apple,
    та в окремому полі вкажуть текст «Залишилось мало», якщо кількість залишку продукції даної фірми менше 5
11.	* Додати при виведенні таблиці Products поле з ім’ям користувача, який купив цей товар останнім.
12.	*На основі запиту п. 2 отримати різницю між середньою вартістю товарів та вартістю поточного товара
13.	** Показати товари, кількість залишків яких менше сумарної кількості продажів за цим товаром за лютий місяць.
14.	* Додати при виведенні користувачів (див. п.9) поле з сумою за замовленнями користувача за поточний місяць.
15.	* Вивести, який відсоток виторгу у замовленнях дня склало кожне замовлення.
*/

-- 1
SELECT *,
       (SELECT COUNT(1) FROM [Orders]) AS 'TotalOrders'
FROM [Orders];

-- 2
SELECT *,
       (SELECT AVG([Price]) FROM [Products]) AS 'AveragePrice'
FROM [Products];

-- 3
SELECT *
FROM [Products]
WHERE LEN([ProductName]) > (SELECT AVG(LEN([ProductName])) FROM [Products]);

-- 4
SELECT o.*,
       p.[Manufacturer]
FROM [Orders] o
         JOIN [Products] p ON o.[ProductId] = p.[Id];

-- 5
ALTER TABLE [Customers]
    ADD [Phone] NVARCHAR(20)
GO

SELECT o.*,
       c.[FirstName],
       ISNULL(c.[Phone], 'Телефон відсутній') AS 'Phone'
FROM [Orders] o
         JOIN [Customers] c ON o.[CustomerId] = c.[Id];

-- 6
SELECT c.*,
       (SELECT COUNT(1) FROM [Orders] o WHERE o.[CustomerId] = c.[Id]) AS 'OrderCount'
FROM [Customers] c;

-- 7
SELECT o.*,
       (SELECT COUNT(1)
        FROM [Orders] o2
        WHERE o2.[ProductId] = o.[ProductId]
          AND o2.[CreatedAt] = o.[CreatedAt]) AS 'DailyProductOrders'
FROM [Orders] o;

-- 8
SELECT p.*,
       (SELECT AVG([Price])
        FROM [Products] p2
        WHERE p2.[Manufacturer] = p.[Manufacturer]) AS 'AvgPriceForManufacturer'
FROM [Products] p;

-- 9
SELECT c.*,
       (SELECT SUM(o.[Price] * o.[ProductCount])
        FROM [Orders] o
        WHERE o.[CustomerId] = c.[Id]
          AND o.[CreatedAt] >= DATEADD(DAY, 1 - DAY(GETDATE()), CAST(GETDATE() AS DATE))
          AND o.[CreatedAt] < DATEADD(MONTH, 1, DATEADD(DAY, 1 - DAY(GETDATE()), CAST(GETDATE() AS DATE))))
           AS 'MonthlyTotal'
FROM [Customers] c;

-- 10
SELECT COUNT(o.[Id])                                                                        AS 'AppleOrdersCount',
       IIF((SELECT SUM(p.[ProductCount])
            FROM [Products] p
            WHERE p.[Manufacturer] = 'Apple') < 5, 'Залишилось мало', 'Достатньо залишків') AS 'StockStatus'
FROM [Orders] o
         JOIN [Products] p ON o.[ProductId] = p.[Id]
WHERE p.[Manufacturer] = 'Apple'

-- 11
SELECT p.*,
       (SELECT TOP 1 c.[FirstName]
        FROM [Orders] o
                 JOIN [Customers] c ON o.[CustomerId] = c.[Id]
        WHERE o.[ProductId] = p.[Id]
        ORDER BY o.[CreatedAt] DESC) AS 'LastBuyer'
FROM [Products] p;

-- 12
SELECT p.*,
       p.[Price] - (SELECT AVG([Price]) FROM [Products]) AS 'PriceDifference'
FROM [Products] p;

-- 13
SELECT p.*
FROM [Products] p
WHERE p.[ProductCount] < (SELECT SUM(o.[ProductCount])
                          FROM [Orders] o
                          WHERE o.[ProductId] = p.[Id]
                            AND MONTH(o.[CreatedAt]) = 2);

-- 14
SELECT c.*,
       (SELECT SUM(o.[Price] * o.[ProductCount])
        FROM [Orders] o
        WHERE o.[CustomerId] = c.[Id]
          AND o.[CreatedAt] >= DATEADD(DAY, 1 - DAY(GETDATE()), CAST(GETDATE() AS DATE))
          AND o.[CreatedAt] < DATEADD(MONTH, 1, DATEADD(DAY, 1 - DAY(GETDATE()), CAST(GETDATE() AS DATE))))
           AS 'MonthlyTotal'
FROM [Customers] c;


-- 15
SELECT o.*,
       (o.[Price] * o.[ProductCount] * 100.0) /
       (SELECT SUM(o2.[Price] * o2.[ProductCount])
        FROM [Orders] o2
        WHERE o2.[CreatedAt] = o.[CreatedAt]) AS 'RevenuePercentage'
FROM [Orders] o;