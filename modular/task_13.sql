-- 23.* Створити тригер, який буде записувати код оператора, час, виконану операцію в окрему таблицю

CREATE TABLE Logs
(
    [operator_id]  INT,
    [log_datetime] DATETIME DEFAULT (GETDATE()),
    [order_code]   INT,
    [order_type]   VARCHAR(50)
)
GO


CREATE TRIGGER Logs_INSERT
    ON Orders
    AFTER INSERT
    AS
    INSERT INTO Logs
    SELECT id_oper,
           CreatedAt,
           id,
           'Create order'
    FROM inserted
GO


INSERT INTO Orders (id_rest, id_oper, id_z, number, sum, CreatedAt, DeliveryAt)
VALUES (1, 1, 1, 260, 260, '2024-08-09 12:00', '2024-08-09 13:00'),

SELECT * FROM Logs
