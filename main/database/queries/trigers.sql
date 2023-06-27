USE RestaurantDB;
GO

CREATE TRIGGER TriggerValidMenu
ON Menu 
AFTER INSERT 
AS
BEGIN
    SET NOCOUNT ON; -- prevent the sending messages to the client for each statement
    DECLARE @MenuId INT = (SELECT MenuId FROM Menu WHERE Valid = 1);
    -- DECLARE @NewMenuId INT = (SELECT MAX(MenuId) FROM Menu); lub rozwiazanie ponizej 
    DECLARE @NewMenuId INT = IDENT_CURRENT('Menu');

    UPDATE Menu 
    SET Valid = 0 
    WHERE MenuId = @MenuId;

    UPDATE Menu
    SET Valid = 1
    WHERE MenuId = @NewMenuId;
END;
GO

CREATE TRIGGER TriggerPernamentDiscount
ON Orders
AFTER INSERT 
AS
BEGIN
    DECLARE @OrderId INT = IDENT_CURRENT('Orders');
    DECLARE @ClientId INT = (SELECT ClientId FROM Orders WHERE OrderId = @OrderId)
    DECLARE @NumerOfOrders INT = (SELECT COUNT(OrderId) FROM Orders WHERE ClientId = @ClientId);
    DECLARE @NeededNumberOfOrders INT = (SELECT NeededNumberOfOrders FROM Parameters);
    DECLARE @Discount DECIMAL(10, 2) = (SELECT PernamentDiscount FROM Parameters);
    IF @NumberOfOrders >= @NeededNumberOfOrders
        INSERT INTO Discounts(ClientId, OrderId, DiscountPercentage, StartDate)
        VALUES (@ClientId, @OrderId, @Discount, CAST(GETDATE() AS DATE));
END;
GO

-- CREATE TRIGGER TriggerSpecialDiscount
-- ON OrdersDetails
-- AFTER INSERT 
-- AS
-- BEGIN
--     DECLARE @LastPaymentId INT = IDENT_CURRENT('OrdersDetails'); --chcemy dla ostatniego zamowiena 
--     DECLARE @OrderId INT = (SELECT MAX(OrderId) FROM OrdersDetails);
--     DECLARE @NeededAmount INT = (SELECT NeededAmountOfOrderToDiscount FROM Parameters);
--     DECLARE @EndDate INT = (SELECT EndDateOfDiscount FROM Parameters);
--     DECLARE @Discount DECIMAL(10, 2) = (SELECT NotPernamentDiscount FROM Parameters);
--     DECLARE @ClientId INT = (
--         SELECT ClientId FROM Orders
--         INNER JOIN Payments ON Payments.OrderId = Orders.OrderId
--         WHERE OrderId = @OrderId);
--     IF (SELECT SUM(Amount) FROM Payments INNER JOIN Orders ON Orders.OrderId = Payments.OrderId WHERE ClientId = @ClientId) >= @NeededAmount
--         INSERT INTO Discounts(ClientId, OrderId, DiscountPercentage, StartDate, EndDate)
--         VALUES (@ClientId, @Discount, GETDATE(), GETDATE() + @EndDate); --przmyslec czy to jest dobre poniewaz moze byc tak ze  nie potrzebie jest Discount dla OrderID. Teraz wgl rachunek moze zle liczyc koncowy dla klienta
-- END;
-- GO