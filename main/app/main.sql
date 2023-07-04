USE RestaurantDB;
GO

-- CATEGORY FUNCTIONALITY 

EXEC AddNewCategory 'Pizza', 'Boring description about pizza';

EXEC UpdateCategory 'Pizza', 'Awesome Pizza', 'This is awesome category!';

SELECT * FROM ShowAvailableCategories;

-- PRODUCT AND MENU FUNCTIONALITY

EXEC AddNewProduct 'Awesome Pizza', 'Margaritta', 'Simple pizza with cheese and tomato sauce.', '10';

EXEC UpdateProduct 'Margaritta', @ProductPrice = 30;

SELECT * FROM Products;

-- SELECT * FROM GetInfoAboutProduct('Margaritta');

-- Declare start and end date inserted menu 
-- The first menu
DECLARE @Start1 DATE = DATEADD(DAY, 8, CAST(GETDATE() AS DATE));
DECLARE @End1 DATE = DATEADD(DAY, 7, @Start1);

-- The second menu
DECLARE @Start2 DATE = CAST(GETDATE() AS DATE);
DECLARE @End2 DATE = DATEADD(DAY, 7, @Start2);

EXEC AddNewMenu @Start1, @End1;
EXEC AddNewMenu @Start2, @End2;

SELECT * FROM Menu; 
-- Trigger works correctly (that trigger changes the isValid field in the table)
-- The second field is actual menu

EXEC AddProductIntoMenu 2, 1;

SELECT * FROM ActualMenu;

-- Order and Client functionality
-- Scenario without account (not for company)

EXEC AddNewOrder @Takeaway = 0, @Invoice = 0, @Seafood = 0;

-- Takeaway = true
DECLARE @Start3 DATE = DATEADD(DAY, 8, CAST(GETDATE() AS DATE));
DECLARE @Time1 TIME = CAST(GETDATE() AS TIME);

EXEC AddNewOrder @Takeaway = 1, @Invoice = 1, @Seafood = 0, @PrefferedDate = @Start3, @PrefferedTime = @Time1;

SELECT * FROM Orders;
SELECT * FROM Takeaway;

-- EXEC AddProductToOrder 1, 'Margaritta', 1;

SELECT * FROM OrderDetail;

-- Scenario with account (for company)
-- The first step (Create a new client)
EXEC AddNewClient 'Bober', @PhoneNumber = 123456789;

-- SELECT * FROM TakeClientDetails('Bober', 123456789);

-- The second step (create a new order)
EXEC AddNewOrder @Takeaway = 0, @Invoice = 1, @Seafood = 0, @ClientId = 1;

-- EXEC AddProductToOrder 3, 'Margaritta', 1;

EXEC AddNewInvoice 3;

-- BILL AND PAYMENT FUNCTIONALITY

EXEC GenerateBill 3;

DECLARE @Start4 DATE = DATEADD(DAY, 8, CAST(GETDATE() AS DATE));

EXEC AddPayment 3, @Start4, 20;

SELECT * FROM Payments;

-- ADD TABLE FUNCTIONALITY
EXEC AddTable 2;
EXEC AddTable 4;
EXEC AddTable 6; 

SELECT * FROM Tables;

-- ADD RESERVATION FUNCTIONALITY

DECLARE @Start5 DATE = DATEADD(DAY, 8, CAST(GETDATE() AS DATE));
DECLARE @Time2 TIME = DATEADD(HOUR, 2, CAST(GETDATE() AS TIME));
DECLARE @Time3 TIME = DATEADD(HOUR, 3, CAST(GETDATE() AS TIME));


EXEC AddNewReservation 1, 1, @Start5, @Time2, @Time3;

SELECT * FROM Reservations;

-- DISCOUNT FUNCTIONALITY

EXEC AddNewDiscount 'Jan', '123456789', 0.2;

SELECT * FROM Discounts;

EXEC IfDiscountExistsForOrder 1 -- Error

-- Check discount 

SELECT * FROM dbo.CheckAllDiscountsForClient(1);

-- Check Monthly income in the company 
SELECT * FROM MonthlyCompanyIncome(2);

-- Check if menu is actual
SELECT dbo.CheckIfMenuIsActual(1); -- returns false

-- Check if it possible add seafood to order

DECLARE @Start6 DATE = CAST(GETDATE() AS DATE);

SELECT dbo.CheckIfItIsPossibleAddSeafoodToOrder(@Start6); -- if it is possible that function returns 0 

-- Check if product is seafood

SELECT dbo.CheckIfProductIsSeafood('Margaritta'); -- 0 if is not seafood