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

---Q3: 
---Đối với cả hai nhóm khách hàng nam và nữ, đều có độ tuổi khách hàng nhỏ nhất là 12 tuổi và lớn nhất là 70 
--- Ở nhóm khách hàng có giới tính là nữ, có 48 người có độ tuổi thấp nhất là 12 và có 58 người có độ tuổi cao nhất là 70 
--- Ở nhóm khách hàng có giới tính là , có 57 người có độ tuổi thấp nhất là 12 và có 50 người có độ tuổi cao nhất là 70 

with complete_order as 
(select distinct user_id, first_name, last_name, x.gender, age,
        extract(year from y.created_at) as nam, 
        extract (month from y.created_at) as thang, 
        format_date('%m-%E4Y', y.created_at) as complete_date, 
        from bigquery-public-data.thelook_ecommerce.orders y
left join bigquery-public-data.thelook_ecommerce.users as x on user_id = x.id
where status = 'Complete' and ((extract(year from y.created_at) < 2022) or (extract(year from y.created_at)= 2022 and extract(month from y.created_at) <4)))

--- đổi từ * thành "gender, tags, count(*)" add thêm "group by tags, gender" sau cùng khi muốn tìm số lượng của KH có độ tuổi cao nhất và thấp nhất ở mỗi giới tính 
select * from (select first_name, last_name, gender, age,
  case 
  when age in (select min(age) over (partition by gender) from complete_order) then 'youngest'
  when age in (select max(age) over (partition by gender) from complete_order) then 'oldest'
  end as tags
  from complete_order)
where tags is not null
order by gender, age
