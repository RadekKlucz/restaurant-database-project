-- ========================================================================
-- Author:		Radoslaw Kluczewski
-- Description:	Script that creates the functions for restaurant's database
-- ========================================================================

USE RestaurantDB;
GO

--The first step in ordering a product from the restaurant. The second step is the AddProductToOrder procedure that exists in the procedures file
CREATE FUNCTION AddNewOrder(
    @ClientId INT,
    @Takeaway BIT,
    @Invoice BIT,
    @Seafood BIT,
    @PrefferedDate DATE = NULL,
    @PrefferedTime TIME = NULL
)
RETURNS INT
AS
BEGIN
    EXEC InsetDataToOrder
        @ClientId,
        @Takeaway,
        @Invoice,
        @Seafood;
    DECLARE @OrderId INT = (SELECT MAX(OrderId) FROM Orders);
    IF @Takeaway = 1
        EXEC InsertTakeaway
            @OrderId,
            @PrefferedDate,
            @PrefferedTime;
    RETURN @OrderId
END;
GO

CREATE FUNCTION CheckAllDiscountsForClient(
    @ClientId INT
)
RETURNS TABLE
AS
RETURN
        SELECT OrderId, DiscountPercentage, StartDate, EndDate FROM Discounts
        WHERE ClientId = @ClientId;
GO

CREATE FUNCTION GetInfoAboutProduct(
    @ProductName VARCHAR(50)
)
RETURNS TABLE
AS
RETURN
    SELECT 
        Categories.CategoryName, ProductName, ProductDescription, 
        ProductPrice, COUNT(OrderId) AS 'NumberOfOrders', SUM(Quantity) AS 'QuantityFromAllOrders' 
    FROM Products 
    INNER JOIN Categories ON Products.CategoryId = Categories.CategoryId
    INNER JOIN OrdersDetails ON Products.ProductId = OrdersDetails.ProductId
    WHERE CAST(Products.ProductName AS NVARCHAR(50)) LIKE '%' + @ProductName + '%'
    GROUP BY Categories.CategoryName, ProductName, ProductDescription, ProductPrice;
GO

CREATE FUNCTION TakeClientDetails(
    @FirstName VARCHAR(50),
    @PhoneNumber INT
)
RETURNS TABLE
AS
RETURN
    SELECT 
        FirstName, CompanyName, PhoneNumber, Email, Reservations.ReservationId, 
        Discounts.OrderId, Discounts.DiscountPercentage, Products.ProductName, OrdersDetails.Quantity
    FROM Clients
    INNER JOIN Reservations ON Reservations.ClientId = Clients.ClientId
    INNER JOIN Discounts ON Discounts.ClientId = Clients.ClientId 
    INNER JOIN OrdersDetails ON OrdersDetails.OrderId = Discounts.OrderId
    INNER JOIN Products ON Products.ProductId = OrdersDetails.ProductId
    WHERE FirstName = @FirstName AND PhoneNumber = @PhoneNumber
    GROUP BY FirstName, CompanyName, PhoneNumber, Email, Reservations.ReservationId, Discounts.OrderId, Discounts.DiscountPercentage, Products.ProductName, OrdersDetails.Quantity;
GO


CREATE FUNCTION IfPaymentExists(
    @OrderId INT
)
RETURNS BIT
AS
BEGIN
    DECLARE @Result BIT;
    IF EXISTS(SELECT PaymentId FROM Payments WHERE OrderId = @OrderId)
        SET @Result = 1;
    ELSE
        SET @Result = 0;
    RETURN @Result;
END;
GO

CREATE FUNCTION MonthlyCompanyIncome(
    @Month INT
)
RETURNS TABLE
AS
RETURN
    SELECT Amount FROM Payments WHERE MONTH(PaymentDate) = @Month;
GO

CREATE FUNCTION CheckIfMenuIsActual(
    @MenuId INT = NULL
)
RETURNS BIT
AS
BEGIN
    DECLARE @Result BIT;
    IF @MenuId IS NULL
        IF NOT EXISTS(SELECT Menu.MenuId FROM Menu WHERE CAST(GETDATE() AS DATE) NOT BETWEEN Menu.StartDate AND Menu.EndDate)
            SET @Result = 0;
        ELSE
            SET @Result = 1;
    ELSE
        IF NOT EXISTS(SELECT MenuId FROM Menu WHERE MenuId = @MenuId)
            SET @Result = 0;
        ELSE
            SET @Result = 1;
    RETURN @Result;
END;
GO

-- The function below works with the AddProductToOrder procedure that checks before ordering if it is possible to order seafood. The default date is actual date
CREATE FUNCTION CheckIfItIsPossibleAddSeafoodToOrder(
    @ActualDate DATE = NULL
)
RETURNS BIT
AS
BEGIN
    DECLARE @Result BIT;
    DECLARE @Date INT;
    IF @ActualDate IS NULL
        SET @Date = DATEPART(WEEKDAY, GETDATE());
    ELSE
        SET @Date = DATEPART(WEEKDAY, @ActualDate);

    IF @Date  >= 5 AND @Date <= 7
        SET @Result = 1;
    ELSE 
        SET @Result = 0; 
    RETURN @Result;
END;
GO

CREATE FUNCTION CheckIfProductIsSeafood(
    @ProductName VARCHAR(50)
)
RETURNS BIT
AS
BEGIN
    DECLARE @Result BIT;
    DECLARE @CategoryIdOfSeafood INT = (SELECT CategoryId FROM Categories WHERE CategoryName = 'Seafood')
    IF EXISTS(SELECT ProductId FROM Products WHERE CategoryId = @CategoryIdOfSeafood AND ProductName = @ProductName)
        SET @Result = 1;
    ELSE
        SET @Result = 0;
    RETURN @Result;
END;
GO