-- =========================================================================
-- Author:		Radoslaw Kluczewski
-- Description:	Script that creates the procedures for restaurant's database
-- =========================================================================

USE RestaurantDB;
GO

CREATE PROCEDURE AddNewCategory(
    @CategoryName VARCHAR(50), 
    @CategoryDescription TEXT) 
AS
BEGIN 
    BEGIN TRY 
        IF EXISTS(SELECT CategoryName FROM Categories WHERE @CategoryName = CategoryName)
                THROW 50001, N'The inserted category exists in the table!', 1;
        ELSE
            INSERT INTO Categories (CategoryName, CategoryDescription)
            VALUES (@CategoryName, @CategoryDescription);
            SELECT 'New id of inserted category is: ' + CAST(MAX(CategoryId) AS VARCHAR) AS 'NewCategoryId' FROM Categories;  
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(1000) = N'ERROR: ' + ERROR_MESSAGE();
        THROW 50001, @ErrorMessage, 1;
    END CATCH
END;
GO

CREATE PROCEDURE UpdateCategory(
    @CategoryName VARCHAR(50),
    @NewNameOfCategory VARCHAR(50) = NULL,
    @CategoryDescription TEXT = NULL
)
AS
BEGIN
    BEGIN TRY
    IF NOT EXISTS(SELECT CategoryName FROM Categories WHERE LOWER(CategoryName) = LOWER(@CategoryName))
        THROW 50002, N'The entered name of category does not exist in the categories table!', 1;
    ELSE
        DECLARE @CategoryId INT = (
            SELECT CategoryId FROM Categories 
            WHERE LOWER(CategoryName) = LOWER(@CategoryName));
        IF (@CategoryDescription IS NOT NULL) AND (@NewNameOfCategory IS NULL)
            UPDATE Categories 
            SET 
                CategoryDescription = @CategoryDescription
            WHERE CategoryId = @CategoryId;
        ELSE IF (@CategoryDescription IS NULL) AND (@NewNameOfCategory IS NOT NULL)
            UPDATE Categories 
            SET 
                CategoryName = @NewNameOfCategory
            WHERE CategoryId = @CategoryId;
        ELSE
            UPDATE Categories 
            SET CategoryName = @NewNameOfCategory,
                CategoryDescription = @CategoryDescription
            WHERE CategoryId = @CategoryId;
    END TRY
    BEGIN CATCH 
        DECLARE @ErrorMessage NVARCHAR(1000) = N'ERROR: ' + ERROR_MESSAGE();
        THROW 50002, @ErrorMessage, 1;
    END CATCH
END;
GO

CREATE PROCEDURE AddNewProduct(
    @CategoryName VARCHAR(50),
    @ProductName VARCHAR(50),
    @ProductDescription TEXT,
    @ProductPrice DECIMAL(10, 2)) 
AS
BEGIN
    BEGIN TRY
        IF EXISTS(SELECT ProductName FROM Products WHERE @ProductName = ProductName)
            THROW 50003, N'The inserted product exists in the table!', 1;
        ELSE
            DECLARE @CategoryId INT = (
                SELECT CategoryId FROM Categories 
                WHERE @CategoryName = CategoryName);
            IF @CategoryId IS NULL 
                THROW 50003, N'Inserted category does not exist in the table!', 1;
            ELSE
                INSERT INTO Products (ProductName, ProductDescription, ProductPrice, CategoryId)
                VALUES (@ProductName, @ProductDescription, @ProductPrice, @CategoryId);
                SELECT 'New id of inserted product is: ' + CAST(MAX(ProductId) AS VARCHAR) AS NewProductId FROM Products;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(1000) = N'ERROR: ' + ERROR_MESSAGE();
        THROW 50003, @ErrorMessage, 1;
    END CATCH 
END;
GO

