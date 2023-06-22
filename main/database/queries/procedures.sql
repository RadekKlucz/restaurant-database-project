USE [Restaurant-db];
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
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(1000) = N'ERROR: ' + ERROR_MESSAGE();
        THROW 50001, @ErrorMessage, 1;
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
            THROW 50002, N'The inserted product exists in the table!', 1;
        ELSE
            DECLARE @CategoryId INT = (
                SELECT CategoryId FROM Categories 
                WHERE @CategoryName = CategoryName);
            INSERT INTO Products (ProductName, ProductDescription, ProductPrice, CategoryId)
            VALUES (@ProductName, @ProductDescription, @ProductPrice, @CategoryId);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(1000) = N'ERROR: ' + ERROR_MESSAGE();
        THROW 50002, @ErrorMessage, 1;
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
            THROW 50003, N'In the table exists valid menu!', 1;
        ELSE
            INSERT INTO Menu (StartDate, EndDate)
            VALUES (@StartDate, @EndDate);
    END TRY 
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(1000) = N'ERROR: ' + ERROR_MESSAGE();
        THROW 50003, @ErrorMessage, 1;
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
            THROW 50004, N'The inserted menu does not exist in the table Menu!', 1;
        ELSE IF (SELECT Valid FROM Menu WHERE MenuId = @MenuId) = 0
            THROW 50004, N'The selected menu is not up to date!', 1;
        ELSE IF (SELECT COUNT(MenuId) FROM MenuDetails) >= 30
            THROW 50004, N'The selected menu is full!', 1;
        ELSE IF EXISTS(SELECT ProductId FROM MenuDetails)
            THROW 50004, N'The selected menu have this product!', 1;
        ELSE
            INSERT INTO MenuDetails(MenuId, ProductId)
            VALUES (@MenuId, @ProductId);
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(1000) = N'ERROR: ' + ERROR_MESSAGE();
        THROW 50004, @ErrorMessage, 1;
    END CATCH
END;
GO

-- Tutaj zaczyna się sekwencja kroków zwiazana z tworzeniem nowego produktu 
-- Ta prodedura beedze pierwsza a poniej zaraz dodawanie szczegółów zamówienia. Dwa kroki podczas tworzenia zamówienia i inne opcjonalnie
CREATE PROCEDURE AddProductToOrder(
    @OrderId INT,
    @ProductName VARCHAR(50),
    @Quantity INT
)
AS
BEGIN
    BEGIN TRY
        IF NOT EXISTS(SELECT OrderId FROM Orders)
            THROW 50005, N'The entered id does not exist in the orders!', 1;
        ELSE IF NOT EXISTS(SELECT ProductName FROM Products WHERE ProductName = @ProductName)
            THROW 50005, N'The entered product does not exist in the menu!', 1;
        ELSE IF @Quantity <= 0
            THROW 50005, N'The entered quentity is not correct!', 1;
        ELSE
            DECLARE @ProductId  INT = (SELECT ProductId FROM Products WHERE ProductName = @ProductName)
            INSERT INTO OrdersDetails(OrderId, ProductId, Quantity)
            VALUES (@OrderId, @ProductId, Quantity)
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(1000) = N'ERROR: ' + ERROR_MESSAGE();
        THROW 50005, @ErrorMessage, 1;
    END CATCH 
END;
GO

-- procedura ktora potowerdza platnosc? 