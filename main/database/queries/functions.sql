USE RestaurantDB;
GO

CREATE FUNCTION AddNewOrder(
    @Takeaway BIT,
    @Invoice BIT,
    @Seafood BIT,
    @PrefferedDate DATE = NULL,
    @PrefferedTime TIME = NULL
)
RETURNS INT
AS
BEGIN
    INSERT INTO Orders(Takeaway, Invoice, Seafood)
    VALUES (@Takeaway, @Invoice, @Seafood);

    DECLARE @OrderId INT = (SELECT MAX(OrderId) FROM Orders);

    IF @Takeaway = 1
        INSERT INTO Takeaway(OrderId, PrefferedDate, PrefferedTime)
        VALUES (@OrderId, @PrefferedDate, @PrefferedTime);

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
        WHERE ClientId = @ClienId;
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
    WHERE Products.ProductId = @ProductId;
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
    INNER JOIN Reservations ON Reservations.ClienId = Clients.ClientId
    INNER JOIN Discounts ON Discounts.ClientId = Clients.ClientId 
    INNER JOIN OrdersDetails ON OrdersDetails.OrderId = Discounts.OrderId
    INNER JOIN Products ON Products.ProductId = OrdersDetails.ProductId
    WHERE FirstName = @FirstName AND PhoneNumber = @PhoneNumber
    GROUP BY FirstName, CompanyName, PhoneNumber, Email;
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

