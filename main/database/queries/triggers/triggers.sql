-- ======================================================================
-- Author:		Radoslaw Kluczewski
-- Description:	Script that creates the tiggers for restaurant's database
-- ======================================================================

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
    DECLARE @NumberOfOrders INT = (SELECT COUNT(OrderId) FROM Orders WHERE ClientId = @ClientId);
    DECLARE @NeededNumberOfOrders INT = (SELECT NeededNumberOfOrders FROM Parameters);
    DECLARE @Discount DECIMAL(10, 2) = (SELECT PernamentDiscount FROM Parameters);
    IF @NumberOfOrders >= @NeededNumberOfOrders
        INSERT INTO Discounts(ClientId, OrderId, DiscountPercentage, StartDate)
        VALUES (@ClientId, @OrderId, @Discount, CAST(GETDATE() AS DATE));
END;
GO

CREATE TRIGGER TriggerSpecialDiscount
ON OrdersDetails
AFTER INSERT 
AS
BEGIN
    DECLARE @OrderId INT = IDENT_CURRENT('Orders');
    DECLARE @ClientId INT = (SELECT ClientId FROM OrderId WHERE OrderId = @OrderId);
    DECLARE @Discount DECIMAL(10, 2) = (SELECT NotPernamentDiscount FROM Parameters);
    DECLARE @NeededAmount INT = (SELECT NeededAmountOfOrderToDiscount FROM Parameters);
    DECLARE @AmountOfOrder DECIMAL(10, 2) = (
        SELECT SUM(Products.ProductPrice * Quantity) AS 'SumarizedAmount' FROM OrdersDetails
        INNER JOIN Products ON Products.ProductId = OrdersDetails.ProductId
        WHERE OrdersDetails.OrderId  = @OrderId);

    IF @AmountOfOrder >= @NeededAmount
        INSERT INTO Discounts(ClientId, OrderId, DiscountPercentage, StartDate, EndDate)
        VALUES (@ClientId, @OrderId, @Discount, CAST(GETDATE() AS DATE), CAST(DATEADD(DAY, 7, GETDATE()) AS DATE));
END;
GO