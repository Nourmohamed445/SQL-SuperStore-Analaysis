-- CREATE THE SILVER LAYER DDL TABLES 
-- ========================================
-- ORDER TABLE
IF OBJECT_ID('slayer.orders','U') IS NOT NULL
    DROP TABLE slayer.orders;
GO

CREATE TABLE slayer.orders (
    Order_id            NVARCHAR(50),
    Order_date          DATE,
    Ship_date           DATE,
    Ship_mode           NVARCHAR(50),
    dwh_create_date			DATETIME2 DEFAULT GETDATE()
);
GO

-- ========================================
-- CUSTOMERS TABLE
IF OBJECT_ID('slayer.customers','U') IS NOT NULL
    DROP TABLE slayer.customers;
GO

CREATE TABLE slayer.customers (
    Customer_id         NVARCHAR(50),
    Customer_name       NVARCHAR(50),
    Segment             NVARCHAR(50),
    dwh_create_date			DATETIME2 DEFAULT GETDATE()
);
GO

-- ========================================
-- LOCATIONS TABLE
IF OBJECT_ID('slayer.locations','U') IS NOT NULL
    DROP TABLE slayer.locations;
GO

CREATE TABLE slayer.locations (
    Country             NVARCHAR(50),
    City                NVARCHAR(50),
    State               NVARCHAR(50),
    Postel_Code         NVARCHAR(50),
    Region              NVARCHAR(50),
    dwh_create_date			DATETIME2 DEFAULT GETDATE()
);
GO

-- ========================================
-- PRODUCTS TABLE
IF OBJECT_ID('slayer.products','U') IS NOT NULL
    DROP TABLE slayer.products;
GO

CREATE TABLE slayer.products (
    Product_id          NVARCHAR(50),
    Category            NVARCHAR(50),
    Subcategory         NVARCHAR(50),
    Product_name        NVARCHAR(MAX),
    dwh_create_date			DATETIME2 DEFAULT GETDATE()
);
GO

-- ========================================
-- SALES TABLE
IF OBJECT_ID('slayer.sales', 'U') IS NOT NULL
    DROP TABLE slayer.sales;
GO

CREATE TABLE slayer.sales (
    Order_ID            NVARCHAR(50),
    Customer_ID         NVARCHAR(50),
    Product_ID          NVARCHAR(50),
    Sales               DECIMAL(10,2),
    Quantity            INT,
    Discount            DECIMAL(4,2),
    Profit              DECIMAL(10,2),
    dwh_create_date			DATETIME2 DEFAULT GETDATE()
);
GO
