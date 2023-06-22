USE [Restaurant-db];
GO

CREATE FUNCTION AddNewOrder(
    @Takeaway BIT,
    @Invoice BIT,
    @Seafood BIT,
    @PrefferedDate DATE = NULL,
    @PrefferedTime TIME = NULL,
    @IssueDate DATE = NULL
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
    IF @Invoice = 1
        INSERT INTO Invoices(OrderId, IssueDate)
        VALUES (@OrderId, @IssueDate);
        
    RETURN @OrderId
END;
GO