CREATE FUNCTION [testF](@n1 int, @n2 as int)
    RETURNS int
AS
BEGIN
    RETURN (@n1 * @n2)
END
GO

--DROP FUNCTION [testF];
SELECT [dbo].[testF](5, 8);

SELECT *,
       [dbo].[testF](Price, ProductCount) AS 'sum'
FROM [Orders];

CREATE FUNCTION [dbo].[ufnGetCountProduct](@Product int)
    RETURNS int
AS
BEGIN
    DECLARE @ret int
    SELECT @ret = SUM([Orders].[ProductCount])
    FROM [Orders]
    WHERE [ProductID] = @Product
    IF (@ret IS NULL) SET @ret = 0;
    RETURN @ret;
END;

SELECT [ProductName],
       [dbo].[ufnGetCountProduct]([Id]) AS 'Count_In_Orders'
FROM [Products];

CREATE FUNCTION [SelectSumOrdersByProdIdDateN](@Product int, @NDays int = 10) RETURNS int
AS
BEGIN
    DECLARE @ret int
    SELECT @ret = SUM(o.[ProductCount] * o.[price])
    FROM [Orders] AS o
    WHERE [ProductID] = @Product
      and o.[CreatedAt] BETWEEN CAST(GETDATE() - @NDays AS DATE) AND CAST(GETDATE() AS DATE)
    IF (@ret IS NULL) SET @ret = 0;
    RETURN @ret;
END;

SELECT o.*,
       [dbo].[SelectSumOrdersByProdIdDateN](o.[ProductId], 1)
FROM [Orders] AS o;

SELECT o.*, [dbo].[SelectSumOrdersByProdIdDateN](o.[ProductId], DEFAULT)
FROM [Orders] AS o;


