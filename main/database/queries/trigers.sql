USE [Restaurant-db];
GO

CREATE TRIGGER [Trigger-Valid-Menu]
ON Menu 
AFTER INSERT 
AS
BEGIN
    SET NOCOUNT ON; -- prevent the sending messages to the client for each statement
    DECLARE @MenuId INT = (SELECT MenuId FROM Menu WHERE Valid = 1);
    DECLARE @NewMenuId INT = (SELECT MAX(MenuId) FROM Menu);

    UPDATE Menu 
    SET Valid = 0 
    WHERE MenuId = @MenuId;

    UPDATE Menu
    SET Valid = 1
    WHERE MenuId = @NewMenuId;
END;
GO

-- CREATE TRIGGER [Trigger-Valid-Discount]
-- ON Discounts
-- BEFORE SELECT 
-- AS
-- BEGIN
--     SET NOCOUNT ON;
--     DECLARE @DiscountId INT = (SELECT MAX(DiscountId) FROM Discounts);
--     DECLARE @StartDate DATE = (SELECT StartDate FROM Discounts WHERE DiscountId = @DiscountId);
--     DECLARE @EndDate DATE = (SELECT EndDate FROM Discounts WHERE DiscountId = @DiscountId);

--     IF CAST(GETDATE() AS DATE) BETWEEN @StartDate AND @EndDate
--         INSERT INTO Discounts(IsValid)
--         VALUES (1);
--     ELSE
--         INSERT INTO Discounts(IsValid)
--         VALUES (0); 
-- END;
-- GO

-- triger dodajacy waznosc znjizki do tabeli discounts