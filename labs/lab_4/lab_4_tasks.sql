/*
1.	Вивести товари, довжина назв яких більше 15.
2.	Вивести замовлення тільки за суботи і неділі останнього місяця
3.	Вивести замовлення з датою у форматі dd-mm-yy (реалізувати декілька варіантів:
    А) через функції DAY, MONTH, YEAR,
    Б) через функцію DATEPART,
    В) через функцію FORMAT (приклад дивитись у лекції)).
4.	*Вивести в окремі поля назву товару та його модель (модель починається з першого пробілу у повній назві).
5.	*Вивести товари, які не мають моделі (модель починається з пробілу і має число у повній назві)
6.	* Вивести лише ті місяці років, де сумарний виторг був більше 100000.
7.	* Додати в таблицю продуктів поле PriceDate NVARCHAR (30). Записати в це поле ціну і поточну дату за прикладом:
    якщо була ціна 25000, а дата 2022-01-11, то вписати в PriceDate «25000 грн. на 11-01-2022».
8.	* Написати запит для виведення випадкових чисел в діапазоні [-50;50].
9.	* Додати в таблицю продуктів поля дати випуску та днів гарантії.
    Вивести товари, до закінчення гарантії яких залишилось менше 2 днів.
10.	*Вивести в додатковому стовбці інформацію, щодо сумарної вартості залишку по позиції.
    Якщо вартість більше 200000, то написати "Вартість > 200000",
    якщо менша 200000, то написати "Вартість < 200000",
    якщо дорівнює 0, то написати "ПЕРЕВІРИТИ КІЛЬКІСТЬ ЗАЛИШКІВ".
    Для товарів компанії ‘Apple’ в кінці кожної фрази додати у текст "(ЦЕ APPLE!!!)".
11.	Проробити розв’язок задач.
*/

-- 1
SELECT [ProductName]
FROM [Products]
WHERE LEN([ProductName]) > 15;

-- 2
SELECT *
FROM [Orders]
WHERE DATEPART(WEEKDAY, [CreatedAt]) IN (1, 7)
  AND MONTH([CreatedAt]) = MONTH(GETDATE()) - 1
  AND YEAR([CreatedAt]) = YEAR(GETDATE());

-- 3.A
SELECT [Id],
       [ProductId],
       [CustomerId],
       CONCAT(FORMAT(DAY([CreatedAt]), '00'), '-', FORMAT(MONTH([CreatedAt]), '00'), '-',
              RIGHT(YEAR([CreatedAt]), 2)) AS 'FormattedDate'
FROM [Orders];

-- 3.Б
SELECT [Id],
       [ProductId],
       [CustomerId],
       CONCAT(
               RIGHT('00' + CAST(DATEPART(DAY, [CreatedAt]) AS NVARCHAR), 2), '-',
               RIGHT('00' + CAST(DATEPART(MONTH, [CreatedAt]) AS NVARCHAR), 2), '-',
               RIGHT(YEAR([CreatedAt]), 2)
       ) AS 'FormattedDate'
FROM [Orders];

-- 3.В
SELECT [Id],
       [ProductId],
       [CustomerId],
       FORMAT([CreatedAt], 'dd-MM-yy') AS 'FormattedDate'
FROM [Orders];

-- 4
SELECT [ProductName],
       LEFT([ProductName], CHARINDEX(' ', [ProductName]) - 1)                   AS 'Name',
       RIGHT([ProductName], LEN([ProductName]) - CHARINDEX(' ', [ProductName])) AS 'Model'
FROM [Products]
WHERE CHARINDEX(' ', [ProductName]) > 0;

-- 5
SELECT *
FROM [Products]
WHERE CHARINDEX(' ', [ProductName]) = 0
   OR [ProductName] LIKE '% [0-9]%';

-- 6
SELECT YEAR([CreatedAt])             AS 'Year',
       MONTH([CreatedAt])            AS 'Month',
       SUM([Price] * [ProductCount]) AS 'TotalRevenue'
FROM [Orders]
GROUP BY YEAR([CreatedAt]), MONTH([CreatedAt])
HAVING SUM([Price] * [ProductCount]) > 100000;

-- 7
ALTER TABLE [Products]
    ADD [PriceDate] NVARCHAR(30);

UPDATE [Products]
SET [PriceDate] = CONCAT(CAST([Price] AS NVARCHAR), ' грн. на ', FORMAT(GETDATE(), 'dd-MM-yyyy'));

-- 8
SELECT (ABS(CHECKSUM(NEWID())) % 101 - 50) AS 'RandomNumber';

-- 9
ALTER TABLE [Products]
    ADD [ReleaseDate] DATE, [WarrantyDays] INT;

