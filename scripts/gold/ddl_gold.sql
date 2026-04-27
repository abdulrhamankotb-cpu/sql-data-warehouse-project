/* DDL script : create gold views 
==================================
script purpose :
 this script creates views for the gold layer in the datawarehouse 
=================================


CREATE VIEW gold.dim_products AS
SELECT  ROW_NUMBER()over(order by prd_id,prd_key ) as prodcut_key
	  ,pn.[prd_id]            as product_id 
      ,pn.[prd_key]           as product_number
      ,pn.[prd_nm]            as product_name 
	  ,pn.[cat_id]            as category_id
	  ,pc.[cat]               as category
      ,pc.[subcat]            as subcategory
	  ,pc.[maintenance]       
      ,pn.[prd_cost]          as cost
      ,pn.[prd_line]          as product_line
      ,pn.[prd_start_dt]      as start_date
 FROM [DataWarehouse].[silver].[crm_prd_info] as pn
left join [DataWarehouse].[silver].[erp_px_cat_g1v2]  as pc
on [cat_id]=id
where prd_end_dt is null

====================================

CREATE VIEW gold.dim_customers AS

SELECT ROW_NUMBER() OVER(ORDER BY ci.[cst_id]) AS  customer_key
	  ,ci.[cst_id] as customer_id
      ,ci.[cst_key] AS customer_number
      ,ci.[cst_firstname] AS first_name 
      ,ci.[cst_lastname] AS last_name
	  ,la.cntry  AS country
      ,ci.[cst_marital_status] marital_status
      ,case when ci.[cst_gndr] != 'N/A' then ci.[cst_gndr]
		   else coalesce(ca.gen,'N/A')
	   end gender
	   ,ca.bdate  AS birth_date
      ,ci.[cst_create_date] AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12  ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid

====================================

create view gold.fact_sales as 

SELECT sd.[sls_ord_num] as order_number 
      ,pr.[prodcut_key]
      ,cu.[customer_key]
      ,sd.[sls_order_dt] as order_date
      ,sd.[sls_ship_dt] as  shiping_date
      ,sd.[sls_due_dt]  as due_date
      ,sd.[sls_sales]  as sales_amount
      ,sd.[sls_quantity] as quantity
      ,sd.[sls_price]as price
  FROM [DataWarehouse].[silver].[crm_sales_details]  as sd 
  left join gold.dim_products as pr
  on sd.[sls_prd_key] =pr.[product_number]
  left join gold.dim_customers as cu
  on sd.[sls_cust_id] =cu.[customer_id]
  
  --testing the fact table
  select * 
  from gold.fact_sales f 
  left join gold.dim_customers c
  on c.customer_key = f.customer_key
   left join gold.dim_products p
  on p.prodcut_key= f.prodcut_key
  where p.prodcut_key is NULL

