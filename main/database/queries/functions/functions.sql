USE RestaurantDB;
GO

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
    INSERT INTO Orders(ClientId, Takeaway, Invoice, Seafood)
    VALUES (@ClientId, @Takeaway, @Invoice, @Seafood);

    DECLARE @OrderId INT = (SELECT MAX(OrderId) FROM Orders);

    IF @Takeaway = 1
        INSERT INTO Takeaway(ClientId, OrderId, PrefferedDate, PrefferedTime)
        VALUES (@ClientId, @OrderId, @PrefferedDate, @PrefferedTime);

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
RETURNS TEXT
AS
BEGIN
    DECLARE @Result BIT;
    IF @MenuId IS NULL
        IF NOT EXISTS(SELECT MenuId WHERE CAST(GETDATE() AS DATE) NOT BETWEEN StartDate AND EndDate)
            SET @Return = 0;
        ELSE
            SET @Return = 1;
    ELSE
        IF NOT EXISTS(SELECT MenuId FROM Menu WHERE MenuId = @MenuId)
            SET @Return = 0;
        ELSE
            SET @Return = 1;
    RETURN @Result;
END;
GO

CREATE FUNCTION CheckIfItIsPossibleAddSeafoodToOrder( --tataj finkcja wspolpracuje z dodaniem zamowienia seafood i sprawdza czy dla daty (default aktualna) mozna dodac do zamowienia owoce morza
    @ActualDate DATE = NULL
)
RETURNS BIT
AS
BEGIN
    DECLARE @Result BIT;
    IF @ActualDate IS NULL
        SET @ActualDate = DATEPART(WEEKDAY, GETDATE());
    IF @ActualDate  >= 5 AND @ActualDate <= 7
        SET @Return = 1;
    ELSE 
        SET @Return = 0; 
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

CREATE FUNCTION GrantPrivileges(
    @OldRole NVARCHAR(30),
    @NewRole NVARCHAR(30)
)
RETURNS BIT
AS
BEGIN
-- Generate script for grant privileges on new role
    DECLARE @Result TEXT = '';
    SELECT @Result += 'GRANT ' + permission_name + ' TO ' + QUOTENAME(@NewRole) + ';'
    FROM sys.database_permissions
    WHERE grantee_principal_id = DATABASE_PRINCIPAL_ID(@OldRole);
    EXEC(@Result)
    RETURN 1;
END;
GO