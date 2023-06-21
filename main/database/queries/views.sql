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

CREATE VIEW [Actual-Reservations] AS 
(
    SELECT ReservationId AS "NumberOfReservation", TableId AS "NumberOfTable", StartTime, PredictedEndTime FROM Reservations
    WHERE DateOfReservation = CAST(GETDATE() AS DATE)
);
GO

CREATE VIEW [Actual-Free-Tables] AS 
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

CREATE VIEW [Monthly-Reservations] AS 
(
    SELECT MONTH(DateOfReservation) as "Month", COUNT(ReservationId) AS "NumerOfReservation" FROM Reservations
    WHERE YEAR(DateOfReservation) = YEAR(GETDATE())
    GROUP BY MONTH(DateOfReservation)
);
GO

CREATE VIEW [Discount-For-Customer] AS 
(
    SELECT Clients.ClientId, FirstName, CompanyName, Discounts.DiscountPercentage FROM Clients
    INNER JOIN Discounts ON Discounts.ClientId = Clients.ClientId
);
GO

CREATE VIEW [Number-Of-Dishes-Ordered] AS 
(
    SELECT ProductId, ProductName, ProductPrice, SUM(Quantity) AS "NumberOfOrders" FROM Products
    INNER JOIN OrderDetails ON OrdersDetails.ProductId = Products.ProductId
    GROUP BY ProductId, ProductName, ProductPrice
);
GO