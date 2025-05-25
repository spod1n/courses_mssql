/*
Перевірити роботу запитів з теоретичної частини.
На основі отриманих таблиць Products, Customers, Orders (запит на початку лабораторної роботи)
побудувати запити для вирішення наступних завдань:

1.	Побудувати запит INSERT для додавання 2 нових користувачів.
2.	Побудувати запит INSERT для додавання 2 нових товарів.
3.	Побудувати запит INSERT для додавання 3 нових товарів без вказання кількості.
4.	Побудувати запит INSERT для додавання 2 нових товарів фірми Apple.
5.	Побудувати запит INSERT для додавання 3 нових товарів фірми Apple без вказання кількості.
6.	Побудувати запит INSERT для додавання 5 нових замовлень (таблиця Orders) за участю нових товарів
    (вставлених в завданні 2 та 3) і нових користувачів (вставлених в завданні 1).
7.	Вивести два продукти з найнижчими цінами.
8.	Вивести другу п'ятірку продуктів з найвищою ціною.
9.	Вивести продукти, число залишків яких більше 4.
10.	Вивести продукти фірми Samsung з ціною вище 50000
11.	Вивести позиції з вартістю залишків більше 200000
12.	Вивести всі товари, у яких в найменуванні є 'Plus'
13.	Вивести всі товари, у яких в найменуванні немає цифр 7 і 8
14.	Вивести всі товари, найменування фірми яких не мають букву 'a'
15.	* Збільшити ціну останніх 3 створених продуктів на 2000 (без підзапиту)
16.	* Видалити останній створений продукт (без підзапиту)
17.	* Вивести таблицю з одним стовпцем, в якому дані будуть в наступному форматі:
На складі є N продукції під назвою M фірми F (N, M, F - повинні підставитися з таблиці)
(* - використовувати Google або матеріали лабораторної роботи № 4)

*/

-- 1
INSERT INTO [Customers] ([FirstName])
VALUES ('John'),
       ('Emily');

-- 2
INSERT INTO [Products] ([ProductName], [Manufacturer], [ProductCount], [Price])
VALUES ('iPhone 14', 'Apple', 5, 120000),
       ('Galaxy S23', 'Samsung', 3, 110000);

-- 3
INSERT INTO [Products] ([ProductName], [Manufacturer], [Price])
VALUES ('Pixel 7', 'Google', 90000),
       ('iPad Pro', 'Apple', 150000),
       ('Galaxy Tab S8', 'Samsung', 70000);

-- 4
INSERT INTO [Products] ([ProductName], [Manufacturer], [ProductCount], [Price])
VALUES ('MacBook Air', 'Apple', 4, 200000),
       ('AirPods Pro', 'Apple', 10, 25000);

-- 5
INSERT INTO [Products] ([ProductName], [Manufacturer], [Price])
VALUES ('Apple Watch', 'Apple', 30000),
       ('iMac', 'Apple', 250000),
       ('Apple TV', 'Apple', 15000);

-- 6
INSERT INTO [Orders] ([ProductId], [CustomerId], [CreatedAt], [ProductCount], [Price])
VALUES (1, 1, '2024-11-22', 1, 120000),
       (2, 2, '2024-11-22', 1, 110000),
       (3, 1, '2024-11-22', 2, 180000),
       (4, 2, '2024-11-22', 1, 150000),
       (5, 1, '2024-11-22', 1, 70000);

-- 7
SELECT TOP 2 *
FROM [Products]
ORDER BY [Price];

-- 8
SELECT *
FROM [Products]
ORDER BY [Price] DESC
OFFSET 5 ROWS FETCH NEXT 5 ROWS ONLY;

-- 9
SELECT *
FROM [Products]
WHERE [ProductCount] > 4;

-- 10
SELECT *
FROM [Products]
WHERE [Manufacturer] = 'Samsung'
  AND [Price] > 50000;

-- 11
SELECT *
FROM [Products]
WHERE [ProductCount] * [Price] > 200000;

-- 12
SELECT *
FROM [Products]
WHERE [ProductName] LIKE '%plus%';

-- 13
SELECT *
FROM [Products]
WHERE [ProductName] NOT LIKE '%7%'
  AND [ProductName] NOT LIKE '%8%';

-- 14
SELECT *
FROM [Products]
WHERE [Manufacturer] NOT LIKE '%a%';

-- 15
UPDATE [Products]
SET [Price] += 2000
WHERE [Id] >= IDENT_CURRENT('Products') - 2;

-- 16
DELETE FROM [Products]
WHERE [Id] = IDENT_CURRENT('Products');

-- 17
SELECT N'На складі є ' + CAST([ProductCount] AS NVARCHAR) +
       N' продукції під назвою ' + [ProductName] +
       N' фірми ' + [Manufacturer] AS 'StockInfo'
FROM [Products];