UPDATE [Products]
SET [ReleaseDate]  = DATEADD(DAY, -100, GETDATE()),
    [WarrantyDays] = 120;

SELECT *
FROM [Products]
WHERE DATEDIFF(DAY, GETDATE(), DATEADD(DAY, [WarrantyDays], [ReleaseDate])) < 2;

-- 10
SELECT [ProductName],
       [ProductCount] * [Price] AS 'TotalValue',
       CASE
           WHEN [ProductCount] * [Price] > 200000 THEN
               CASE
                   WHEN [Manufacturer] = 'Apple' THEN 'Вартість > 200000 (ЦЕ APPLE!!!)'
                   ELSE 'Вартість > 200000'
                   END
           WHEN [ProductCount] * [Price] < 200000 THEN
               CASE
                   WHEN [Manufacturer] = 'Apple' THEN 'Вартість < 200000 (ЦЕ APPLE!!!)'
                   ELSE 'Вартість < 200000'
                   END
           ELSE 'ПЕРЕВІРИТИ КІЛЬКІСТЬ ЗАЛИШКІВ'
           END                  AS 'Status'
FROM [Products];

-- 11.1
-- Розділити назву компанії на дві частини (до першого пробіла і решта), використовуючи LEN, CHARINDEX, LEFT, RIGHT
SELECT [Manufacturer]
FROM [Products];

SELECT IIF(CHARINDEX(' ', [Manufacturer]) = 0, [Manufacturer],
           LEFT([Manufacturer], CHARINDEX(' ', [Manufacturer]) - 1)) 'Перша частина'
FROM [Products];

SELECT IIF(CHARINDEX(' ', [Manufacturer]) = 0, ' ',
           RIGHT([Manufacturer],
                 LEN([Manufacturer]) - CHARINDEX(' ', [Manufacturer]))
       ) 'Друга частина'
FROM [Products];

SELECT IIF(CHARINDEX(' ', [Manufacturer]) = 0,
           [Manufacturer],
           LEFT([Manufacturer], CHARINDEX(' ', [Manufacturer]) - 1))    'Перша частина',

       IIF(CHARINDEX(' ', [Manufacturer]) = 0,
           ' ',
           RIGHT([Manufacturer],
                 LEN([Manufacturer]) - CHARINDEX(' ', [Manufacturer]))) 'Друга частина'
FROM [Products];

SELECT LEFT([Manufacturer], CHARINDEX(' ', [Manufacturer] + ' ', 1)),
       RIGHT([Manufacturer], LEN([Manufacturer]) - CHARINDEX(' ', [Manufacturer] + ' ', 1) + 1)
FROM [Products];

-- 11.2
-- Розділити назву компанії на дві частини (до першого пробілу і решта)
SELECT SUBSTRING(
               [Manufacturer],
               1,
               CHARINDEX(' ', [Manufacturer] + ' '))
           'Перша частина',

       SUBSTRING(
               [Manufacturer],
               CHARINDEX(' ', [Manufacturer] + ' ') + 1,
               LEN([Manufacturer]) - CHARINDEX(' ', [Manufacturer] + ' ') + 1)
           'Друга частина'
FROM [Products];

SELECT LEFT([Manufacturer], CHARINDEX(' ', [Manufacturer] + ' ', 1)),
       RIGHT([Manufacturer], LEN([Manufacturer]) - CHARINDEX(' ', [Manufacturer] + ' ', 1) + 1)
FROM [Products];

-- 12.
-- Побудувати таблицю з полями:
-- FullName, - повне ім’я (може бути записано як всі три значення - Прізвище Ім'я По батькові,
--                         так і два значення - Прізвище Ім'я, так і одне - Прізвище),
-- FirstName - прізвище,
-- SecondName – ім’я,
-- Third_Name - По батькові.

-- Вивести на екран 4 стовбці:
-- 1) FullName,
-- 2) Прізвище - це перша частина поля FullName до пробіла,
-- 3) Ім’я – це друга частина поля FullName між пробілами,
-- 4) По батькові - це третя частина поля FullName після другого пробіла.
CREATE TABLE [MyTable]
(
    [FullName]   NVARCHAR(100),
    [FirstName]  NVARCHAR(50),
    [SecondName] NVARCHAR(50),
    [Third_Name] NVARCHAR(50)
);
INSERT INTO [MyTable] ([FullName])
VALUES ('Артамонов'),
       ('Артамонов Євген'),
       ('Артамонов Євген Борисович');

