USE [Restaurant-db];
GO

CREATE VIEW [Actual-Menu] AS 
(
    SELECT Categories.CategoryName, ProductName, ProductDescription, ProductPrice FROM Products
    INNER JOIN Categories ON Categories.CategoryId = Products.CategoryId
    INNER JOIN MenuDetails ON MenuDetails.ProductId = Products.ProductId
    INNER JOIN Menu ON Menu.MenuId = MenuDetails.MenuId
    WHERE Menu.Valid = 1
);
GO

CREATE VIEW [Show-Available-Categories] AS 
(
    SELECT CategoryId, CategoryName, CategoryDescription FROM Categories
);
GO

CREATE VIEW [Monthly-Payments-In-Actual-Year] AS 
(
    SELECT MONTH(PaymentDate) AS "Month", SUM(Amount) AS "SummarizedPayment" FROM Payments
    WHERE YEAR(PaymentDate) = YEAR(GETDATE()) 
    GROUP BY MONTH(PaymentDate)
);
GO

CREATE VIEW [Actual-Reservations] 
AS 
(
    SELECT ReservationId AS "NumberOfReservation", TableId AS "NumberOfTable", StartTime, PredictedEndTime FROM Reservations
    WHERE DateOfReservation = CAST(GETDATE() AS DATE)
);
GO

CREATE VIEW [Actual-Free-Tables] 
AS 
(   

    SELECT Tables.TableId AS "NumberOfTable", TableSize, Reservations.StartTime AS "AvailableUntil", Reservations.PredictedEndTime AS "AvailableFrom" FROM Tables
    INNER JOIN Reservations ON Reservations.TableId = Tables.TableId
    WHERE Tables.TableId NOT IN 
        (
        SELECT TableId FROM Reservations 
        WHERE CAST(GETDATE() AS TIME) NOT BETWEEN Reservations.StartTime AND Reservations.PredictedEndTime
        )
);
GO

CREATE VIEW [Monthly-Reservations-In-Actual-Year] 
AS 
(
    SELECT DATENAME(month, DateOfReservation) as "Month", COUNT(ReservationId) AS "NumerOfReservation" FROM Reservations
    WHERE YEAR(DateOfReservation) = YEAR(GETDATE())
    GROUP BY DATENAME(month, DateOfReservation)
);
GO

CREATE VIEW [Weekly-Reservations-In-Actual-Month]
AS
(
    SELECT DATENAME(quarter, DateOfReservation) as "Quarter", COUNT(ReservationId) AS "NumerOfReservation" FROM Reservations
    WHERE (YEAR(DateOfReservation) = YEAR(GETDATE())) AND (DATENAME(month, DateOfReservation) = DATENAME(month, GETDATE()))
    GROUP BY DATENAME(quarter, DateOfReservation)
)
GO

CREATE VIEW [All-Discounts-For-Clients] 
AS 
(
    SELECT Clients.ClientId, FirstName, CompanyName, Discounts.DiscountPercentage, Discounts.IsValid FROM Clients
    INNER JOIN Discounts ON Discounts.ClientId = Clients.ClientId
);
GO

CREATE VIEW [Number-Of-Dishes-Ordered] 
AS 
(
    SELECT Products.ProductId, ProductName, ProductPrice, SUM(Quantity) AS "NumberOfOrders" FROM Products
    INNER JOIN OrdersDetails ON OrdersDetails.ProductId = Products.ProductId
    GROUP BY Products.ProductId, ProductName, ProductPrice
);
GO

CREATE VIEW [Seafood-Orders] 
AS
(
    SELECT OrdersDetails.OrderId, ProductName FROM Products
    INNER JOIN OrdersDetails ON OrdersDetails.ProductId = Products.ProductId
    INNER JOIN Orders ON Orders.OrderId = OrdersDetails.OrderId
    WHERE Seafood = 1
);
GO