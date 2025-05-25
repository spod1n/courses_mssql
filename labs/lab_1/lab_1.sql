CREATE DATABASE usersdb
DROP DATABASE usersdb

DROP TABLE Customers

USE usersdb
GO

CREATE TABLE [Customers]
(
    [Id]        INT,
    [Age]       INT,
    [FirstName] NVARCHAR(20),
    [LastName]  NVARCHAR(20),
    [Email]     VARCHAR(30),
    [Phone]     VARCHAR(20)
);

/* RENAME */
EXEC sp_rename 'Customers', 'CustomersNew';

/* PRIMARY KEY */
CREATE TABLE [Customers]
(
    [Id]        INT PRIMARY KEY,
    [Age]       INT,
    [FirstName] NVARCHAR(20),
    [LastName]  NVARCHAR(20),
    [Email]     VARCHAR(30),
    [Phone]     VARCHAR(20)
);

CREATE TABLE [Customers]
(
    [Id]        INT,
    [Age]       INT,
    [FirstName] NVARCHAR(20),
    [LastName]  NVARCHAR(20),
    [Email]     VARCHAR(30),
    [Phone]     VARCHAR(20),
    PRIMARY KEY (Id)
);

CREATE TABLE [OrderLines]
(
    [OrderId]   INT,
    [ProductId] INT,
    [Quantity]  INT,
    [Price]     MONEY,
    PRIMARY KEY ([OrderId], [ProductId])
);

/* IDENTITY */
CREATE TABLE [Customers]
(
    [Id]        INT PRIMARY KEY IDENTITY,
    [Age]       INT,
    [FirstName] NVARCHAR(20),
    [LastName]  NVARCHAR(20),
    [Email]     VARCHAR(30),
    [Phone]     VARCHAR(20)
);

/* UNIQUE */
CREATE TABLE [Customers]
(
    [Id]        INT PRIMARY KEY IDENTITY,
    [Age]       INT,
    [FirstName] NVARCHAR(20),
    [LastName]  NVARCHAR(20),
    [Email]     VARCHAR(30) UNIQUE,
    [Phone]     VARCHAR(20) UNIQUE
);

CREATE TABLE [Customers]
(
    [Id]        INT PRIMARY KEY IDENTITY,
    [Age]       INT,
    [FirstName] NVARCHAR(20),
    [LastName]  NVARCHAR(20),
    [Email]     VARCHAR(30),
    [Phone]     VARCHAR(20),
    UNIQUE ([Email], [Phone])
);

/* NULL & NOT NULL */
CREATE TABLE [Customers]
(
    [Id]        INT PRIMARY KEY IDENTITY,
    [Age]       INT,
    [FirstName] NVARCHAR(20) NOT NULL,
    [LastName]  NVARCHAR(20) NOT NULL,
    [Email]     VARCHAR(30) UNIQUE,
    [Phone]     VARCHAR(20) UNIQUE
);

/* DEFAULT */
CREATE TABLE Customers
(
    [Id]        INT PRIMARY KEY IDENTITY,
    [Age]       INT DEFAULT 18,
    [FirstName] NVARCHAR(20) NOT NULL,
    [LastName]  NVARCHAR(20) NOT NULL,
    [Email]     VARCHAR(30) UNIQUE,
    [Phone]     VARCHAR(20) UNIQUE
);

/* CHECK */
CREATE TABLE [Customers]
(
    [Id]        INT PRIMARY KEY IDENTITY,
    [Age]       INT          DEFAULT 18 CHECK ([Age] > 0 AND [Age] < 100),
    [FirstName] NVARCHAR(20)            NOT NULL,
    [LastName]  NVARCHAR(20) DEFAULT '' NOT NULL,
    [Email]     VARCHAR(30) UNIQUE CHECK ([Email] != ''),
    [Phone]     VARCHAR(20) UNIQUE CHECK ([Phone] != '')
);

CREATE TABLE [Customers]
(
    [Id]        INT PRIMARY KEY IDENTITY,
    [Age]       INT DEFAULT 18,
    [FirstName] NVARCHAR(20) NOT NULL,
    [LastName]  NVARCHAR(20) NOT NULL,
    [Email]     VARCHAR(30) UNIQUE,
    [Phone]     VARCHAR(20) UNIQUE,
    CHECK (([Age] > 0 AND Age < 100) AND ([Email] != '') AND ([Phone] != ''))
);

/* CONSTRAINT */
CREATE TABLE [Customers]
(
    [Id]        INT
        CONSTRAINT PK_Customer_Id PRIMARY KEY IDENTITY,
    [Age]       INT
        CONSTRAINT DF_Customer_Age DEFAULT 18
        CONSTRAINT CK_Customer_Age CHECK (Age > 0 AND Age < 100),
    [FirstName] NVARCHAR(20) NOT NULL,
    [LastName]  NVARCHAR(20) NOT NULL,
    [Email]     VARCHAR(30)
        CONSTRAINT UQ_Customer_Email UNIQUE,
    [Phone]     VARCHAR(20)
        CONSTRAINT UQ_Customer_Phone UNIQUE
);

