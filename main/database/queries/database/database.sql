-- ==============================================================
-- Author:		Radoslaw Kluczewski
-- Description:	Script that creates a new database for restaurant
-- ==============================================================
USE master;
GO

IF DB_ID('RestaurantDB') IS NOT NULL
    DROP DATABASE RestaurantDB;
GO

CREATE DATABASE RestaurantDB;
GO