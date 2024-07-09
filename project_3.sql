---Q1
select productline, year_id, dealsize, sum(sales) from sales_dataset_rfm_prj_clean
	group by productline, year_id, dealsize
	order by productline, year_id, dealsize

---Q2
