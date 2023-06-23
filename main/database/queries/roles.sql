USE [Restaurant-db];
GO

CREATE ROLE [Restaurant-Admin];
GO

GRANT ALL PRIVILEGES ON [Restaurant-db] TO [Restaurant-Admin];
GO

CREATE ROLE [Restaurant-Manager];

GO
GRANT EXECUTE ON AddNewCategory TO [Restaurant-Manager];
-- RESZTE TAK SAMO, ZOBACZYC O CO CHODFZI Z TYM SELECT ZAMIAST EXECUTE
GO

CREATE ROLE [Restaurant-Worker];
GO

GRANT EXECUTE ON AddProductIntoMenu TO [Restaurant-Worker]
-- RESZTA
GO

CREATE ROLE [Restaurant-Client];
GO

GRANT EXECUTE ON [Actual-Menu] TO [Restaurant-Client];
GO