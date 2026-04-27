--DDL scripts that create silver tables
--this scripts creates tables in the silver layer and drop the existing tables if they already exists 

--careating silver schema 
--table1
if object_id ('silver.crm_cust_info','u') is not null
	drop table silver.crm_cust_info;
create table  silver.crm_cust_info(
	cst_id				int ,
	cst_key				nvarchar(50),
	cst_firstname		nvarchar(50),
	cst_lastname		nvarchar(50),
	cst_marital_status  nvarchar(50),
	cst_gndr			nvarchar(50),
	cst_create_date		date,
	dwh_start_date datetime2 default getdate()

);
--table2
if object_id ('silver.crm_prd_info','u') is not null
	drop table silver.crm_prd_info;
create table silver.crm_prd_info(
	prd_id			 int 	,
	cat_id		     nvarchar(50),
	prd_key			 nvarchar(50),
	prd_nm			 nvarchar(50),
	prd_cost		 int,
	prd_line		 nvarchar(50),
	prd_start_dt	 date,
	prd_end_dt		 date,
	dwh_start_date datetime2 default getdate()
);
--table 3
if object_id ('silver.crm_sales_details','u') is not null
	drop table silver.crm_sales_details;
create table    silver.crm_sales_details(
	sls_ord_num     nvarchar(50)	,
	sls_prd_key   	nvarchar(50),
	sls_cust_id	    int,
	sls_order_dt	    DATE,
	sls_ship_dt	    DATE,
	sls_due_dt	    DATE,
	sls_sales	    int,
	sls_quantity   	    int,
	sls_price           int,
	dwh_start_date datetime2 default getdate()
);
--table 4 
if object_id ('silver.erp_cust_az12','u') is not null
	drop table silver.erp_cust_az12;
create table silver.erp_cust_az12(
	cid   varchar	,
	bdate date	,
	gen   varchar
);
--table 5
if object_id ('silver.erp_loc_a101','u') is not null
	drop table silver.erp_loc_a101;
create table silver.erp_loc_a101(
	cid	    varchar,
	cntry   varchar,
	dwh_start_date datetime2 default getdate()

);
--table 6
if object_id ('silver.erp_px_cat_g1v2','u') is not null
	drop table silver.erp_px_cat_g1v2;
create table silver.erp_px_cat_g1v2(
	id	         nvarchar(50),
	cat	         nvarchar(50),
	subcat       nvarchar(50),
	maintenance  nvarchar(50),
	dwh_start_date datetime2 default getdate()
);
