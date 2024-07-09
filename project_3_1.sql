---Q1
select productline, year_id, dealsize, sum(sales) from sales_dataset_rfm_prj_clean
	group by productline, year_id, dealsize
	order by productline, year_id, dealsize

---Q2
--- chỗ này em để thêm năm vào cho dễ nhận biết là tháng đó ở năm nào 
with a as  (
	select year_id, month_id,
	sum(sales) revenue, 
	count(distinct ordernumber) order_number
	from sales_dataset_rfm_prj_clean
	group by year_id, month_id
)

select year_id, month_id, revenue, order_number from (
	select *, row_number() over (partition by year_id order by revenue desc) as ranking from a
)A
where ranking = 1

---Q3: 
with a as 
	(select year_id, month_id, productline, 
		sum(sales) as revenue, 
		count(distinct ordernumber) as order_number
from sales_dataset_rfm_prj_clean
where month_id = 11 
group by year_id, month_id, productline)

select year_id, month_id, productline,  from (
	select *, 
	dense_rank() over (partition by year_id,month_id order by revenue desc) as ranking
	from a)
where ranking = 1

---Q4
with a as 
	(select year_id, productline, 
		sum(sales) as revenue
from sales_dataset_rfm_prj_clean
group by year_id, productline)

select year_id, productline, revenue, dense_rank() over (order by revenue desc) as rank
 from (
	select *, 
	dense_rank() over (partition by year_id order by revenue desc) as ranking
	from a)
where ranking = 1
group by year_id, productline, revenue

---Q5
---Vì KH đc xếp vào nhóm Champions đều có điểm cao 4/5 trong cả 3 phân khúc điểm R - F - M, nên những KH có trong phân khúc này đều đc đánh giá là KH tốt nhất. 
--- => Young Leslie là tốt nhất
with rfm_calculation as 
(select contactfullname, contactfirstname, contactlastname,
current_date - max(orderdate) as R, 
count(distinct ordernumber) as F,
sum(sales) as M_
from sales_dataset_rfm_prj_clean
group by contactfullname, contactfirstname, contactlastname),

ntile_cal as (select contactfullname, contactfirstname, contactlastname,
	Rtile || Ftile || Mtile as rfm
from 
	(select contactfullname, contactfirstname, contactlastname,
	ntile(5) over (order by R desc):: text as Rtile,
	ntile(5) over (order by F desc):: text as Ftile,
	ntile(5) over (order by M_ desc)::text as Mtile
from rfm_calculation))

select contactfirstname, contactlastname from ntile_cal 
left join segment_score a on ntile_cal.rfm = a.scores
where segment = 'Champions'
