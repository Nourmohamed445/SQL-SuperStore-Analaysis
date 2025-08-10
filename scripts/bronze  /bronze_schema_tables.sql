-- ========================================
-- ORDER TABLE
IF OBJECT_ID('flayer.orders','U') IS NOT NULL
    DROP TABLE flayer.orders;
GO

CREATE TABLE flayer.orders (
    Order_id    NVARCHAR(50),
    Order_date  DATE,
    Ship_date   DATE,
    Ship_mode   NVARCHAR(50)
);
GO

-- ========================================
-- CUSTOMERS TABLE
IF OBJECT_ID('flayer.customers','U') IS NOT NULL
    DROP TABLE flayer.customers;
GO

CREATE TABLE flayer.customers (
    Customer_id     NVARCHAR(50),
    Customer_name   NVARCHAR(50),
    Segment         NVARCHAR(50),
    Country         NVARCHAR(50),
    City            NVARCHAR(50),
    State           NVARCHAR(50),
    Postel_Code     NVARCHAR(50),
    Region          NVARCHAR(50)
);
GO

-- ========================================
-- PRODUCTS TABLE
IF OBJECT_ID('flayer.products','U') IS NOT NULL
    DROP TABLE flayer.products;
GO

CREATE TABLE flayer.products (
    Product_id      NVARCHAR(50),
    Category        NVARCHAR(50),
    Subcategory     NVARCHAR(50),
    Product_name    NVARCHAR(MAX)
);
GO

-- ========================================
-- SALES TABLE
-- SALES TABLE
IF OBJECT_ID('flayer.sales', 'U') IS NOT NULL
    DROP TABLE flayer.sales;
GO

CREATE TABLE flayer.sales (
    Order_id       NVARCHAR(50),
    Product_id     NVARCHAR(50),
    Customer_id    NVARCHAR(50),
    Sales          FLOAT,
    Quantity       INT,
    Discount       FLOAT,
    Profit         FLOAT
);
GO
