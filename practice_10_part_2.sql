--- Creating the required dataset as metrics
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


---creating the metrics for customer retention cohort chart 
--- sau khi phân tích bảng Cohort, ta có thể nhận ra được nhiều vấn đề mà công ty đang gặp phải: 
--- mặc dù có số lượng khách hàng mới càng ngày càng tăng, tuy nhiên tỷ lệ quay lại của những khách hàng này trong 3 tháng lại rất thấp
--- điều này cho thấy là công ty còn yếu trong việc duy trì sự tương tác của khách hàng, kh thể tạo đc loyalty in customer
--- vì vậy, công ty cần phải mở những chiến dịch marketing, promotion, discount khuyến khích những khách hàng cũ quay lại với cửa hàng
--- ngoài ra, công ty cũng cần liên tục phân tích cohort định kỳ đều đặn (hàng tháng, hàng tuần, hàng kỳ) để ko bị lost information
  
with a as (
     select user_id, date(created_at) as tg
     from bigquery-public-data.thelook_ecommerce.orders
     where status = 'Complete'
),

b as (
     select user_id, min(tg) as first_order_date,
     date_trunc(min(tg), month) as cohort_month
     from a
     group by user_id
),

retention as (
  select b.cohort_month,
    date_trunc(a.tg,month) as order_month,
    count(distinct a.user_id) as active_users
  from b
  join a on b.user_id = a.user_id
  group by b.cohort_month, order_month
  order by cohort_month, order_month
)

select
  format_date('%E4Y-%m', cohort_month) as Month,
  sum(case when order_month = cohort_month then active_users else 0 end) as m0,
  sum(case when order_month = date_add(cohort_month, interval 1 MONTH) then active_users else 0 end) as m1,
  sum(case when order_month = date_add(cohort_month, interval 2 MONTH) then active_users else 0 end) as m2,
  sum(case when order_month = date_add(cohort_month, interval 3 MONTH) then active_users else 0 end) as m3
from retention
group by Month
order by Month;
