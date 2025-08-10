CREATE OR ALTER PROCEDURE flayer.load_bronze AS 
BEGIN 
    BEGIN TRY 
		DECLARE @start_time DATETIME , @end_time DATETIME; -- Creating variables
		DECLARE @START_LOADING_TIME DATETIME , @END_LOADING_TIME DATETIME -- VARIABLE FOR THE WHOLE BATCH

        --=========================================
        -- ORDER TABLE 
                        
        SET @start_time = GETDATE();
		PRINT('>> Truncate data from table : fLayer.orders ' );
        IF OBJECT_ID('fLayer.orders','U') IS NOT NULL 
	        TRUNCATE TABLE fLayer.orders;

		PRINT('>> Insert data into table : fLayer.orders ' );
        INSERT INTO fLayer.orders(Order_id,Order_date,Ship_date,Ship_mode)
        SELECT	
	        Order_ID,
	        TRY_CAST(Order_Date AS DATE),
	        TRY_CAST(Ship_Date AS DATE),
	        Ship_Mode
        FROM fLayer.SuperStore_raw;

                        
        SET @end_time = GETDATE();
		    PRINT 'Load Duration : ' + CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR ) + ' Seconds' 
		    PRINT('_______________________________________________');

        --=========================================
        -- CUSTOMERS TABLE 
                                
        SET @start_time = GETDATE();
		PRINT('>> Truncate data from table : sLayer.customers ' );
        IF OBJECT_ID('fLayer.customers','U') IS NOT NULL 
	        TRUNCATE TABLE fLayer.customers;

		PRINT('>> Insert data into table : fLayer.customers ' );
        INSERT INTO flayer.customers (Customer_id, Customer_name, Segment,Country, City, State, Postel_Code, Region)
        SELECT 
            Customer_ID,
            Customer_Name,
            Segment,
            Country,
            City,
            State,
            TRY_CAST(Postal_Code AS nvarchar),
            Region
        FROM flayer.superstore_raw;

                        
        SET @end_time = GETDATE();
		    PRINT 'Load Duration : ' + CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR ) + ' Seconds' 
		    PRINT('_______________________________________________');


        --=========================================
        -- PRODUCTS TABLE
                                                
        SET @start_time = GETDATE();
		PRINT('>> Truncate data from table : fLayer.products ' );
        IF OBJECT_ID('fLayer.products','U') IS NOT NULL 
	        TRUNCATE TABLE fLayer.products;

		PRINT('>> Insert data into table : fLayer.products ' );
        INSERT INTO flayer.products (Product_id, Category, Subcategory, Product_name)
        SELECT 
            Product_ID,
            Category,
            Sub_Category,
            Product_Name
        FROM flayer.superstore_raw;
                        
        SET @end_time = GETDATE();
		    PRINT 'Load Duration : ' + CAST(DATEDIFF(Second,@start_time,@end_time) AS NVARCHAR ) + ' Seconds' 
		    PRINT('_______________________________________________');

        --=========================================
        -- SALES TABLE 
                                
        SET @start_time = GETDATE();
		PRINT('>> Truncate data from table : fLayer.sales ' );
        IF OBJECT_ID('fLayer.sales','U') IS NOT NULL 
	        TRUNCATE TABLE fLayer.sales;


		PRINT('>> Insert data into table : fLayer.sales ' );
        INSERT INTO flayer.sales (Order_id, Product_id, Customer_id, Sales, Quantity, Discount, Profit)
        SELECT
            Order_ID,
            Product_ID,
            Customer_ID,
            TRY_CAST(Sales AS FLOAT),
            TRY_CAST(Quantity AS INT),
            TRY_CAST(Discount AS FLOAT),
            TRY_CAST(Profit AS FLOAT)
        FROM flayer.superstore_raw;
                        
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

EXEC fLayer.load_bronze
