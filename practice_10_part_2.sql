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
       TPO,
       round(((TPV - lag(TPV) over (partition by Product_category order by Year, Month))*100/lag(TPV) over (partition by Product_category order by Month)),2) as Revenue_growth,
       round(((TPO - lag(TPO) over (partition by Product_category order by Year, Month))*100/lag(TPO) over (partition by Product_category order by Month)),2) as Order_growth,
       round(Total_cost,2) as Total_cost,
       round(TPV - Total_cost,2) as Total_profit
  from input
  order by Year, Month)



-- Step 1: Get the first order date for each user
WITH a as (
     select user_id, date(created_at) as tg
     from bigquery-public-data.thelook_ecommerce.orders
),

b as (
     select user_id, min(tg) as first_order_date,
     date_trunc(min(tg), month) as cohort_month
     from a
     group by user_id
),


-- Step 3: Calculate the number of users who return in subsequent periods
retention AS (
  SELECT b.cohort_month,
    Date_trunc(o.created_at,month) AS order_month,
    COUNT(DISTINCT o.user_id) AS active_users
  FROM b
  JOIN bigquery-public-data.thelook_ecommerce.orders o ON b.user_id = o.user_id
  GROUP BY b.cohort_month, order_month
  ORDER BY cohort_month, order_month
)

-- Step 4: Pivot the results to create a retention table
SELECT
  cohort_month,
  SUM(CASE WHEN order_month = cohort_month THEN active_users ELSE 0 END) AS month_0,
  SUM(CASE WHEN order_month in (select DATE_ADD(cohort_month, INTERVAL 1 MONTH) from retention) THEN active_users ELSE 0 END) AS month_1,
  SUM(CASE WHEN order_month in (select DATE_ADD(cohort_month, INTERVAL 2 MONTH) from retention) THEN active_users ELSE 0 END) AS month_2,
  SUM(CASE WHEN order_month = DATE_ADD(cohort_month, INTERVAL 3 MONTH) THEN active_users ELSE 0 END) AS month_3
FROM
  retention
GROUP BY
  cohort_month
ORDER BY
  cohort_month;
