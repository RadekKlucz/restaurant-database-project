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