CREATE TABLE [Customers]
(
    [Id]        INT IDENTITY,
    [Age]       INT
        CONSTRAINT DF_Customer_Age DEFAULT 18,
    [FirstName] NVARCHAR(20) NOT NULL,
    [LastName]  NVARCHAR(20) NOT NULL,
    [Email]     VARCHAR(30),
    [Phone]     VARCHAR(20),
    CONSTRAINT PK_Customer_Id PRIMARY KEY ([Id]),
    CONSTRAINT CK_Customer_Age CHECK ([Age] > 0 AND [Age] < 100),
    CONSTRAINT UQ_Customer_Email UNIQUE ([Email]),
    CONSTRAINT UQ_Customer_Phone UNIQUE ([Phone])
);

/* FOREIGN KEY */
CREATE TABLE [Customers]
(
    [Id]        INT PRIMARY KEY IDENTITY,
    [Age]       INT DEFAULT 18,
    [FirstName] NVARCHAR(20) NOT NULL,
    [LastName]  NVARCHAR(20) NOT NULL,
    [Email]     VARCHAR(30) UNIQUE,
    [Phone]     VARCHAR(20) UNIQUE
);

CREATE TABLE Orders
(
    [Id]         INT PRIMARY KEY IDENTITY,
    [CustomerId] INT REFERENCES Customers ([Id]),
    [CreatedAt]  Date
);

CREATE TABLE [Orders]
(
    [Id]         INT PRIMARY KEY IDENTITY,
    [CustomerId] INT,
    [CreatedAt]  Date,
    FOREIGN KEY ([CustomerId]) REFERENCES [Customers] ([Id])
);

CREATE TABLE [Orders]
(
    [Id]         INT PRIMARY KEY IDENTITY,
    [CustomerId] INT,
    [CreatedAt]  Date,
    CONSTRAINT FK_Orders_To_Customers FOREIGN KEY ([CustomerId]) REFERENCES [Customers] ([Id])
);

/* ON DELETE OR UPDATE */
-- NO ACTION

-- CASCADE
CREATE TABLE [Orders]
(
    [Id]         INT PRIMARY KEY IDENTITY,
    [CustomerId] INT,
    [CreatedAt]  Date,
    FOREIGN KEY ([CustomerId]) REFERENCES Customers ([Id]) ON DELETE CASCADE
)

-- NULL
CREATE TABLE [Orders]
(
    [Id]         INT PRIMARY KEY IDENTITY,
    [CustomerId] INT,
    [CreatedAt]  Date,
    FOREIGN KEY ([CustomerId]) REFERENCES [Customers] ([Id]) ON DELETE SET NULL
);

-- DEFAULT
CREATE TABLE [Orders]
(
    [Id]         INT PRIMARY KEY IDENTITY,
    [CustomerId] INT,
    [CreatedAt]  Date,
    FOREIGN KEY ([CustomerId]) REFERENCES [Customers] ([Id]) ON DELETE SET DEFAULT
);

/* CREATE FIELD */
ALTER TABLE [Customers]
    ADD [Address] NVARCHAR(50) NULL;

ALTER TABLE [Customers]
    ADD [Address] NVARCHAR(50) NOT NULL;

ALTER TABLE [Customers]
    ADD [Address] NVARCHAR(50) NOT NULL DEFAULT N'Невідомо';

/* DELETE FIELD */
ALTER TABLE [Customers]
    DROP COLUMN [Address];

/* CHANGE TYPE */
ALTER TABLE [Customers]
    ALTER COLUMN [FirstName] NVARCHAR(200);

/* ADD CHECK */
ALTER TABLE [Customers]
    ADD CHECK ([Age] > 21);

ALTER TABLE [Customers]
    WITH NOCHECK
        ADD CHECK ([Age] > 21);

/* ADD FOREIGN KEY */
CREATE TABLE [Customers]
(
    [Id]        INT PRIMARY KEY IDENTITY,
    [Age]       INT DEFAULT 18,
    [FirstName] NVARCHAR(20) NOT NULL,
    [LastName]  NVARCHAR(20) NOT NULL,
    [Email]     VARCHAR(30) UNIQUE,
    [Phone]     VARCHAR(20) UNIQUE
);

CREATE TABLE [Orders]
(
    [Id]         INT IDENTITY,
    [CustomerId] INT,
    [CreatedAt]  Date
);

ALTER TABLE [Orders]
    ADD FOREIGN KEY ([CustomerId]) REFERENCES [Customers] ([Id]);

/* ADD PRIMARY KEY */
ALTER TABLE [Orders]
    ADD PRIMARY KEY ([Id]);

/* ADD CONSTRAINT */
ALTER TABLE [Orders]
    ADD CONSTRAINT PK_Orders_Id PRIMARY KEY ([Id]),
        CONSTRAINT FK_Orders_To_Customers FOREIGN KEY ([CustomerId]) REFERENCES [Customers] ([Id]);

/* DELETE LIMITS */
ALTER TABLE [Orders]
    DROP FK_Orders_To_Customers;
