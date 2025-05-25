/*
1.	Опрацювати всі наведені запити
2.	Показати мінімальну вартість товару
3.	Показати максимальну кількість залишків товару (ProductCount)
4.	Вивести сумарну вартість залишків (кількість*вартість) по кожній компанії виробнику.
5.	Вивести середню вартість залишків (кількість*вартість) по кожній фірмі
6.	Вивести дані, які покажуть скільки є позицій з кількістю залишків 1, скільки з кількістю залишків 2 і т.д.
7.	Показати фірми, сумарна вартість товарів яких більше 100000 грн.
8.	Показати фірми, сумарна кількість залишків товарів яких менше 10.
9.	Вивести кількості позицій з однаковою сумарною вартістю (кількість*вартість)
10.	*Виведіть вартість залишків (кількість*вартість) з представленням суми по кожній фірмі (використовувати ROLLUP)
11.	Вивести виторг за днями.
12.	Показати ті дні, де виторг був більше 50000.
13.	Показати id замовників, які робили більше 2 замовлень в один з днів.
14.	Показати id замовників, які робили замовлення в один з днів на суму більше 50000 (кількість*вартість в таблиці Orders).
15.	Показати середню вартість замовлень за днями для замовлень, сумарна вартість яких більше 10000 грн.
16.	Скільки було продано товарів за останній місяць (останній місяць підібрати з урахуванням дат замовлень).
17.	*Без підзапитів знайти дні, коли було продано більше 3 товарів компанії OnePlus.
*/

-- 2
SELECT MIN([Price]) AS 'MinPrice'
FROM [Products];

-- 3
SELECT MAX([ProductCount]) AS 'MaxProductCount'
FROM [Products];

-- 4
SELECT [Manufacturer],
       SUM([ProductCount] * [Price]) AS 'TotalValue'
FROM [Products]
GROUP BY [Manufacturer];

-- 5
SELECT [Manufacturer],
       AVG([ProductCount] * [Price]) AS 'AvgValue'
FROM [Products]
GROUP BY [Manufacturer];

-- 6
SELECT [ProductCount],
       COUNT(1) AS 'PositionCount'
FROM [Products]
GROUP BY [ProductCount];

-- 7
SELECT [Manufacturer]
FROM [Products]
GROUP BY [Manufacturer]
HAVING SUM([ProductCount] * [Price]) > 100000;

-- 8
SELECT [Manufacturer]
FROM [Products]
GROUP BY [Manufacturer]
HAVING SUM([ProductCount]) < 10;

-- 9
SELECT ([ProductCount] * [Price]) AS 'TotalValue',
       COUNT(1)                   AS 'PositionCount'
FROM [Products]
GROUP BY ([ProductCount] * [Price])
HAVING COUNT(1) > 1;

-- 10
SELECT [Manufacturer],
       SUM([ProductCount] * [Price]) AS 'TotalValue'
FROM [Products]
GROUP BY ROLLUP ([Manufacturer]);

-- 11
SELECT [CreatedAt],
       SUM([ProductCount] * [Price]) AS 'DailyRevenue'
FROM [Orders]
GROUP BY [CreatedAt];

-- 12
SELECT [CreatedAt]
FROM [Orders]
GROUP BY [CreatedAt]
HAVING SUM([ProductCount] * [Price]) > 50000;

-- 13
SELECT [CustomerId],
       [CreatedAt]
FROM [Orders]
GROUP BY [CustomerId], [CreatedAt]
HAVING COUNT(1) > 2;

-- 14
SELECT [CustomerId],
       [CreatedAt]
FROM [Orders]
GROUP BY [CustomerId], [CreatedAt]
HAVING SUM([ProductCount] * [Price]) > 50000;

-- 15
SELECT [CreatedAt],
       AVG([ProductCount] * [Price]) AS 'AvgOrderValue'
FROM [Orders]
GROUP BY [CreatedAt]
HAVING SUM([ProductCount] * [Price]) > 10000;

-- 16
SELECT SUM([ProductCount]) AS 'TotalSold'
FROM [Orders]
WHERE [CreatedAt] >= DATEADD(MONTH, -1, (SELECT MAX([CreatedAt]) FROM Orders));

-- 17
SELECT o.[CreatedAt]
FROM [Orders] o
         JOIN [Products] p ON o.[ProductId] = p.[Id]
WHERE p.[Manufacturer] = 'OnePlus'
GROUP BY o.[CreatedAt]
HAVING SUM(o.[ProductCount]) > 3;
