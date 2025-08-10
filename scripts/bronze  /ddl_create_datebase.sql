-- Superstore Sales Analysis Project
-- This folder contains scripts for database creation, schema design, and data loading.
/*
  1- we are using if exists to check the existance 
  2- creating 3 layers to divide and distributing the data 
*/
use master ;

-- check if there is a database with this name superStore
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'superStore' )
	BEGIN 
		ALTER DATABASE superStore SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE superStore ;
	END 

GO 

-- after check if its not exist then drop it 
CREATE DATABASE superStore;
GO

-- USING IT
USE superStore;
GO

-- first layer
CREATE SCHEMA fLayer;
GO
  
-- second layer
CREATE SCHEMA sLayer;
GO

-- third layer
CREATE SCHEMA thLayer;
GO

