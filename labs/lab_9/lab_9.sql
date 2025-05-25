CREATE PROCEDURE [ProductSummary] AS
SELECT [ProductName] AS 'Product',
       [Manufacturer],
       [Price]
FROM [Products]
GO

CREATE PROCEDURE [ProductSummary] AS
BEGIN
    SELECT [ProductName] AS 'Product',
           [Manufacturer],
           [Price]
    FROM [Products]
END
GO

EXEC [ProductSummary];
DROP PROCEDURE [ProductSummary];

-- PARAMETERS IN PROCEDURES
CREATE PROCEDURE [AddProduct] @name NVARCHAR(20),
                              @manufacturer NVARCHAR(20),
                              @count INT,
                              @price MONEY
AS
INSERT INTO [Products] ([ProductName], [Manufacturer], [ProductCount], [Price])
VALUES (@name, @manufacturer, @count, @price)
GO

DECLARE @prodName NVARCHAR(20),
    @company NVARCHAR(20);
DECLARE @prodCount INT,
    @price MONEY
SET @prodName = 'Galaxy C7'
SET @company = 'Samsung'
SET @price = 22000
SET @prodCount = 5

EXEC [AddProduct] @prodName, @company, @prodCount, @price;
SELECT *
FROM [Products];

EXEC [AddProduct] 'Galaxy C7', 'Samsung', 5, 22000;

DECLARE @prodName NVARCHAR(20),
    @company NVARCHAR(20);
SET @prodName = 'Honor 9';
SET @company = 'Huawei';

EXEC [AddProduct] @name = @ProdName,
     @Manufacturer = @company,
     @count = 3,
     @price = 18000;

-- OPTIONAL PARAMETERS
CREATE PROCEDURE [AddProductWithOptionalCount] @name NVARCHAR(20),
                                               @manufacturer NVARCHAR(20),
                                               @price MONEY,
                                               @count INT = 1
AS
INSERT INTO [Products] ([ProductName], [Manufacturer], [ProductCount], [Price])
VALUES (@name, @manufacturer, @count, @price)
GO

DECLARE @prodName NVARCHAR(20),
    @company NVARCHAR(20),
    @price MONEY;

SET @prodName = 'Redmi Note 5A';
SET @company = 'Xiaomi';
SET @price = 22000;

EXEC [AddProductWithOptionalCount] @prodName, @company, @price

SELECT *
FROM [Products]


CREATE PROCEDURE [GetPriceStats] @minPrice MONEY OUTPUT,
                                 @maxPrice MONEY OUTPUT
AS
SELECT @minPrice = MIN(Price), @maxPrice = MAX(Price)
FROM [Products]
GO

DECLARE @minPrice MONEY, @maxPrice MONEY

EXEC [GetPriceStats] @minPrice OUTPUT, @maxPrice OUTPUT

PRINT 'Мінімальна ціна ' + CONVERT(VARCHAR, @minPrice)
PRINT 'Максимальна ціна ' + CONVERT(VARCHAR, @maxPrice)


CREATE PROCEDURE [CreateProduct] @name NVARCHAR(20),
                                 @manufacturer NVARCHAR(20),
                                 @count INT,
                                 @price MONEY,
                                 @id INT OUTPUT
AS
INSERT INTO [Products] ([ProductName], [Manufacturer], [ProductCount], [Price])
VALUES (@name, @manufacturer, @count, @price)
    SET @id = @@IDENTITY
GO

DECLARE @id INT
EXEC [CreateProduct] 'LG V30', 'LG', 3, 28000, @id OUTPUT
PRINT @id;

-- VALUE RETURN
CREATE PROCEDURE [GetAvgPrice] AS
DECLARE @avgPrice MONEY
SELECT @avgPrice = AVG([Price])
FROM [Products]
    RETURN @avgPrice
GO

DECLARE @result MONEY
EXEC @result = GetAvgPrice
PRINT @result