SELECT [FullName],
       CASE
           WHEN CHARINDEX(' ', [FullName]) > 0
               THEN LEFT([FullName], CHARINDEX(' ', [FullName]) - 1)
           ELSE [FullName]
           END AS 'Прізвище',
       CASE
           WHEN CHARINDEX(' ', [FullName]) > 0
               THEN CASE
                        WHEN CHARINDEX(' ', [FullName], CHARINDEX(' ', [FullName]) + 1) > 0
                            THEN SUBSTRING([FullName], CHARINDEX(' ', [FullName]) + 1,
                                           CHARINDEX(' ', [FullName], CHARINDEX(' ', [FullName]) + 1) -
                                           CHARINDEX(' ', [FullName]) - 1)
                        ELSE ''
               END
           ELSE ''
           END AS 'Ім''я',
       CASE
           WHEN CHARINDEX(' ', [FullName], CHARINDEX(' ', [FullName]) + 1) > 0
               THEN SUBSTRING([FullName], CHARINDEX(' ', [FullName], CHARINDEX(' ', [FullName]) + 1) + 1,
                              LEN([FullName]))
           ELSE ''
           END AS 'По батькові'
FROM [MyTable];

-- ЗА ДОПОМОГОЮ IIF
SELECT [FullName],
       IIF(CHARINDEX(' ', [FullName]) > 0, LEFT([FullName], CHARINDEX(' ', [FullName]) - 1), [FullName]) AS 'Прізвище',
       IIF(CHARINDEX(' ', [FullName]) > 0, IIF(CHARINDEX(' ', [FullName], CHARINDEX(' ', [FullName]) + 1) > 0,
                                               SUBSTRING([FullName], CHARINDEX(' ', [FullName]) + 1,
                                                         CHARINDEX(' ', [FullName], CHARINDEX(' ', [FullName]) + 1) -
                                                         CHARINDEX(' ', [FullName]) - 1), ''), '')       AS 'Ім''я',
       IIF(CHARINDEX(' ', [FullName], CHARINDEX(' ', [FullName]) + 1) > 0,
           SUBSTRING([FullName], CHARINDEX(' ', [FullName], CHARINDEX(' ', [FullName]) + 1) + 1,
                     LEN([FullName])),
           '')                                                                                           AS 'По батькові'
FROM [MyTable];

-- 13
-- Організувати фізичний запис (UPDATE) з одного поля таблиці до завдання
-- Заповнити в таблиці поля:
-- FirstName - прізвище,
-- SecondName – ім’я,
-- Third_Name - По батькові.
UPDATE [MyTable]
SET [FirstName]  = CASE
                       WHEN CHARINDEX(' ', [FullName]) > 0
                           THEN LEFT([FullName], CHARINDEX(' ', [FullName]) - 1)
                       ELSE [FullName]
    END,
    [SecondName] = CASE
                       WHEN CHARINDEX(' ', [FullName]) > 0
                           THEN CASE
                                    WHEN CHARINDEX(' ', [FullName], CHARINDEX(' ', [FullName]) + 1) > 0
                                        THEN SUBSTRING([FullName], CHARINDEX(' ', [FullName]) + 1,
                                                       CHARINDEX(' ', [FullName], CHARINDEX(' ', [FullName]) + 1) -
                                                       CHARINDEX(' ', [FullName]) - 1)
                                    ELSE ''
                           END
                       ELSE ''
        END,
    [Third_Name] = CASE
                       WHEN CHARINDEX(' ', [FullName], CHARINDEX(' ', [FullName]) + 1) > 0
                           THEN SUBSTRING([FullName], CHARINDEX(' ', [FullName], CHARINDEX(' ', [FullName]) + 1) + 1,
                                          LEN([FullName]))
                       ELSE ''
        END;

-- ЗА ДОПОМОГОЮ IIF
UPDATE [MyTable]
SET [FirstName]  = IIF(CHARINDEX(' ', [FullName]) > 0, LEFT([FullName], CHARINDEX(' ', [FullName]) - 1), [FullName]),
    [SecondName] = IIF(CHARINDEX(' ', [FullName]) > 0,
                       IIF(CHARINDEX(' ', [FullName], CHARINDEX(' ', [FullName]) + 1) > 0, SUBSTRING([FullName],
                                                                                                     CHARINDEX(' ', [FullName]) +
                                                                                                     1,
                                                                                                     CHARINDEX(' ', [FullName], CHARINDEX(' ', [FullName]) + 1) -
                                                                                                     CHARINDEX(' ', [FullName]) -
                                                                                                     1), ''), ''),
    [Third_Name] = IIF(CHARINDEX(' ', [FullName], CHARINDEX(' ', [FullName]) + 1) > 0,
                       SUBSTRING([FullName], CHARINDEX(' ', [FullName], CHARINDEX(' ', [FullName]) + 1) + 1,
                                 LEN([FullName])), '');
