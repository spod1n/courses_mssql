--CREATE DATABASE module_db;

-- Таблиця "Замовник"
CREATE TABLE Clients
(
    id           INT PRIMARY KEY IDENTITY,
    name         NVARCHAR(255) NOT NULL,
    phone_number NVARCHAR(20)  NOT NULL,
    CreatedAt    DATETIME DEFAULT GETDATE()
);

-- Таблиця "Оператор"
CREATE TABLE Operators
(
    id        INT PRIMARY KEY IDENTITY,
    name      NVARCHAR(255) NOT NULL,
    pass      NVARCHAR(255) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- Таблиця "Ресторан"
CREATE TABLE Restaurants
(
    id        INT PRIMARY KEY IDENTITY,
    name_rest NVARCHAR(255) NOT NULL
);

-- Таблиця "Страви"
CREATE TABLE Dishes
(
    id        INT PRIMARY KEY IDENTITY,
    name      NVARCHAR(255)  NOT NULL,
    price     DECIMAL(10, 2) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    EditAt    DATETIME DEFAULT GETDATE()
);

-- Таблиця "Замовлення"
CREATE TABLE Orders
(
    id         INT PRIMARY KEY IDENTITY,
    id_rest    INT            NOT NULL FOREIGN KEY REFERENCES Restaurants (id),
    id_oper    INT            NOT NULL FOREIGN KEY REFERENCES Operators (id),
    id_z       INT            NOT NULL FOREIGN KEY REFERENCES Clients (id),
    number     INT            NOT NULL,
    sum        DECIMAL(10, 2) NOT NULL,
    CreatedAt  DATETIME DEFAULT GETDATE(),
    DeliveryAt DATETIME
);

-- Таблиця "Замовлено"
CREATE TABLE Ordered
(
    id   INT PRIMARY KEY IDENTITY,
    id_z INT NOT NULL FOREIGN KEY REFERENCES Orders (id),
    id_b INT NOT NULL FOREIGN KEY REFERENCES Dishes (id),
    qnt  INT NOT NULL
);

INSERT INTO Clients (name, phone_number, CreatedAt)
VALUES ('Виктор', '+380634438888', '2024-07-10'),
       ('Пётр Петрович', '+380674437777', '2024-07-11'),
       ('Иван', '+380504444444', '2024-07-12'),
       ('Пётр', '+380504888888', '2024-08-01'),
       ('Маша', '+380662220909', '2024-08-10');

INSERT INTO Operators (name, pass, CreatedAt)
VALUES ('Пётр', '123ee', '2024-07-10'),
       ('Василий', 'rr1234', '2024-07-10'),
       ('Анна', '2344', '2024-07-11'),
       ('Галина', '123ddd33', '2024-07-12');

INSERT INTO Restaurants (name_rest)
VALUES ('Ресторан 1'),
       ('Ресторан 2'),
       ('Ресторан 3');

INSERT INTO Dishes (name, price, CreatedAt, EditAt)
VALUES ('Пицца', 100, '2024-07-10', '2024-07-10'),
       ('Роллы', 150, '2024-07-10', '2024-07-10'),
       ('Вода', 10, '2024-07-10', '2024-07-11');

INSERT INTO Orders (id_rest, id_oper, id_z, number, sum, CreatedAt, DeliveryAt)
VALUES (1, 1, 1, 260, 260, '2024-08-09 12:00', '2024-08-09 13:00'),
       (2, 1, 2, 200, 200, '2024-08-10 11:00', '2024-08-10 10:00'),
       (1, 2, 3, 200, 200, '2024-08-11 10:00', '2024-08-11 13:00'),
       (2, 2, 4, 200, 200, '2024-08-11 10:00', '2024-08-11 12:00'),
       (3, 1, 5, 500, 500, '2024-08-11 11:00', '2024-08-11 13:00'),
       (1, 2, 1, 150, 150, '2024-08-12 10:00', '2024-08-12 14:00');

INSERT INTO Ordered (id_z, id_b, qnt)
VALUES (1, 1, 1),
       (1, 2, 1),
       (1, 3, 1),
       (2, 1, 2),
       (2, 2, 2),
       (3, 1, 2),
       (4, 1, 2),
       (5, 1, 5),
       (6, 2, 1);
