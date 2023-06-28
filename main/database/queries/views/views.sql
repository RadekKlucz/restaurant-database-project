USE RestaurantDB;
GO

CREATE VIEW ActualMenu
AS 
(
    SELECT Categories.CategoryName, ProductName, ProductDescription, ProductPrice FROM Products
    INNER JOIN Categories ON Categories.CategoryId = Products.CategoryId
    INNER JOIN MenuDetails ON MenuDetails.ProductId = Products.ProductId
    INNER JOIN Menu ON Menu.MenuId = MenuDetails.MenuId
    WHERE Menu.Valid = 1
);
GO

CREATE VIEW ShowAvailableCategories
AS 
(
    SELECT CategoryId, CategoryName, CategoryDescription FROM Categories
);
GO

CREATE VIEW MonthlyPaymentsInActualYear
AS 
(
    SELECT MONTH(PaymentDate) AS "Month", SUM(Amount) AS "SummarizedPayment" FROM Payments
    WHERE YEAR(PaymentDate) = YEAR(GETDATE()) 
    GROUP BY MONTH(PaymentDate)
);
GO

CREATE VIEW ActualReservations
AS 
(
    SELECT ReservationId AS "NumberOfReservation", TableId AS "NumberOfTable", StartTime, PredictedEndTime FROM Reservations
    WHERE DateOfReservation = CAST(GETDATE() AS DATE)
);
GO

CREATE VIEW ActualFreeTables
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

CREATE VIEW MonthlyReservationsInActualYear
AS 
(
    SELECT DATENAME(month, DateOfReservation) as "Month", COUNT(ReservationId) AS "NumerOfReservation" FROM Reservations
    WHERE YEAR(DateOfReservation) = YEAR(GETDATE())
    GROUP BY DATENAME(month, DateOfReservation)
);
GO

CREATE VIEW WeeklyReservationsInActualMonth
AS
(
    SELECT DATENAME(quarter, DateOfReservation) as "Quarter", COUNT(ReservationId) AS "NumerOfReservation" FROM Reservations
    WHERE (YEAR(DateOfReservation) = YEAR(GETDATE())) AND (DATENAME(month, DateOfReservation) = DATENAME(month, GETDATE()))
    GROUP BY DATENAME(quarter, DateOfReservation)
)
GO

CREATE VIEW AllDiscountsForClients 
AS 
(
    SELECT Clients.ClientId, FirstName, CompanyName, Discounts.DiscountPercentage FROM Clients
    INNER JOIN Discounts ON Discounts.ClientId = Clients.ClientId
);
GO

CREATE VIEW NumberOfDishesOrdered
AS 
(
    SELECT Products.ProductId, ProductName, ProductPrice, SUM(Quantity) AS "NumberOfOrders" FROM Products
    INNER JOIN OrdersDetails ON OrdersDetails.ProductId = Products.ProductId
    GROUP BY Products.ProductId, ProductName, ProductPrice
);
GO

CREATE VIEW SeafoodOrders 
AS
(
    SELECT OrdersDetails.OrderId, ProductName FROM Products
    INNER JOIN OrdersDetails ON OrdersDetails.ProductId = Products.ProductId
    INNER JOIN Orders ON Orders.OrderId = OrdersDetails.OrderId
    WHERE Seafood = 1
);
GO

CREATE VIEW SelectAllParameters
AS
(
    SELECT PernamentDiscount, NotPernamentDiscount, NeededAmountOfOrderToDiscount, NeededNumberOfOrders, EndDateOfDiscount FROM Parameters
);
GO