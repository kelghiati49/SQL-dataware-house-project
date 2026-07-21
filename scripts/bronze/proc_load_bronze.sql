/*

Stored Procedure: Load Bronze Layer (Source -> Bronze)

Script Purpose:
  This stored procedure loads data into the 'bronze' schema from external CSV files.
  It performs the following actions:
      - Truncates the bronze tables before loading data.
      - Uses the 'BULK INSERT' command to load data from csv Files to bronze tables.

Parameters:
    None.
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze. load_bronze;

*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
  DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start DATETIME, @batch_end DATETIME;
  BEGIN TRY
        SET @batch_start = GETDATE();
		PRINT'###################################';
		PRINT'Loading Bronze Layer';
		PRINT'###################################';

		PRINT'------------       ------------------------ ';
		PRINT 'Loading CRM Tables';
		PRINT'------------       ------------------------ ';


		SET @start_time = GETDATE();
		/* Truncate(drop) all the data then load the csv to it again : NO dublicates*/
		PRINT' >> Truncating Table :  bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT' >> Inserting Data Into : bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\LENOVO\OneDrive\Bureau\Projects\Datawarehouse\source_crm\cust_info.csv'
		WITH (
		  FIRSTROW = 2              /* Skip header*/,
		  FIELDTERMINATOR = ',',    /*define the delimiter */
		  TABLOCK
		);
		/* QUALITY CHECK: let's check the loaded data 
		SELECT * FROM bronze.crm_cust_info;
		SELECT COUNT(*) FROM bronze.crm_cust_info; */
		SET @end_time = GETDATE();
		PRINT'>> Load Duration ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)+' Seconds';
        PRINT'>> --------------';

		SET @start_time = GETDATE();
		PRINT' >> Truncating Table : bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		PRINT' >> Inserting Data Into : bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\LENOVO\OneDrive\Bureau\Projects\Datawarehouse\source_crm\prd_info.csv'
		WITH (
		  FIRSTROW = 2 ,	
		  FIELDTERMINATOR = ',',  
		  TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>> Load Duration ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)+' Seconds';
        PRINT'>> --------------';


		SET @start_time = GETDATE();
		PRINT' >> Truncating Table :crm_sales_details ';
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT' >> Inserting Data Into : bronze.crm_sales_details ';
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\LENOVO\OneDrive\Bureau\Projects\Datawarehouse\source_crm\sales_details.csv'
		WITH (
		  FIRSTROW = 2 ,
		  FIELDTERMINATOR = ',',    
		  TABLOCK
		); 
		SET @end_time = GETDATE();
		PRINT'>> Load Duration ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)+' Seconds';
        PRINT'>> --------------';

		PRINT'--------------       ------------------------ ';
		PRINT 'Loading ERP Tables';
		PRINT'--------------       ------------------------ ';

		SET @start_time = GETDATE();
		PRINT' >> Truncating Table : erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
		PRINT' >> Inserting Data Into : bronze.erp_cust_az12 ';
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\LENOVO\OneDrive\Bureau\Projects\Datawarehouse\source_erp\CUST_AZ12.csv'
		WITH (
		  FIRSTROW = 2 ,
		  FIELDTERMINATOR = ',',    
		  TABLOCK
		);
        SET @end_time = GETDATE();
		PRINT'>> Load Duration ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)+ ' Seconds';
        PRINT'>> --------------';

		SET @start_time = GETDATE();
		PRINT' >> Truncating Table : bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		PRINT' >> Inserting Data Into : bronze.erp_loc_a101 ';
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\LENOVO\OneDrive\Bureau\Projects\Datawarehouse\source_erp\LOC_A101.csv'
		WITH (
		  FIRSTROW = 2 ,
		  FIELDTERMINATOR = ',',    
		  TABLOCK
		);
	    SET @end_time = GETDATE();
		PRINT'>> Load Duration ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)+' Seconds';
        PRINT'>> --------------';

		SET @start_time = GETDATE();
		PRINT' >> Truncating Table : bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		PRINT' >> Inserting Data Into : bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\LENOVO\OneDrive\Bureau\Projects\Datawarehouse\source_erp\PX_CAT_G1V2.csv'
		WITH (
		  FIRSTROW = 2 ,
		  FIELDTERMINATOR = ',',    
		  TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>> Load Duration ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)+' Seconds';
        PRINT'>> --------------';

		SET @batch_end = GETDATE();
		PRINT'########################################################';
		PRINT'LOADING Bronze Layer Is Completed';
		PRINT'>> Total Load Duration ' + CAST(DATEDIFF(SECOND,@batch_start,@batch_end) AS NVARCHAR)+' Seconds';
		PRINT'#######33#################################################';
 
 
 
 END TRY
 
 BEGIN CATCH
    PRINT'#########################################';
	PRINT'ERROR OCCURED DURING LOADING BRONZE LAYER';
	PRINT'ERROR MESSAGE ' + ERROR_MESSAGE();
	PRINT'ERROR MESSAGE ' + CAST(ERROR_NUMBER()AS NVARCHAR);
	PRINT'#########################################';
 END CATCH
END
