/*
=========================================================
stored procedure : load silver layer(from bronze -> silver) 
=========================================================
*/
--CREATING SILVER LAYER FROM SCRATCH

-- use this  to run the quiries EXEC silver.load_silver


CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN

	--TABLE 1
	DECLARE @start as datetime , @end as datetime , @batstart as datetime , @batend as datetime
	BEGIN TRY
		set @batstart= getdate()
		PRINT ('<<>>TRUNCATING TABLE crm_cust_info>><<<')
		PRINT ('===========================')
		TRUNCATE TABLE silver.crm_cust_info
		PRINT ('<<>>INSERTING INTO TABLES>><<<')

		insert into silver.crm_cust_info(
			   [cst_id]
			  ,[cst_key]
			  ,[cst_firstname]
			  ,[cst_lastname]
			  ,[cst_marital_status]
			  ,[cst_gndr]
			  ,[cst_create_date]
		)

		select cst_id,
			   cst_key,
			   trim(cst_firstname) as cst_firstname,
			   trim(cst_lastname)  as cst_lastname,
			   case when upper(trim(cst_marital_status)) ='S' then 'Single'
					when upper(trim(cst_marital_status)) ='M' then 'Married'
					else 'N/A'
			   end cst_marital_status,
			   case when upper(trim(cst_gndr)) ='F' then 'Female'
					when upper(trim(cst_gndr)) ='M' then 'male'
					else 'N/A'
			   end cst_gndr,
			   cst_create_date
		from (
			select * ,
			ROW_NUMBER() over(partition by cst_id order by cst_create_date desc) as flag
			from  bronze.crm_cust_info
			where cst_id is not null
		)t  where flag =1

		--========================================================================
		--table 2
		PRINT ('<<>>TRUNCATING TABLE crm_prd_info>><<<')
		PRINT ('===========================')
		TRUNCATE TABLE silver.crm_prd_info
		PRINT ('<<>>INSERTING INTO TABLES>><<<')

		INSERT INTO silver.crm_prd_info (
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)
		SELECT
			prd_id,
			REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
			SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
			prd_nm,
			ISNULL(prd_cost, 0) AS prd_cost,
			CASE 
				WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
				WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
				WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
				WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
				ELSE 'n/a'
			END AS prd_line,
			CAST(prd_start_dt AS DATE) AS prd_start_dt,
			-- الحل: حول الـ LEAD لـ DATE أولاً، وبعدين استخدم DATEADD
			CAST(
				DATEADD(DAY, -1, CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) AS DATE)) 
				AS DATE
			) AS prd_end_dt
		FROM bronze.crm_prd_info;
		--======================================================================

		--filtering THIRD table in the bronze and transfer if to silver
		--  table 3
		PRINT ('<<>>TRUNCATING TABLE crm_sales_details>><<<')
		PRINT ('===========================')
		TRUNCATE TABLE silver.crm_sales_details
		PRINT ('<<>>INSERTING INTO TABLES>><<<')

		INSERT INTO [DataWarehouse].[silver].[crm_sales_details](
			   [sls_ord_num]
			  ,[sls_prd_key]
			  ,[sls_cust_id]
			  ,[sls_order_dt]
			  ,[sls_ship_dt]
			  ,[sls_due_dt]
			  ,[sls_sales]
			  ,[sls_quantity]
			  ,[sls_price]
		)
		SELECT [sls_ord_num]
			  ,[sls_prd_key]
			  ,[sls_cust_id]
			  ,CASE WHEN LEN(sls_order_dt)!=8 or sls_order_dt=0 THEN NULL
					ELSE CAST(CAST(sls_order_dt AS varchar)AS date)
			   END  AS sls_order_dt
			  ,CASE WHEN LEN(sls_ship_dt)!=8 or sls_ship_dt=0 THEN NULL
					ELSE CAST(CAST(sls_ship_dt AS varchar)AS date)
				END  AS sls_ship_dt
			  ,CASE WHEN LEN(sls_due_dt)!=8 or sls_due_dt=0 THEN NULL
					ELSE CAST(CAST(sls_due_dt AS varchar)AS date)
				END  AS sls_due_dt
			  ,CASE WHEN sls_sales != sls_quantity*abs(sls_price) or sls_sales is null or sls_sales< 0 
						 then sls_quantity*abs(sls_price)
					ELSE sls_sales
				END sls_sales
			  ,[sls_quantity]
			  ,CASE WHEN sls_price < 0 OR sls_price  IS NULL THEN  sls_sales/NULLIF(sls_quantity,0)
					ELSE sls_price
				END sls_price
		  FROM [DataWarehouse].[bronze].[crm_sales_details]


		--==========================================================================
		--filtering table number 4in the bronze and transfer if to silver
		--  table 4
		PRINT ('<<>>TRUNCATING TABLE erp_cust_az12>><<<')
		PRINT ('===========================')
		TRUNCATE TABLE silver.erp_cust_az12
		PRINT ('<<>>INSERTING INTO TABLE erp_cust_az12>><<<')

		drop table silver.erp_cust_az12;
		create table silver.erp_cust_az12(
			cid   NVARCHAR(50)	,
			bdate date	,
			gen    NVARCHAR(50))

		INSERT INTO silver.erp_cust_az12
		(
			cid,
			bdate,
			gen
		)

		SELECT DISTINCT 
			   CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING([cid],4,LEN(cid))
				   ELSE cid 
			   END  AS cid
			  ,CASE WHEN bdate > GETDATE() THEN NULL 
					ELSE bdate
			   END AS bdate
			  ,CASE WHEN UPPER(TRIM(gen)) IN ('F' , 'FEMALE') THEN 'Female'
					WHEN UPPER(TRIM(gen)) IN ('M' , 'MALE')   THEN 'Male'
					ELSE 'N/A'
			   END AS gen
		  FROM [DataWarehouse].[bronze].[erp_cust_az12]
		--===============================================================
		--table 5

		PRINT ('<<>>TRUNCATING TABLE erp_loc_a101>><<<')
		PRINT ('===========================')
		TRUNCATE TABLE silver.erp_loc_a101
		PRINT ('<<>>INSERTING INTO TABLE erp_loc_a101>><<<')

		alter table silver.erp_loc_a101 
		alter column cid  nvarchar(50)

		alter table silver.erp_loc_a101 
		alter column cntry  nvarchar(50)

		INSERT INTO silver.erp_loc_a101
		(
		cid,cntry
		)
		SELECT REPLACE (cid, '-','') cid,
			   CASE WHEN TRIM(cntry) IN ('USA', 'US') THEN 'United Stats'
					WHEN TRIM(cntry) = 'DE' THEN 'Germany'
					WHEN TRIM(cntry) = '' or cntry IS NULL THEN 'N/A'
					else TRIM(cntry)
			   END AS cntry 
		FROM [DataWarehouse].[bronze].[erp_loc_a101]
      





		--=============================================================


		-- maintainance and inserting into table 6


		drop table silver.erp_px_cat_g1v2;
		create table silver.erp_px_cat_g1v2(
			id	         nvarchar(50),
			cat	         nvarchar(50),
			subcat       nvarchar(50),
			maintenance  nvarchar(50),
			dwh_start_date datetime2 default getdate()
		);
		PRINT ('<<>>TRUNCATING TABLE erp_px_cat_g1v2>><<<')
		PRINT ('===========================')
		TRUNCATE TABLE silver.erp_px_cat_g1v2
		PRINT ('<<>>INSERTING INTO TABLE erp_px_cat_g1v2>><<<')
		INSERT INTO silver.erp_px_cat_g1v2
		(
			   [id]
			  ,[cat]
			  ,[subcat]
			  ,[maintenance]
		)
		SELECT TOP (1000) [id]
			  ,[cat]
			  ,[subcat]
			  ,[maintenance]
		  FROM [DataWarehouse].[bronze].[erp_px_cat_g1v2]
		
	  	set @batend= getdate();
		print ('total batchtime '+ cast(datediff(second,@batstart,@batend) as nvarchar)+' secounds')
		END TRY 
		BEGIN CATCH 
			PRINT '=========================================='
			PRINT 'ERROR DURING LOADING BRONZE LAYER'
			PRINT 'ERROR MESSAGE '+ERROR_MESSAGE()
			PRINT 'ERROR NUMBR'+CAST(ERROR_NUMBER() AS NVARCHAR)
		END CATCH
END