CREATE PROCEDURE UpdateProduct(
    @ProductName VARCHAR(50),
    @ProductDescription TEXT = NULL,
    @ProductPrice DECIMAL = NULL
)
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS(SELECT ProductName FROM Products WHERE @ProductName = ProductName)
            THROW 50004, N'The inserted product does not exist in the table!', 1;
        ELSE
            DECLARE @ProductId INT = (
                SELECT ProductId FROM Products 
                WHERE ProductName = @ProductName);
            IF (@ProductDescription IS NOT NULL) AND (@ProductPrice IS NOT NULL)
                UPDATE Products
                SET 
                    ProductName = @ProductName, 
                    ProductDescription = @ProductDescription, 
                    ProductPrice = @ProductPrice
                WHERE ProductId = @ProductId;
            ELSE IF (@ProductDescription IS NOT NULL) AND (@ProductPrice IS NULL)
                UPDATE Products
                SET 
                    ProductName = @ProductName, 
                    ProductDescription = @ProductDescription 
                WHERE ProductId = @ProductId;
            ELSE IF (@ProductDescription IS NULL) AND (@ProductPrice IS NOT NULL)
                UPDATE Products
                SET 
                    ProductName = @ProductName, 
                    ProductPrice = @ProductPrice
                WHERE ProductId = @ProductId;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(1000) = N'ERROR: ' + ERROR_MESSAGE();
        THROW 50004, @ErrorMessage, 1;
    END CATCH
END;
GO

CREATE PROCEDURE AddNewMenu(
    @StartDate DATE,
    @EndDate DATE)
AS
BEGIN
    BEGIN TRY
        IF EXISTS(SELECT MenuId FROM Menu WHERE @StartDate BETWEEN StartDate AND EndDate)
            THROW 50005, N'In the table exists valid menu!', 1;
        ELSE
            INSERT INTO Menu (StartDate, EndDate)
            VALUES (@StartDate, @EndDate);
            SELECT MAX(MenuId) AS 'NewMenuId' FROM Menu;
    END TRY 
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(1000) = N'ERROR: ' + ERROR_MESSAGE();
        THROW 50005, @ErrorMessage, 1;
    END CATCH
END;
GO

CREATE PROCEDURE AddProductIntoMenu(
    @MenuId INT,
    @ProductId INT)
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS(SELECT MenuId FROM Menu WHERE MenuId = @MenuId)
            THROW 50006, N'The inserted menu does not exist in the table Menu!', 1;
        ELSE IF (SELECT Valid FROM Menu WHERE MenuId = @MenuId) = 0
            THROW 50006, N'The selected menu is not up to date!', 1;
        ELSE IF (SELECT COUNT(MenuId) FROM MenuDetails) >= 30
            THROW 50006, N'The selected menu is full!', 1;
        ELSE IF EXISTS(SELECT ProductId FROM MenuDetails)
            THROW 50006, N'The selected menu have this product!', 1;
        ELSE
            INSERT INTO MenuDetails(MenuId, ProductId)
            VALUES (@MenuId, @ProductId);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(1000) = N'ERROR: ' + ERROR_MESSAGE();
        THROW 50006, @ErrorMessage, 1;
    END CATCH
END;
GO

CREATE PROCEDURE AddNewClient(
    @FirstName VARCHAR(50),
    @CompanyName VARCHAR(50) = NULL,
    @PhoneNumber INT,
    @Email VARCHAR(50) = NULL
)
AS
BEGIN
    BEGIN TRY
        IF (LEN(@FirstName) <= 1) AND (@FirstName NOT LIKE '%[A-Za-z]%')
            THROW 50010, N'The entered name is not valid!', 1;
        ELSE IF (@PhoneNumber NOT LIKE '%[1-9]%') AND (LEN(@PhoneNumber) != 9)
            THROW 50010, N'The entered number of phone is not valid!', 1;
        ELSE IF (@Email IS NOT NULL) AND (@Email NOT LIKE '%@%')
            THROW 50010, N'The entered email is not valid!', 1;
        ELSE IF EXISTS (SELECT ClientId FROM Clients WHERE FirstName = @FirstName AND PhoneNumber = @PhoneNumber)
            THROW 50010 , N'The entered client exists in the database!', 1;
        ELSE IF (@CompanyName IS NULL) AND (@Email IS NULL)
            INSERT INTO Clients(FirstName, PhoneNumber)
            VALUES (@FirstName, @PhoneNumber);
        ELSE IF (@CompanyName IS NOT NULL) AND (@Email IS NULL)
            INSERT INTO Clients(FirstName, CompanyName, PhoneNumber)
            VALUES (@FirstName, @CompanyName, @PhoneNumber);
        ELSE IF (@CompanyName IS NULL) AND (@Email IS NOT NULL)
            INSERT INTO Clients(FirstName, PhoneNumber, Email)
            VALUES (@FirstName, @PhoneNumber, @Email);
        ELSE
            INSERT INTO Clients(FirstName, CompanyName, PhoneNumber, Email)
            VALUES (@FirstName, @CompanyName, @PhoneNumber, @Email);    
        SELECT MAX(ClientId) FROM Clients;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(1000) = N'ERROR: ' + ERROR_MESSAGE();
        THROW 50010, @ErrorMessage, 1;
    END CATCH
