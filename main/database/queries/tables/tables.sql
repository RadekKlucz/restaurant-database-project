-- =====================================================================
-- Author:		Radoslaw Kluczewski
-- Description:	Script that creates the tables for restaurant's database
-- =====================================================================

USE RestaurantDB;
GO

CREATE TABLE Categories
(
    CategoryId INT NOT NULL IDENTITY, -- IDENTITY is auto-increment
    CategoryName VARCHAR(50) NOT NULL,
    CategoryDescription VARCHAR(1000) NOT NULL,
    UNIQUE (CategoryName),
    PRIMARY KEY (CategoryId)
);
GO

CREATE TABLE Products 
(
    ProductId INT NOT NULL IDENTITY,
    ProductName VARCHAR(50) NOT NULL,
    ProductDescription VARCHAR(1000) NOT NULL,
    ProductPrice DECIMAL(10, 2) NOT NULL,
    CategoryId INT NOT NULL,
    PRIMARY KEY (ProductId),
    FOREIGN KEY (CategoryId) REFERENCES [Categories](CategoryId),
    UNIQUE (ProductName),
    CONSTRAINT CK_Price CHECK (ProductPrice > 0)
);
GO

CREATE TABLE Clients
(
    ClientId INT NOT NULL IDENTITY,
    FirstName VARCHAR(50),
    CompanyName VARCHAR(50),
    PhoneNumber INT,
    Email VARCHAR(50),
    PRIMARY KEY (ClientId),
    CONSTRAINT CK_PhoneNumber CHECK (LEN(PhoneNumber) > 0 AND LEN(PhoneNumber) <= 9)
);

CREATE TABLE Orders 
(
    OrderId INT NOT NULL IDENTITY,
    ClientId INT,
    Takeaway BIT NOT NULL,
    Invoice BIT NOT NULL,
    Seafood BIT NOT NULL,
    PRIMARY KEY (OrderId),
    FOREIGN KEY (ClientId) REFERENCES [Clients](ClientId)
);
GO

CREATE TABLE OrderDetail
(
    IdOfOrder INT NOT NULL,
    ProductId INT NOT NULL,
    Quantity INT NOT NULL,
    -- PRIMARY KEY (OrderId, ProductId),
    FOREIGN KEY (IdOfOrder) REFERENCES [Orders](OrderId),
    FOREIGN KEY (ProductId) REFERENCES [Products](ProductId),
    CONSTRAINT CK_QuantityAndUnitPrice CHECK (Quantity > 0) -- AND UnitPrice > 0
);
GO



CREATE TABLE Takeaway 
(
    OrderId INT NOT NULL, 
    PrefferedDate DATE NOT NULL,
    PrefferedTime TIME NOT NULL,
    PRIMARY KEY (OrderId),
    FOREIGN KEY (OrderId) REFERENCES [Orders](OrderId)
);
GO

CREATE TABLE Invoices
(
    InvoiceId INT NOT NULL IDENTITY,
    OrderId INT NOT NULL,
    IssueDate DATE NOT NULL,
    PRIMARY KEY (InvoiceId),
    FOREIGN KEY (OrderId) REFERENCES [Orders](OrderId)
);
GO

CREATE TABLE Payments
(
    PaymentId INT NOT NULL IDENTITY,
    OrderId INT NOT NULL,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (PaymentId),
    FOREIGN KEY (OrderId) REFERENCES [Orders](OrderId),
    CONSTRAINT CK_Amount CHECK (Amount > 0)
);
GO

CREATE TABLE Menu
(
    MenuId INT NOT NULL IDENTITY, 
    Valid BIT,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL, 
    PRIMARY KEY (MenuId),
    CONSTRAINT CK_Date_Menu CHECK (StartDate < EndDate)
);
GO 

CREATE TABLE MenuDetails
(
    MenuId INT NOT NULL,
    ProductId INT NOT NULL,
    PRIMARY KEY (MenuId, ProductId),
    FOREIGN KEY (MenuId) REFERENCES [Menu](MenuId),
    FOREIGN KEY (ProductId) REFERENCES [Products](ProductId)
);
GO

CREATE TABLE Tables
(
    TableId INT NOT NULL IDENTITY,
    TableSize INT NOT NULL,
    PRIMARY KEY (TableId),
    CONSTRAINT TableSize CHECK (TableSize > 0)
);
GO

CREATE TABLE Reservations
(
    ReservationId INT NOT NULL IDENTITY,
    TableId INT NOT NULL,
    ClientId INT NOT NULL,
    DateOfReservation DATE NOT NULL,
    StartTime TIME NOT NULL,
    PredictedEndTime TIME,
    PRIMARY KEY (ReservationId),
    FOREIGN KEY (TableId) REFERENCES [Tables](TableId),
    FOREIGN KEY (ClientId) REFERENCES [Clients](ClientId)
);
GO

CREATE TABLE Discounts
(
    DiscountId INT NOT NULL IDENTITY,
    ClientId INT NOT NULL,
    OrderId INT,
    DiscountPercentage DECIMAL(10, 2) NOT NULL,
    StartDate DATE,
    EndDate DATE,
    PRIMARY KEY (DiscountId),
    FOREIGN KEY (ClientId) REFERENCES [Clients](ClientId),
    FOREIGN KEY (OrderId) REFERENCES [Orders](OrderId),
    CONSTRAINT CK_Date_Table CHECK (StartDate < EndDate)
);
GO

CREATE TABLE Parameters 
(
    PernamentDiscount DECIMAL(10, 2) NOT NULL,
    NotPernamentDiscount DECIMAL(10, 2) NOT NULL,
    NeededAmountOfOrderToDiscount INT NOT NULL,
    NeededNumberOfOrders INT NOT NULL,
    EndDateOfDiscount INT NOT NULL
);
GO