/*
1.	Проробити всі приклади тригерів
2.	Створити тригер на видалення даних з таблиці Orders, який буде зберігати дані про номер
    видаленого замовлення та його дату
3.	Створити тригер на видалення даних з таблиці Customers. Який замість видалення запису змінить
    його статус IsDeleted (НЕОБХІДНО!!! Попередньо створити дане поле у таблиці).
4.	Створити тригер на Insert до Customers, який буде вписувати в поле LastName копію введеного поля FirstName
5.	Створити тригери для таблиць Customers та Products для збереження в таблиці History (створити,
    якщо не створили під час аналізу теоретичних відомостей (стор. 3) дані про стан запису перед
    зміною командами Insert, Delete та Update.
6.	Модифікувати таблицю Customers і додати поле DeletedAt тип DATETIME, яке буде містити дату і час
    спроби видалення запису. Модифікувати тригер на видалення даних з таблиці Customers,
    який замість видалення запису не тільки змінить його статус IsDeleted (див. завдання 3),
    а й розмістить дату і час видалення в полі DeletedAt.

Додаткове завдання
7.	*Створити тригер на Insert до Customers, який на основі функції dbo.want_name1 (ДИВИСЬ слайд 30 лекція 11)
    буде додавати лише частину Імені користувача до першого пробілу  (треба відключати тригер з теоретичних відомостей,
    для чистоти спрацювання).
8.	*Реалізувати тригером рознесння Повного імені на складові при введенні даних:
a.	Створити користувацькі функції для отримання з повного імені окремо Ім’я та окремо По батькові.
    Наприклад, функцію dbo.want_name2 для імені, dbo.want_name3 – для По батькові
b.	Модифікувати таблицю Customers і додати поля Name2, Name3 (відповідно для імені і для По батькові)
c.	Модифікувати тригер на Insert до Customers, який на основі користувацьких функцій dbo.want_name1 буде додавати
    прізвище в LastName, Ім’я - в Name2, По батькові – в Name3
*/

-- 2
CREATE TABLE [DeletedOrdersHistory]
(
    [OrderId]   INT      NOT NULL,
    [DeletedAt] DATETIME NOT NULL
);

CREATE TRIGGER [trg_AfterDelete_Orders]
    ON [Orders]
    AFTER DELETE
    AS
BEGIN
    INSERT INTO [DeletedOrdersHistory] ([OrderId], [DeletedAt])
    SELECT [Id], GETDATE()
    FROM DELETED;
END
GO

-- 3
ALTER TABLE [Customers]
    ADD [IsDeleted] BIT DEFAULT 0;

CREATE TRIGGER [trg_InsteadOfDelete_Customers]
    ON [Customers]
    INSTEAD OF DELETE
    AS
BEGIN
    UPDATE [Customers]
    SET [IsDeleted] = 1
    FROM [Customers]
             JOIN [DELETED] ON [Customers].[Id] = DELETED.[Id];
END
GO

-- 4
ALTER TABLE [Customers]
    ADD [LastName] NVARCHAR(30);

CREATE TRIGGER [trg_AfterInsert_Customers]
    ON [Customers]
    AFTER INSERT
    AS
BEGIN
    UPDATE [Customers]
    SET [LastName] = INSERTED.[FirstName]
    FROM [Customers]
             JOIN INSERTED ON [Customers].[Id] = INSERTED.[Id];
END
GO

-- 5
CREATE TABLE [History]
(
    [TableName] NVARCHAR(50),
    [Operation] NVARCHAR(10),
    [RecordId]  INT,
    [Data]      NVARCHAR(MAX),
    [ChangedAt] DATETIME DEFAULT GETDATE()
);

CREATE TRIGGER [trg_AfterInsert_Customers]
    ON [Customers]
    AFTER INSERT
    AS
BEGIN
    INSERT INTO [History] ([TableName], [Operation], [RecordId], [Data])
    SELECT 'Customers',
           'INSERT',
           [Id],
           CONCAT('FirstName: ', [FirstName], ', LastName: ', [LastName], ', IsDeleted: ', [IsDeleted])
    FROM INSERTED