END;
GO

CREATE PROCEDURE DeleteClient(
    @ClientName VARCHAR(50),
    @PhoneNumber INT
) 
AS
BEGIN
    BEGIN TRY 
        IF NOT EXISTS(SELECT FirstName FROM Clients WHERE FirstName = @ClientName AND PhoneNumber = @PhoneNumber
        )
            THROW 50011, N'The inserted client does not exist in the table!', 1;
        ELSE
            DELETE FROM Clients WHERE FirstName = @ClientName AND PhoneNumber = @PhoneNumber;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(1000) = N'ERROR: ' + ERROR_MESSAGE();
        THROW 50011, @ErrorMessage, 1;
    END CATCH
END;
GO

-- The procedure below inserts the data about order into the orders table. 
CREATE PROCEDURE InsetDataToOrder(
    @ClientId INT = NULL,
    @Takeaway BIT,
    @Invoice BIT,
    @Seafood BIT
)
AS
BEGIN
    INSERT INTO Orders(ClientId, Takeaway, Invoice, Seafood)
    VALUES (@ClientId, @Takeaway, @Invoice, @Seafood);
END;
GO

--The procedure below is optional for the first step. That procedure insert data to takeaway table if the takeaway is true
CREATE PROCEDURE InsertTakeaway(
    @OrderId INT,
    @PrefferedDate DATE,
    @PrefferedTime TIME
)
AS
BEGIN
    INSERT INTO Takeaway(OrderId, PrefferedDate, PrefferedTime)
    VALUES (@OrderId, @PrefferedDate, @PrefferedTime);
END;
GO

--The first step in ordering a product from the restaurant. The second step is the AddProductToOrder procedure
CREATE PROCEDURE AddNewOrder(
    @Takeaway BIT,
    @Invoice BIT,
    @Seafood BIT,
    @ClientId INT = NULL,
    @PrefferedDate DATE = NULL,
    @PrefferedTime TIME = NULL
)
AS
BEGIN
    BEGIN TRY
    EXEC InsetDataToOrder
        @ClientId,
        @Takeaway,
        @Invoice,
        @Seafood;

    DECLARE @OrderId INT = (SELECT MAX(OrderId) AS 'Id of a new order'FROM Orders);

    IF @Takeaway = 1
        IF @PrefferedDate IS NOT NULL AND @PrefferedTime IS NOT NULL
            EXEC InsertTakeaway
                @OrderId,
                @PrefferedDate,
                @PrefferedTime;
        ELSE
            THROW 50012, N'The time and date are null!', 1;
    SELECT @OrderId;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(1000) = N'ERROR: ' + ERROR_MESSAGE();
        THROW 50012, @ErrorMessage, 1;
    END CATCH

END;
GO

