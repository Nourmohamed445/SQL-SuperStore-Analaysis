USE superStore;

-- check if the table exists before
IF OBJECT_ID('fLayer.superStore_raw','U') IS NOT NULL
    BEGIN 
        DROP TABLE fLayer.superStore_raw;
    END;

GO
-- ddl create the table for the file 
CREATE TABLE fLayer.superStore_raw (
    RowID                   INT,
    OrderID                 NVARCHAR(20),
    OrderDate               DATE,
    ShipDate                DATE,
    ShipMode                NVARCHAR(50),
    CustomerID              NVARCHAR(20),
    CustomerName            NVARCHAR(100),
    Segment                 NVARCHAR(50),
    Country                 NVARCHAR(50),
    City                    NVARCHAR(50),
    State                   NVARCHAR(50),
    PostalCode              NVARCHAR(20),
    Region                  NVARCHAR(50),
    ProductID               NVARCHAR(20),
    Category                NVARCHAR(50),
    SubCategory             NVARCHAR(50),
    ProductName             NVARCHAR(300),
    Sales                   FLOAT,
    Quantity                INT,
    Discount                FLOAT,
    Profit                  FLOAT
);
