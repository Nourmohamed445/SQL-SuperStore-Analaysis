CREATE OR ALTER PROCEDURE slayer.load_silver AS 
BEGIN 
    BEGIN TRY 
		DECLARE @start_time DATETIME , @end_time DATETIME; -- Creating variables
		DECLARE @START_LOADING_TIME DATETIME , @END_LOADING_TIME DATETIME -- VARIABLE FOR THE WHOLE BATCH
        -- ============================
        -- ORDERS TABLE
                
        SET @start_time = GETDATE();
		    PRINT('>> Truncate data from table : sLayer.orders ' );
        IF OBJECT_ID('sLayer.orders','U') IS NOT NULL 
            TRUNCATE TABLE sLayer.orders;

        PRINT('>> Insert data into table : sLayer.orders ' );
        INSERT INTO sLayer.orders (Order_id, Order_date, Ship_date, Ship_mode)
        SELECT 
                Order_id, 
                Order_date, 
                Ship_date, 
                Ship_mode
        FROM (
            SELECT 
                Order_id,
                CAST(Order_date AS DATE) Order_date,
                CAST(Ship_date AS DATE) Ship_date,
                TRIM(Ship_mode) Ship_mode,
                ROW_NUMBER() OVER (PARTITION BY Order_id ORDER BY Order_date) AS rn
            FROM fLayer.orders
            WHERE Order_id IS NOT NULL
        ) t
        WHERE rn = 1;
                
        SET @end_time = GETDATE();
		    PRINT 'Load Duration : ' + CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR ) + ' Seconds' 
		    PRINT('_______________________________________________');

        -- ============================
        -- CUSTOMERS TABLE
                
        SET @start_time = GETDATE();
	    	PRINT('>> Truncate data from table : sLayer.customers ' );
        IF OBJECT_ID('sLayer.customers','U') IS NOT NULL 
            TRUNCATE TABLE sLayer.customers;

        
        PRINT('>> Insert data into table : sLayer.customers ' ); 
        INSERT INTO sLayer.customers (Customer_ID, Customer_Name, Segment)
        SELECT 
                Customer_ID,
                Customer_Name,
                Segment
        FROM (
            SELECT 
                Customer_ID,
                TRIM(Customer_Name) Customer_Name,
                TRIM(Segment)       Segment,
                ROW_NUMBER() OVER (PARTITION BY Customer_ID ORDER BY customer_id) AS rn
            FROM fLayer.customers
            WHERE Customer_ID IS NOT NULL
        ) t
        WHERE rn = 1;
        
        SET @end_time = GETDATE();
    		PRINT 'Load Duration : ' + CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR ) + ' Seconds' 
    		PRINT('_______________________________________________');

        -- ============================
        -- PRODUCTS TABLE
        
        SET @start_time = GETDATE();
		    PRINT('>> Truncate data from table : sLayer.products ' );
        IF OBJECT_ID('sLayer.products', 'U') IS NOT NULL
            TRUNCATE TABLE sLayer.products;
        
		    PRINT('>> Insert data into table : sLayer.products ' );
        INSERT INTO sLayer.products (Product_ID, Category, Subcategory, Product_Name)
        SELECT 
                Product_id,
                Category,
                Subcategory,
                Product_name
        FROM (
            SELECT  
                PRODUCT_ID,
                TRIM(Category)        Category,
                TRIM(Subcategory)     Subcategory,
                TRIM(Product_name)    Product_name,
                ROW_NUMBER() OVER(PARTITION BY PRODUCT_ID ORDER BY PRODUCT_NAME DESC) AS PRODUCT_RANK
            FROM fLayer.products
        ) t 
        WHERE PRODUCT_RANK = 1;
        
        SET @end_time = GETDATE();
    		PRINT 'Load Duration : ' + CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR ) + ' Seconds' 
    		PRINT('_______________________________________________');

        -- ============================
        -- LOCATIONS TABLE

        SET @start_time = GETDATE();
		    PRINT('>> Truncate data from table : sLayer.locations ' );
        IF OBJECT_ID('sLayer.locations', 'U') IS NOT NULL
            TRUNCATE TABLE sLayer.locations;
        
		    PRINT('>> Insert data into table : sLayer.locations ' );
        INSERT INTO sLayer.locations (Country, City, State, Postel_Code, Region)
        SELECT 
                Country,
                City,
                State,
                Postel_Code,
                Region
        FROM (
            SELECT 
            TRIM(Country)      Country,
            TRIM(City)         City,
            TRIM(State)        State,
            Postel_Code,
            TRIM(Region)       Region,
                ROW_NUMBER() OVER (
                    PARTITION BY Country, City, State, Postel_Code, Region 
                    ORDER BY Country
                ) AS loc_rank
            FROM fLayer.locations
            WHERE Postel_Code IS NOT NULL
        ) t
        WHERE loc_rank = 1;

        SET @end_time = GETDATE();
    		PRINT 'Load Duration : ' + CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR ) + ' Seconds' 
    		PRINT('_______________________________________________');
        

        -- ============================
        -- Clean & load SALES table from fLayer to sLayer

        SET @start_time = GETDATE();
		PRINT('>> Truncate data from table : slayer.sales ' );
        IF OBJECT_ID('sLayer.sales', 'U') IS NOT NULL
            TRUNCATE TABLE sLayer.sales;
        
        PRINT('>> INSERT data into table : slayer.sales ' );
        INSERT INTO sLayer.sales (
            Order_ID,
            Product_ID,
            Customer_ID,
            Quantity,
            Discount,
            Sales,
            Profit
        )
        SELECT 
            TRIM(Order_ID)         AS Order_ID,
            TRIM(Product_ID)       AS Product_ID,
            TRIM(Customer_ID)      AS Customer_ID,
            CAST(Quantity AS INT)  AS Quantity,
            CAST(Discount AS DECIMAL(5, 2)) AS Discount,
            CAST(Sales AS DECIMAL(12, 2))   AS Sales,
            CAST(Profit AS DECIMAL(12, 2))  AS Profit
        FROM (
            SELECT *,
                ROW_NUMBER() OVER (
                    PARTITION BY Order_ID, Product_ID
                    ORDER BY Sales DESC
                ) AS rn
            FROM fLayer.sales
            WHERE 
                Order_ID IS NOT NULL
                AND Product_ID IS NOT NULL
                AND Customer_ID IS NOT NULL
                AND ISNUMERIC(Sales) = 1
                AND ISNUMERIC(Profit) = 1
                AND ISNUMERIC(Discount) = 1
        ) cleaned
        WHERE rn = 1
        AND CAST(Profit AS FLOAT) BETWEEN -10000 AND 10000
        AND CAST(Discount AS FLOAT) BETWEEN 0 AND 1
        AND CAST(Sales AS FLOAT) > 0;

        		SET @end_time = GETDATE();
		PRINT 'Load Duration : ' + CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR ) + ' Seconds' 
		PRINT('_______________________________________________');

		SET @END_LOADING_TIME = GETDATE();
		PRINT 'Whole Batch Loading Duration : ' + CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR ) + ' Seconds' 
		PRINT('_______________________________________________');
	END TRY 

    	--------------------------------------- CATCH ( Handling the Error ) --------------------------------
	BEGIN CATCH
		PRINT('----------------------------------------------------');
		PRINT('ERROR OCCURED DURING LOADING THE DATA FROM THE FILES');
		PRINT('ERROR MESSAGE : ' + ERROR_MESSAGE()); -- RETURN THE MESSAGE OF THE ERROR 
		PRINT('ERROR MESSAGE : ' +	CAST(ERROR_NUMBER() AS NVARCHAR ));	-- RETURN THE ERROR NUMBER
		PRINT('ERROR MESSAGE : ' + ERROR_PROCEDURE());		-- RETURN THE PREOCEDURE NAME THAT OCCURED AN ERROR 
		PRINT('ERROR MESSAGE : ' + CAST(ERROR_LINE()AS NVARCHAR)); -- RETURN THE LINE NUMBER THAT HAS THE ERROR 
		PRINT('----------------------------------------------------');
	END CATCH

END 