-- The procedure below uses the order id created by AddNewOrder procedure. This is the second step in ordering a product in the restaurant
CREATE PROCEDURE AddProductToOrder(
    @IdOfOrder INT,
    @ProductName VARCHAR(50),
    @Quantity INT
)
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS(SELECT OrderId FROM Orders WHERE OrderId = @IdOfOrder)
            THROW 50007, N'The entered id does not exist in the orders!', 1;
        ELSE IF NOT EXISTS(SELECT ProductName FROM Products WHERE ProductName = @ProductName)
            THROW 50007, N'The entered product does not exist in the menu!', 1;
        ELSE IF @Quantity <= 0
            THROW 50007, N'The entered quentity is not correct!', 1;
        ELSE            
            DECLARE @ProductId INT = (SELECT ProductId FROM Products WHERE ProductName = @ProductName);
            
            INSERT INTO OrderDetail (IdOfOrder, ProductId, Quantity)
            VALUES (@IdOfOrder, @ProductId, @Quantity);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(1000) = N'ERROR: ' + ERROR_MESSAGE();
        THROW 50007, @ErrorMessage, 1;
    END CATCH 
END;
GO

CREATE PROCEDURE AddNewInvoice(
    @OrderId INT
)
AS
BEGIN
    BEGIN TRY 
        IF NOT EXISTS(SELECT OrderId FROM Orders WHERE OrderId = @OrderId)
            THROW 50008, N'The inserted id does not exist in the orders!', 1;            
        ELSE IF (SELECT Invoice FROM Orders WHERE OrderId = @OrderId) = 0
            THROW 50008, N'For this order is not required invoice!', 1;
        ELSE
            INSERT INTO Invoices(OrderId, IssueDate)
            VALUES (@OrderId, CAST(GETDATE() AS DATE));
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(1000) = N'ERROR: ' + ERROR_MESSAGE();
        THROW 50008, @ErrorMessage, 1;
    END CATCH
END;
GO

CREATE PROCEDURE AddPayment(
    @OrderId INT,
    @PaymentDate DATE,
    @Amount DECIMAL
)
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS(SELECT OrderId FROM Orders WHERE OrderId = @OrderId)
            THROW 50009, N'The entered order does not exist in the orders!', 1;
        ELSE IF EXISTS(SELECT PaymentId FROM Payments WHERE OrderId = @OrderId AND PaymentDate = @PaymentDate AND Amount = @Amount)
            THROW 50009, N'The entered order has a payment!', 1;
        ELSE
            INSERT INTO Payments(OrderId, PaymentDate, Amount)
            VALUES (@OrderId, @PaymentDate, @Amount);
    END TRY
    BEGIN CATCH 
        DECLARE @ErrorMessage NVARCHAR(1000) = N'ERROR: ' + ERROR_MESSAGE();
        THROW 50009, @ErrorMessage, 1;
    END CATCH
END;
GO

CREATE PROCEDURE AddTable(
    @TableSize INT
)
AS
BEGIN
    BEGIN TRY
        IF @TableSize <= 0 
            THROW 50011, N'The entered size of table is not valid!', 1;
        ELSE
            INSERT INTO Tables(TableSize)
            VALUES (@TableSize);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(1000) = N'ERROR: ' + ERROR_MESSAGE();
        THROW 50012, @ErrorMessage, 1;
    END CATCH
END;
GO

CREATE PROCEDURE AddNewReservation(
    @TableId INT,
    @ClientId INT,
    @DateOfReservation DATE,
    @StartTime TIME,
    @PredictedEndTime TIME
)
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS(SELECT ClientId FROM Clients WHERE ClientId = @ClientId)
            THROW 50013, N'The entered client id does not exist in the clients table!', 1;
        ELSE IF CAST(GETDATE() AS DATE) > @DateOfReservation
            THROW 50013, N'The entered date of reservation is not valid!', 1;
        ELSE IF (CAST(GETDATE() AS TIME) > @StartTime) OR (@StartTime > @PredictedEndTime)
            THROW 50013, N'The entered time of reservation is not valid!', 1;
        ELSE
            INSERT INTO Reservations(
                TableId, 
                ClientId, 
                DateOfReservation,  
                StartTime, 
                PredictedEndTime)
            VALUES (
                @TableId, 
                @ClientId, 
                @DateOfReservation,  
                @StartTime, 
                @PredictedEndTime);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(1000) = N'ERROR: ' + ERROR_MESSAGE();
        THROW 50013, @ErrorMessage, 1;
    END CATCH
