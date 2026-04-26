/*
====================================================
  DDL script that create bronze layer.
====================================================
  script purpose :
 this script creates tables in the bronze schema ,
 drop existing tables if they already exists
====================================================

*/


EXEC bronze.load_bronze


CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
	BEGIN TRY
		DECLARE @start_date DATETIME ,  @end_date DATETIME, @batchstr DATETIME , @batend DATETIME;
		PRINT ('*===============================================================*')
		PRINT ('loooooooooooadiiing Bronze layer')
		PRINT ('*===============================================================*')
		--tabel 1
		PRINT ('-------------------------')
		PRINT ('LOADING CRM')
		PRINT ('-------------------------')
		PRINT ('loading bronze.crm_cust_info')
		TRUNCATE TABLE bronze.crm_cust_info;
		SET @start_date = GETDATE();
		SET @batchstr = GETDATE();
		BULK INSERT bronze.crm_cust_info
		FROM 'H:\الكلية\Data\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW =2 ,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_date=GETDATE();
		PRINT 'LOADING TIME :'+ CAST(DATEDIFF(SECOND, @start_date,@end_date) AS NVARCHAR)+ 'secounds';
		--SELECT count(*) FROM bronze.crm_cust_info	

		--====================================================
		-- table 2
		PRINT ('-------------------------')
		PRINT ('loading bronze.crm_prd_info')
		TRUNCATE TABLE bronze.crm_prd_info
		BULK INSERT bronze.crm_prd_info
		FROM 'H:\الكلية\Data\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR= ',',
			TABLOCK

		);
		--SELECT * FROM bronze.crm_prd_info

		--====================================================
		--Table 3
		PRINT ('-------------------------')
		PRINT ('loading bronze.crm_prd_info')
		TRUNCATE TABLE bronze.crm_sales_details
		BULK INSERT bronze.crm_sales_details
		FROM "H:\الكلية\Data\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_crm\sales_details.csv"
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		--SELECT * FROM bronze.crm_sales_details

		--====================================================

		--table 4
		TRUNCATE TABLE bronze.erp_cust_az12
		BULK INSERT bronze.erp_cust_az12
		FROM 'H:\الكلية\Data\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW=2,
			FIELDTERMINATOR= ',',
			TABLOCK
		);
		--SELECT * FROM bronze.erp_cust_az12


		--====================================================

		--table 5
		PRINT ('-------------------------')
		PRINT ('LOADING ERP')
		PRINT ('-------------------------')
		PRINT ('loading bronze.erp_loc_a101')
		TRUNCATE TABLE bronze.erp_loc_a101
		BULK INSERT bronze.erp_loc_a101
		FROM "H:\الكلية\Data\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv"
		WITH (
			FIRSTROW =2,
			FIELDTERMINATOR= ',',
			TABLOCK
		)
		--SELECT * FROM bronze.erp_loc_a101

		--====================================================

		--table 6
		print('loading bronze.erp_px_cat_g1v2')
		TRUNCATE TABLE bronze.erp_px_cat_g1v2
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM "H:\الكلية\Data\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv"
		WITH (
			FIRSTROW =2,
			FIELDTERMINATOR=',',
			TABLOCK
		);
		SET @batend = GETDATE();
		PRINT 'LOADING BRONZE TIME:'+ CAST(DATEDIFF(SECOND,@batchstr ,@batend ) AS  NVARCHAR) ;

		--SELECT * FROM bronze.erp_px_cat_g1v2
	END TRY

	BEGIN CATCH
		PRINT '------------==--------------------------------';
		PRINT 'THERE ARE AN ERROR AT BRONZE LAYER ';
		PRINT 'ERROR MESSAGE'+ERROR_MESSAGE();
		PRINT '------------==--------------------------------';
	END CATCH
END


print ('loading process is done ');

