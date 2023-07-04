-- ======================================================================
-- Author:		Radoslaw Kluczewski
-- Description:	Script that creates the indexes for restaurant's database
-- ======================================================================

USE RestaurantDB;
GO

-- Index of category id
CREATE UNIQUE INDEX Category_IDX
ON Categories (CategoryId);
GO

-- Index of product id
CREATE UNIQUE INDEX Product_IDX
ON Products (ProductId);
GO

-- Index of client id
CREATE UNIQUE INDEX Client_IDX
ON Clients (ClientId);
GO

-- Index of order id
CREATE UNIQUE INDEX Order_IDX
ON Orders (OrderId);
GO

-- Index of invoice id
CREATE UNIQUE INDEX Invoice_IDX
ON Invoices (InvoiceId);
GO

-- Index of payment id
CREATE UNIQUE INDEX Payment_IDX
ON Payments (PaymentId);
GO

-- Index of menu id
CREATE UNIQUE INDEX Menu_IDX
ON Menu (MenuId);
GO

-- Index of menu date
CREATE UNIQUE INDEX MenuDate_IDX
ON Menu (StartDate, EndDate);
GO

-- Index of table id 
CREATE UNIQUE INDEX Table_IDX
ON Tables (TableId);
GO

-- Index of reservation id
CREATE UNIQUE INDEX Reservation_IDX
ON Reservations (ReservationId);
GO

-- Index of discount id
CREATE UNIQUE INDEX Discount_IDX
ON Discounts (DiscountId);
GO