END;
GO

CREATE PROCEDURE AddNewDiscount(
    @FirstName VARCHAR(50),
    @PhoneNumber INT,
    @DiscountPercentage DECIMAL
)
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS(SELECT ClientId FROM Clients WHERE FirstName = @FirstName AND PhoneNumber = @PhoneNumber)
            THROW 50014, N'The entered client does not exist in the database!', 1;
        ELSE IF @DiscountPercentage <= 0 AND @DiscountPercentage > 1
            THROW 50014, N'The entered discount is not correct!', 1;
        ELSE
            DECLARE @ClientId INT = (
                SELECT ClientId FROM Clients 
                WHERE FirstName = @FirstName AND PhoneNumber = @PhoneNumber);
            INSERT INTO Discounts(ClientId, DiscountPercentage, StartDate, EndDate)
            VALUES (@ClientId, @DiscountPercentage, CAST(GETDATE() AS DATE), CAST((GETDATE()  + 7) AS DATE));
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(1000) = N'ERROR: ' + ERROR_MESSAGE();
        THROW 50014, @ErrorMessage, 1;
    END CATCH
END;
GO

CREATE PROCEDURE GenerateBill(
    @OrderId INT
)
AS
BEGIN
    BEGIN TRY
        IF EXISTS(SELECT OrderId FROM Payments WHERE OrderId = @OrderId)
            THROW 50015, N'The payment for this order already exists!', 1;
        ELSE
            SELECT SUM(Quantity * Products.ProductPrice * (1 - Discounts.DiscountPercentage)) AS 'AmountForAllProducts' FROM OrderDetail 
            INNER JOIN Products ON Products.ProductId = OrderDetail.ProductId
            INNER JOIN Discounts ON Discounts.OrderId = OrderDetail.IdOfOrder
            WHERE OrderDetail.IdOfOrder = @OrderId
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(1000) = N'ERROR: ' + ERROR_MESSAGE();
        THROW 50015, @ErrorMessage, 1;
    END CATCH
END;
GO

CREATE PROCEDURE IfDiscountExistsForOrder(
    @OrderId INT
)
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS (SELECT OrderId FROM Discounts WHERE (OrderId = @OrderId) AND (DiscountPercentage IS NOT NULL))
            THROW 50016, N'The selected order does not have discount!', 1;
        ELSE
            DECLARE @IsValid BIT;
            IF EXISTS(SELECT OrderId FROM Discounts WHERE (OrderId = @OrderId) AND (CAST(GETDATE() AS DATE) BETWEEN StartDate AND EndDate))
                SET @IsValid = 1;
            ELSE
                SET @IsValid = 0;
            SELECT Clients.FirstName, DiscountPercentage, StartDate, EndDate, @IsValid AS 'IsValid' FROM Discounts
            INNER JOIN Clients ON Clients.ClientId = Discounts.ClientId
            WHERE Discounts.OrderId = @OrderId;
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(1000) = N'ERROR: ' + ERROR_MESSAGE();
        THROW 50016, @ErrorMessage, 1;
    END CATCH
END;
GO

