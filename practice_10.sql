--- Q1: find total of customers, order id every month from 01/2019 to 04/2022
with a as 
(select  user_id, order_id, extract(year from created_at) as nam, 
        extract (month from created_at) as thang, 
        format_date('%m-%E4Y', created_at) as complete_date 
        from bigquery-public-data.thelook_ecommerce.orders
where status = 'Complete' and ((extract(year from created_at) < 2022) or (extract(year from created_at)= 2022 and extract(month from created_at) <4)))

select complete_date, count(distinct user_id) as total_user, count(distinct order_id) as total_order from a
group by complete_date, thang, nam
order by nam, thang

---Q2: 
--- Từ data, ta thấy là khi số lượng khách hàng tăng, giá trị đơn hàng trung bình không giảm mà duy trì ổn định hoặc tăng mặc dù khoảng thời gian này là đang dịch covid (economic downturn)
--- cho thấy chất lượng khách hàng mới cao, chiến lược bán hàng hiệu quả, sự hài lòng của khách hàng tương đối. 
with complete_order as 
(select  user_id, order_id, extract(year from created_at) as nam, 
        extract (month from created_at) as thang, 
        format_date('%m-%E4Y', created_at) as complete_date 
        from bigquery-public-data.thelook_ecommerce.orders
where status = 'Complete' and ((extract(year from created_at) < 2022) or (extract(year from created_at)= 2022 and extract(month from created_at) <4)))

select  complete_date as month, 
        count(distinct complete_order.user_id) as total_user,
        round((sum(sale_price)/count(distinct complete_order.order_id)),2) as average_order_value 
        from complete_order, bigquery-public-data.thelook_ecommerce.order_items as z
where complete_order.order_id = z.order_id
group by complete_date, thang, nam
order by nam, thang
