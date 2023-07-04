USE RestaurantDB;
GO

INSERT INTO Parameters(PernamentDiscount, NotPernamentDiscount, NeededAmountOfOrderToDiscount, NeededNumberOfOrders, EndDateOfDiscount)
VALUES (0.03, 0.05, 1000, 10, 7); -- 3% zmizki, 1000 zl do znizki wymagane, 