CREATE PROCEDURE AddAndUpdateParameters(
    @PernamentDiscount DECIMAL(10, 2),
    @NotPernamentDiscount DECIMAL(10, 2),
    @NeededAmountOfOrderToDiscount INT,
    @NeededNumberOfOrders INT,
    @EndDateOfDiscount INT,
    @TypeOfOperation VARCHAR(6)
)
AS
BEGIN
    BEGIN TRY
        IF @PernamentDiscount <= 0 AND @PernamentDiscount >= 1 
            THROW 50017, N'The inserted pernament discount does not meet the conditions! Try range between 0 and 1.', 1;
        ELSE IF @NotPernamentDiscount <= 0 AND @NotPernamentDiscount >= 1
            THROW 50017, N'The inserted discount does not meet the conditions! Try range between 0 and 1.', 1;
        ELSE IF @NeededAmountOfOrderToDiscount < 0
            THROW 50017, N'The inserted needed amount of order to discount is less than 0!', 1;
        ELSE IF @NeededNumberOfOrders < 0
            THROW 50017, N'The inserted needed number of order is less than 0!', 1;
        ELSE IF @EndDateOfDiscount <= 0 AND @EndDateOfDiscount > 7
            THROW 50017, N'The inserted day is not between 1 and 7. Try again!', 1;
        ELSE IF LOWER(@TypeOfOperation) NOT LIKE 'insert' OR LOWER(@TypeOfOperation) NOT LIKE 'update'
            THROW 50017, N'The inserted operation is not correct! Please choose the corret operation (insert or update).', 1;
        ELSE IF LOWER(@TypeOfOperation) = 'insert'
            INSERT INTO Parameters(PernamentDiscount, NotPernamentDiscount, NeededAmountOfOrderToDiscount,
                NeededNumberOfOrders, EndDateOfDiscount)
            VALUES (@PernamentDiscount, @NotPernamentDiscount, @NeededAmountOfOrderToDiscount, 
                @NeededNumberOfOrders, @EndDateOfDiscount)
        ELSE
            UPDATE Parameters
            SET PernamentDiscount = @PernamentDiscount, 
                NotPernamentDiscount = @NotPernamentDiscount,
                NeededAmountOfOrderToDiscount = @NeededAmountOfOrderToDiscount,
                NeededNumberOfOrders = @NeededNumberOfOrders,
                EndDateOfDiscount = @EndDateOfDiscount;
    END TRY
    BEGIN CATCH 
        DECLARE @ErrorMessage NVARCHAR(1000) = N'ERROR: ' + ERROR_MESSAGE();
        THROW 50017, @ErrorMessage, 1;
    END CATCH
END;
GO

-- CREATE PROCEDURE SelectParameter(
--     @PernamentDiscount BIT = NULL,
--     @NotPernamentDiscount BIT = NULL,
--     @NeededAmountOfOrderToDiscount BIT = NULL,
--     @NeededNumberOfOrders BIT = NULL,
--     @EndDateOfDiscount BIT = NULL
-- )
-- AS
-- BEGIN
--     BEGIN TRY
--         IF (@PernamentDiscount IS NOT NULL) AND (@PernamentDiscount = 1)
--             SELECT PernamentDiscount FROM Parameters;
--         ELSE IF (@NotPernamentDiscount IS NOT NULL) AND (@NotPernamentDiscount = 1)
--             SELECT NotPernamentDiscount FROM Parameters;
--         ELSE IF (@NeededAmountOfOrderToDiscount IS NOT NULL) AND (@NeededAmountOfOrderToDiscount = 1)
--             SELECT NeededAmountOfOrderToDiscount FROM Parameters;
--         ELSE IF (@NeededNumberOfOrders IS NOT NULL) AND (@NeededNumberOfOrders = 1)
--             SELECT NeededAmountOfOrderToDiscount FROM Parameters;
--         ELSE IF (@EndDateOfDiscount IS NOT NULL) AND (@EndDateOfDiscount = 1)
--             SELECT NeededAmountOfOrderToDiscount FROM Parameters;
--         ELSE
--             THROW 50018, N'Please choose column that you want to select.', 1;
--     END TRY
--     BEGIN CATCH
--         DECLARE @ErrorMessage NVARCHAR(1000) = N'ERROR: ' + ERROR_MESSAGE();
--         THROW 50018, @ErrorMessage, 1;
--     END CATCH
-- END;
-- GO

-- Generate script for grant privileges on new role
CREATE PROCEDURE GrantPrivileges(
    @OldRole NVARCHAR(30),
    @NewRole NVARCHAR(30)
)
AS
BEGIN
    DECLARE @Result NVARCHAR(MAX) = '';
    SELECT @Result += 'GRANT ' + permission_name + ' TO ' + QUOTENAME(@NewRole) + ';'
    FROM sys.database_permissions
    WHERE grantee_principal_id = DATABASE_PRINCIPAL_ID(@OldRole);
    EXEC(@Result)
END;
GO