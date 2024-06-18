--ex1: hackerrank-average-population-of-each-continent.
SELECT country.continent, 
    FLOOR(AVG(city.population)) 
FROM city, country
WHERE city.countrycode = country.code
GROUP BY country.continent;

--ex2: datalemur-signup-confirmation-rate.
SELECT round(confirmed_count,2) from (
  select
  (sum(case when texts.signup_action = 'Confirmed' then 1 else 0 end))/(select count(*) from emails)::decimal as confirmed_count
  FROM emails
  left join texts on emails.email_id = texts.email_id
)A

--ex3: datalemur-time-spent-snaps.
select age_bucket,
  round(((time_sending*100.00)/(total_spending)),2) as send_perc,
  round(((time_opening*100.00)/(total_spending)),2) as open_perc
from (
SELECT age.age_bucket,
  sum(case when activity_type = 'send' then act.time_spent end) as time_sending,
  sum(case when activity_type = 'open' then act.time_spent end) as time_opening,
  sum(act.time_spent) as total_spending
from age_breakdown as age
left join activities as act on act.user_id = age.user_id
where act.activity_type <> 'chat'
group by age_bucket
)A
order by age_bucket

--ex4: datalemur-supercloud-customer.
SELECT c.customer_id
FROM customer_contracts as c
left join products as p on c.product_id = p.product_id
group by c.customer_id
having count(distinct p.product_category) = 3

--ex5: leetcode-the-number-of-employees-which-report-to-each-employee.
select employee_id, name, reports_count, round(avg_age,0) as average_age
 from (
    select 
    distinct reports_to as id,
    count(employee_id) as reports_count,
    avg(age) as avg_age
    from Employees
    group by reports_to
)A
right join Employees on id = Employees.employee_id
where id is not null
order by employee_id

--ex6: leetcode-list-the-products-ordered-in-a-period.
select product_name, 
    sum(unit) as unit
from Products as p
right join Orders o on p.product_id = o.product_id
where order_date between '2020-02-01' and '2020-02-29'
group by product_name
having sum(unit) >= 100

--ex7: leetcode-sql-page-with-no-likes.
SELECT p.page_id FROM page_likes as pl
right join pages as p on pl.page_id = p.page_id
group by p.page_id
having(count(pl.user_id)) = 0
order by p.page_id

-- Mid-term Exam Q1
-- Replacement_cost thap nhat la 9.99
select distinct(replacement_cost) from film
order by replacement_cost

-- Mid-term Exam Q2
-- Co 514 phim co replacement_cost thap 9.99-19.99
select 
	sum(case when replacement_cost between 9.99 and 19.99 then 1 end) as low,
	sum(case when replacement_cost between 20.00 and 24.99 then 1 end) as medium,
	sum(case when replacement_cost between 25.00 and 29.99 then 1 end) as high
	from film

-- Mid-term Exam Q3
-- phim co do dai dai nhat co 184 phut thuoc the loai sport
select f.title, f.length, c.name as category_name from film f
left join film_category fc on f.film_id = fc.film_id
left join category as c on fc.category_id = c.category_id
where c.name = 'Drama' or c.name = 'Sports'
order by f.length desc

--Mid-term Exam Q4
--The loai co nhieu phim nhat la sport, co 74 phim
select c.name as category, 
	count(f.title) as so_luong_film
	from film f
left join film_category fc on f.film_id = fc.film_id
left join category as c on fc.category_id = c.category_id
group by c.name
order by so_luong_film

--Mid-term Exam Q5
--Susan Davis la dien vien dong nhieu phim nhat - 54 phim
select a.last_name, a.first_name, 
	count(f.title) as so_luong_film
	from film f
inner join film_actor fa on f.film_id = fa.film_id
inner join actor as a on fa.actor_id = a.actor_id
group by a.last_name, a.first_name
order by so_luong_film

--Mid-term Exam Q6
-- Co 4 bo phim khong co lien quan gi voi khach hang
select a.address from address a
left join customer c on a.address_id = c.address_id
where c.customer_id is null

--Mid-term Exam Q7
-- Cape Coral co tong doanh thu cao nhat voi 221.55
select  city.city as city,
	sum(p.amount) as payment
from payment p
left join customer c on p.customer_id = c.customer_id
left join address a on c.address_id = a.address_id  
left join city on a.city_id = city.city_id
group by city
order by payment desc

--Mid-term Exam Q8
-- thanh pho co doanh thu thap nhat la Tallahassee, United States - 50.85
-- thanh pho co doanh thu cao nhat la Cape Coral, United States - 221.55
select city.city || ', ' || country.country as name,
	sum(p.amount) as payment
from payment p
left join customer c on p.customer_id = c.customer_id
left join address a on c.address_id = a.address_id  
left join city on a.city_id = city.city_id
left join country on city.country_id = country.country_id
group by city.city, country.country
order by payment desc
