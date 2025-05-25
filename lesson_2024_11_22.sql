SELECT TOP 3 p.[ProductName],
             SUM(o.[ProductCount]) AS 'ProductCount'
FROM [Orders] o
         JOIN [Products] p
              ON p.[Id] = o.[ProductId]
                  AND DATEPART(dw, o.[CreatedAt]) = 5
GROUP BY p.[ProductName]
ORDER BY SUM(o.[ProductCount]);

CREATE VIEW CustomerThursdayNotBuy AS (
    SELECT DISTINCT c.[Id],
                    c.[FirstName]
        FROM [Customers] c
                 LEFT JOIN [Orders] o
                           ON c.[Id] = o.[CustomerId]
                               AND DATEPART(dw, o.[CreatedAt]) = 5
        WHERE o.[CustomerId] IS NULL
)
-- DROP VIEW CustomerThursdayNotBuy;

PRINT COUNT
SELECT * FROM CustomerThursdayNotBuy;

