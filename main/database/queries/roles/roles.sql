USE RestaurantDB;
GO

CREATE ROLE RestaurantAdmin;
GO

-- Admin
GRANT ALL PRIVILEGES ON RestaurantDB TO RestaurantAdmin;
GO

-- Client
CREATE ROLE RestaurantClient;
GO

GRANT EXECUTE ON ActualMenu TO RestaurantClient;
GRANT EXECUTE ON ShowAvailableCategories TO RestaurantClient;
GRANT EXECUTE ON AddProductToOrder TO RestaurantClient; --ZASTANOWIC SIE NAD TYM
GRANT EXECUTE ON AddNewReservation TO RestaurantClient; --ZASTANOWIC SIE NAD TYM
GRANT EXECUTE ON AddNewOrder TO RestaurantClient; --ZASTANOWIC SIE NAD TYM
GRANT EXECUTE ON CheckAllDiscountsForClient TO RestaurantClient; --ZASTANOWIC SIE NAD TYM
GO

-- Worker
CREATE ROLE RestaurantWorker;
GO

-- Grant previous privileges from RestaurantClient
SELECT GrantPrivileges('RestaurantClient', 'RestaurantWorker');
GO

GRANT EXECUTE ON ActualReservations TO RestaurantWorker;
GRANT EXECUTE ON ActualFreeTables TO RestaurantWorker;
GRANT EXECUTE ON AllDiscountsForClients TO RestaurantWorker;
GRANT EXECUTE ON AddNewInvoice TO RestaurantWorker;
GRANT EXECUTE ON AddPayment TO RestaurantWorker;
GRANT EXECUTE ON AddNewClient TO RestaurantWorker;
GRANT EXECUTE ON DeleteClient TO RestaurantWorker;
GRANT EXECUTE ON AddNewDiscount TO RestaurantWorker;
GRANT EXECUTE ON GenerateBill TO RestaurantWorker;
GRANT EXECUTE ON IfDiscountExistsForOrder TO RestaurantWorker;
GRANT EXECUTE ON SelectParameter TO RestaurantWorker;
GRANT EXECUTE ON GetInfoAboutProduct TO RestaurantWorker;
GRANT EXECUTE ON TakeClientDetails TO RestaurantWorker;
GRANT EXECUTE ON IfPaymentExists TO RestaurantWorker;
GRANT EXECUTE ON CheckIfItIsPossibleAddSeafoodToOrder TO RestaurantWorker;
GRANT EXECUTE ON CheckIfProductIsSeafood TO RestaurantWorker;

-- Manager
CREATE ROLE RestaurantManager;
GO

-- Grant previous privileges from RestaurantWorker
SELECT GrantPrivileges('RestaurantWorker', 'RestaurantManager');
GO

GO
GRANT EXECUTE ON MonthlyPaymentsInActualYear TO RestaurantManager;
GRANT EXECUTE ON MonthlyReservationsInActualYear TO RestaurantManager;
GRANT EXECUTE ON WeeklyReservationsInActualMonth TO RestaurantManager;
GRANT EXECUTE ON SeafoodOrders TO RestaurantManager;
GRANT EXECUTE ON SelectAllParameters TO RestaurantManager;
GRANT EXECUTE ON NumberOfDishesOrdered TO RestaurantManager;
GRANT EXECUTE ON AddNewCategory TO RestaurantManager;
GRANT EXECUTE ON UpdateCategory TO RestaurantManager;
GRANT EXECUTE ON AddNewProduct TO RestaurantManager;
GRANT EXECUTE ON UpdateProduct TO RestaurantManager;
GRANT EXECUTE ON AddNewMenu TO RestaurantManager;
GRANT EXECUTE ON AddProductIntoMenu TO RestaurantManager;
GRANT EXECUTE ON AddTable TO RestaurantManager;
GRANT EXECUTE ON AddAndUpdateParameters TO RestaurantManager;
GRANT EXECUTE ON MonthlyCompanyIncome TO RestaurantManager;
GRANT EXECUTE ON CheckIfMenuIsActual TO RestaurantManager;
GO