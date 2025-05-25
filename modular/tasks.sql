-- 11. Вивести статистику з сумарними оплатами за замовлення щодо кожного замовника
-- Модифікація 11*. Вивести статистику з сумарними оплатами за замовлення щодо кожного замовника по місяцях (pivot)


SELECT C.id,
       C.name,
       CAST(O.CreatedAt AS DATE) AS 'CreateAtDate',
       SUM(O.sum)                AS 'SumOrder'
FROM Clients C
         JOIN dbo.Orders O ON C.id = O.id_z
GROUP BY C.id, C.name, O.CreatedAt
;



SELECT [id],
       [name],
       [2024-08-09],
       [2024-08-10],
       [2024-08-11],
       [2024-08-12]
FROM (SELECT C.[id],
             C.[name],
             CAST(O.[CreatedAt] AS DATE) AS 'CreateAtDate',
             SUM(O.[sum])                AS 'SumOrder'
      FROM Clients C
               JOIN [dbo].[Orders] O ON C.id = O.id_z
      GROUP BY C.[id], C.[name], O.[CreatedAt]) x
         PIVOT
         (SUM([SumOrder])
         FOR CreateAtDate
         IN ([2024-08-09],
             [2024-08-10],
             [2024-08-11],
             [2024-08-12])
         ) P;


