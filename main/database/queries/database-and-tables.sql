CREATE DATABASE [Restaurant-db];
GO

USE [Restaurant-db];
GO

CREATE TABLE [Categories] 
(
    CategoryId INT NOT NULL IDENTITY, -- IDENTITY is auto-increment
    CategoryName VARCHAR(50) NOT NULL,
    CategoryDescription TEXT NOT NULL,
    UNIQUE (CategoryName),
    PRIMARY KEY (CategoryId)
);
GO

CREATE TABLE [Products] 
(
    ProductId INT NOT NULL IDENTITY,
    ProductName VARCHAR(50) NOT NULL,
    ProductDescription TEXT NOT NULL,
    ProductPrice DECIMAL(10, 2) NOT NULL,
    CategoryId INT NOT NULL,
    PRIMARY KEY (ProductId),
    FOREIGN KEY (CategoryId) REFERENCES [Categories](CategoryId),
    UNIQUE (ProductName),
    CONSTRAINT CK_Price CHECK (ProductPrice > 0)
);
GO

CREATE TABLE [Orders] 
(
    OrderId INT NOT NULL IDENTITY,
    Takeaway BIT NOT NULL,
    Invoice BIT NOT NULL,
    Seafood BIT NOT NULL,
    PRIMARY KEY (OrderId)
);
GO

CREATE TABLE [OrdersDetails] 
(
    OrderId INT NOT NULL,
    ProductId INT NOT NULL,
    -- UnitPrice DECIMAL(10, 2) NOT NULL,
    Quantity INT NOT NULL,
    PRIMARY KEY (OrderId, ProductId),
    FOREIGN KEY (OrderId) REFERENCES [Orders](OrderId),
    FOREIGN KEY (ProductId) REFERENCES [Products](ProductId),
    CONSTRAINT CK_QuantityAndUnitPrice CHECK (Quantity > 0) -- AND UnitPrice > 0
);
GO

CREATE TABLE [Takeaway] 
(
    OrderId INT NOT NULL, 
    PrefferedDate DATE NOT NULL,
    PrefferedTime TIME NOT NULL,
    PRIMARY KEY (OrderId),
    FOREIGN KEY (OrderId) REFERENCES [Orders](OrderId)
);
GO

CREATE TABLE [Invoices]
(
    InvoiceId INT NOT NULL IDENTITY,
    OrderId INT NOT NULL,
    IssueDate DATE NOT NULL,
    PRIMARY KEY (InvoiceId),
    FOREIGN KEY (OrderId) REFERENCES [Orders](OrderId)
);
GO

CREATE TABLE [Payments]
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

CREATE TABLE [Menu]
(
    MenuId INT NOT NULL IDENTITY, 
    Valid BIT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL, 
    PRIMARY KEY (MenuId),
    CONSTRAINT CK_Date_Menu CHECK (StartDate < EndDate)
);
GO 

CREATE TABLE [MenuDetails]
(
    MenuId INT NOT NULL,
    ProductId INT NOT NULL,
    PRIMARY KEY (MenuId, ProductId),
    FOREIGN KEY (MenuId) REFERENCES [Menu](MenuId),
    FOREIGN KEY (ProductId) REFERENCES [Products](ProductId)
);
GO

CREATE TABLE [Tables]
(
    TableId INT NOT NULL IDENTITY,
    TableSize INT NOT NULL,
    -- IsFree BIT NOT NULL,
    PRIMARY KEY (TableId),
    CONSTRAINT TableSize CHECK (TableSize > 0)
);
GO

CREATE TABLE [Clients]
(
    ClientId INT NOT NULL IDENTITY,
    FirstName VARCHAR(50) NOT NULL,
    CompanyName VARCHAR(50),
    PhoneNumber INT NOT NULL,
    Email VARCHAR(50) NOT NULL,
    PRIMARY KEY (ClientId),
    CONSTRAINT CK_PhoneNumber CHECK (PhoneNumber > 0)
);

CREATE TABLE [Reservations]
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

CREATE TABLE [Discounts]
(
    DiscountId INT NOT NULL IDENTITY,
    ClientId INT NOT NULL,
    OrderId INT NOT NULL,
    DiscountPercentage DECIMAL(10, 2) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    PRIMARY KEY (DiscountId),
    FOREIGN KEY (ClientId) REFERENCES [Clients](ClientId),
    FOREIGN KEY (OrderId) REFERENCES [Orders](OrderId),
    CONSTRAINT CK_DiscountPercentage CHECK (DiscountPercentage > 0),
    CONSTRAINT CK_Date_Table CHECK (StartDate < EndDate)
);
GO