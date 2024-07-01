With input as  
(select  
  format_date('%E4Y-%m', y.created_at) as Month, 
  extract(year from y.created_at) as Year,
  z.category as Product_category,
  sum(sale_price) as TPV,
  sum(cost) as Total_cost,
  count(distinct y.order_id) as TPO
  from bigquery-public-data.thelook_ecommerce.orders x, 
       bigquery-public-data.thelook_ecommerce.order_items y,
       bigquery-public-data.thelook_ecommerce.products z
where x.order_id = y.order_id and y.product_id = z.id and x.status = 'Complete'
group by Year, Month, z.category
order by Year, Month)

select *, round((Total_profit / Total_cost),2) as Profit_to_cost_ratio from (
Select Month, Year, Product_category, 
       round(TPV,2) as TPV, 
       lag(TPV) over (partition by Product_category order by Year, Month) as prev,
       TPO,
       round(((TPV - lag(TPV) over (partition by Product_category order by Year, Month))*100/lag(TPV) over (partition by Product_category order by Month)),2) as Revenue_growth,
       round(((TPO - lag(TPO) over (partition by Product_category order by Year, Month))*100/lag(TPO) over (partition by Product_category order by Month)),2) as Order_growth,
       round(Total_cost,2) as Total_cost,
       round(TPV - Total_cost,2) as Total_profit
  from input
  order by Year, Month)
