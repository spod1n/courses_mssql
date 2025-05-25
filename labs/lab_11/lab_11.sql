CREATE TRIGGER [Products_INSERT_UPDATE]
    ON [Products]
    AFTER INSERT, UPDATE
    AS
    UPDATE [Products]
    SET [Price] = [Price] + [Price] * 0.38
    WHERE [Id] = (SELECT [Id] FROM [inserted])
GO

DROP TRIGGER [Products_INSERT_UPDATE]
GO

DISABLE TRIGGER [Products_INSERT_UPDATE] ON [Products]
GO

ENABLE TRIGGER [Products_INSERT_UPDATE] ON [Products]
GO

CREATE TABLE [History]
(
    [Id]        INT IDENTITY PRIMARY KEY,
    [ProductId] INT           NOT NULL,
    [Operation] NVARCHAR(200) NOT NULL,
    [CreateAt]  DATETIME      NOT NULL DEFAULT GETDATE(),
)
GO

CREATE TRIGGER [Products_INSERT]
    ON [Products]
    AFTER INSERT
    AS
    INSERT INTO [History] ([ProductId], [Operation])
    SELECT [Id],
           'долучення товар' + [ProductName] + 'фірма' + [Manufacturer]
    FROM INSERTED
GO

INSERT INTO [Products] ([ProductName], [Manufacturer], [ProductCount], [Price])
VALUES ('iPhone X', 'Apple', 2, 79900);

SELECT *
FROM [History];

CREATE TRIGGER [Products_DELETE]
    ON [Products]
    AFTER DELETE
    AS
    INSERT INTO [History] ([ProductId], [Operation])
    SELECT [Id],
           'Вилучений товар' + [ProductName] + 'фірма' + [Manufacturer]
    FROM DELETED
GO

DELETE
FROM [Products]
WHERE [Id] = 2;

CREATE TRIGGER [Products_UPDATE]
    ON [Products]
    AFTER UPDATE
    AS
    INSERT INTO [History] ([ProductId], [Operation])
    SELECT [Id], 'Оновлений товар' + [ProductName] + 'фірма' + [Manufacturer]
    FROM INSERTED
GO

CREATE DATABASE prods
GO

USE prods
GO

CREATE TABLE Products
(
    [Id]           INT IDENTITY PRIMARY KEY,
    [ProductName]  NVARCHAR(30) NOT NULL,
    [Manufacturer] NVARCHAR(20) NOT NULL,
    [Price]        MONEY        NOT NULL,
    [IsDeleted]    BIT          NULL
);

CREATE TRIGGER [products_delete]
    ON [Products]
    INSTEAD OF DELETE
    AS
    UPDATE [Products]
    SET [IsDeleted] = 1
    WHERE [ID] = (SELECT [Id] FROM deleted)
GO

INSERT INTO [Products] ([ProductName], [Manufacturer], [Price])
VALUES ('IPhone X', 'Apple', 79000),
       ('Pixel 2', 'Google', 60000);

DELETE
FROM [Products]
WHERE [ProductName] = 'Pixel 2';

SELECT *
FROM [Products];



