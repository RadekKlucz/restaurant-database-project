USE [Restaurant-db];
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
    WHERE Products.ProductId = @ProductId
GO

CREATE FUNCTION TakeClientDetails(
    -- 
)
RETURNS TABLE
AS
RETURN
-- ZWROCIC JEGO DANE, ILOSC REZERWACJI, ILOSC ZAMOWIEN,, CALOKWITE SUME ZAMOWIEN, ILE ZALEWGA Z ZAPLATA?
GO

