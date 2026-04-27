
  --testing the fact table
  select * 
  from gold.fact_sales f 
  left join gold.dim_customers c
  on c.customer_key = f.customer_key
   left join gold.dim_products p
  on p.prodcut_key= f.prodcut_key
  where p.prodcut_key is NULL