END
GO

CREATE TRIGGER [trg_AfterUpdate_Customers]
    ON [Customers]
    AFTER UPDATE
    AS
BEGIN
    INSERT INTO [History] ([TableName], [Operation], [RecordId], [Data])
    SELECT 'Customers',
           'UPDATE',
           [Id],
           CONCAT('FirstName: ', [FirstName], ', LastName: ', [LastName], ', IsDeleted: ', [IsDeleted])
    FROM INSERTED
END
GO

CREATE TRIGGER [trg_AfterDelete_Customers]
    ON [Customers]
    AFTER DELETE
    AS
BEGIN
    INSERT INTO [History] ([TableName], [Operation], [RecordId], [Data])
    SELECT 'Customers',
           'DELETE',
           [Id],
           CONCAT('FirstName: ', [FirstName], ', LastName: ', [LastName], ', IsDeleted: ', [IsDeleted])
    FROM DELETED
END
GO

CREATE TRIGGER [trg_AfterInsert_Products]
    ON [Products]
    AFTER INSERT
    AS
BEGIN
    INSERT INTO [History] ([TableName], [Operation], [RecordId], [Data])
    SELECT 'Products',
           'INSERT',
           Id,
           CONCAT('ProductName: ', [ProductName], ', Manufacturer: ', [Manufacturer], ', Price: ', [Price], ', Count: ',
                  [ProductCount])
    FROM INSERTED
END
GO

-- 6
ALTER TABLE [Customers]
    ADD [DeletedAt] DATETIME;

ALTER TRIGGER [trg_InsteadOfDelete_Customers]
    ON [Customers]
    INSTEAD OF DELETE
    AS
    BEGIN
        UPDATE [Customers]
        SET [IsDeleted] = 1,
            [DeletedAt] = GETDATE()
        FROM [Customers]
                 INNER JOIN DELETED ON [Customers].[Id] = DELETED.[Id]
    END
GO

-- 7
CREATE FUNCTION [dbo].[want_name1](@FullName NVARCHAR(100))
    RETURNS NVARCHAR(30)
AS
BEGIN
    RETURN LEFT(@FullName, CHARINDEX(' ', @FullName + ' ') - 1);
END
GO

CREATE TRIGGER [trg_AfterInsert_Customers_WithWantName]
    ON [Customers]
    AFTER INSERT
    AS
BEGIN
    UPDATE [Customers]
    SET [FirstName] = [dbo].[want_name1](INSERTED.[FirstName])
    FROM [Customers]
             INNER JOIN INSERTED ON [Customers].[Id] = INSERTED.[Id]
END
GO

-- 8
ALTER TABLE [Customers]
    ADD [Name2] NVARCHAR(30),
        [Name3] NVARCHAR(30);

CREATE FUNCTION dbo.want_name2(@FullName NVARCHAR(100))
    RETURNS NVARCHAR(30)
AS
BEGIN
    RETURN LEFT(@FullName, CHARINDEX(' ', @FullName + ' ') - 1)
END
GO

CREATE FUNCTION dbo.want_name3(@FullName NVARCHAR(100))
    RETURNS NVARCHAR(30)
AS
BEGIN
    RETURN LTRIM(SUBSTRING(@FullName, CHARINDEX(' ', @FullName + ' ') + 1, LEN(@FullName)))
END
GO

CREATE TRIGGER [trg_AfterInsert_Customers_FullName]
    ON [Customers]
    AFTER INSERT
    AS
BEGIN
    UPDATE [Customers]
    SET [Name2]    = [dbo].[want_name2](INSERTED.[FirstName]),
        [Name3]    = [dbo].[want_name3](INSERTED.[FirstName]),
        [LastName] = [dbo].[want_name1](INSERTED.[FirstName])
    FROM [Customers]
             JOIN INSERTED ON [Customers].[Id] = INSERTED.[Id]
END
GO