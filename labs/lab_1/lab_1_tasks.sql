/*
1) Перевірити роботу всіх запитів.

2)	Створити БД з 2 таблиць Customers та Orders, які містять наступні поля:
Customers:
id – код користувача унікальний, ключовий, цілий, автоматичне зростання на 1
Age – вік користувача, ціле, за умовчанням 18, обмеження на вік від 18 до 100
FirstName – ім’я користувача, ненульове текстове поле на 20 символів
LastName – прізвище користувача, ненульове текстове поле на 20 символів,
Email – e-mail користувача, унікальне текстове поле,
Phone – телефон користувача, унікальне текстове поле на 13 символів
Orders:
Id – код замовлення унікальний, ключовий, цілий, автоматичне зростання на 1
CustomerId – код користувача, що придбав замовлення, зв’язок з полем id таблиці Customers,
             тип оновлення при видаленні – ставити код користувача з id 1
CreatedAt – дата створення замовлення.

3)	Наповнити таблиці значеннями (3-4 записи в Customers, 5-10 записів в Orders).

4)	Перевірити роботу БД при видаленні записів з Customers.
*/

-- 2
CREATE TABLE [Customers]
(
    [Id]        INT PRIMARY KEY IDENTITY (1, 1),
    [Age]       INT DEFAULT 18 CHECK (Age BETWEEN 18 AND 100),
    [FirstName] NVARCHAR(20)         NOT NULL,
    [LastName]  NVARCHAR(20)         NOT NULL,
    [Email]     NVARCHAR(255) UNIQUE NOT NULL,
    [Phone]     NVARCHAR(13) UNIQUE  NOT NULL
);

CREATE TABLE [Orders]
(
    [Id]         INT PRIMARY KEY IDENTITY (1,1),
    [CustomerId] INT NOT NULL,
    [CreatedAt]  DATETIME DEFAULT GETDATE(),
    FOREIGN KEY ([CustomerId]) REFERENCES [Customers] ([Id]) ON DELETE SET DEFAULT ON UPDATE CASCADE
);

ALTER TABLE [Orders]
    ADD CONSTRAINT DF_CustomerId DEFAULT 1 FOR [CustomerId];

-- 3
INSERT INTO [Customers] ([Age], [FirstName], [LastName], [Email], [Phone])
VALUES (25, 'John', 'Doe', 'john.doe@example.com', '+380123456789'),
       (30, 'Jane', 'Smith', 'jane.smith@example.com', '+380987654321'),
       (40, 'Mike', 'Johnson', 'mike.johnson@example.com', '+380567891234'),
       (22, 'Emily', 'Davis', 'emily.davis@example.com', '+380678912345');

INSERT INTO [Orders] ([CustomerId], [CreatedAt])
VALUES (1, '2024-11-01'),
       (2, '2024-11-05'),
       (3, '2024-11-10'),
       (2, '2024-11-15'),
       (4, '2024-11-20'),
       (1, '2024-11-21'),
       (3, '2024-11-22');

-- 4
SELECT *
FROM [Customers];

SELECT *
FROM [Orders];

DELETE
FROM [Customers]
WHERE Id = 2;

SELECT *
FROM [Customers];

SELECT *
FROM [Orders];
