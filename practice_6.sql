--Ex1: datalemur-duplicate-job-listings.
select count(company_id) as duplicate_companies from (select 
  company_id from job_listings
  group by company_id, title
  having count(company_id) > 1 and count(title)>1)A

--ex2: datalemur-highest-grossing.
With category_rank as 
(select category, product, 
  sum(spend) as total_spend, 
  row_number () OVER (PARTITION BY category  ORDER BY  sum(spend) DESC)  AS  row_num 
  from product_spend
  where transaction_date between '01-01-2022' and '12-31-2022'
  group by category, product)
SELECT category, product, total_spend from category_rank 
  where row_num <= 2

--ex3: datalemur-frequent-callers.
SELECT count(*) as policy_holder_count from 
  (select policy_holder_id as a FROM callers
  group by policy_holder_id
  having count(case_id) >= 3)A

--ex4: datalemur-page-with-no-likes.
SELECT p.page_id FROM pages p
FULL OUTER JOIN page_likes pl on p.page_id = pl.page_id
group by p.page_id
having count(pl.liked_date) = 0

--ex5: datalemur-user-retention.
With a as
(SELECT distinct user_id as user_id FROM user_actions
  where event_date between '06-01-2022' and '06-30-2022'),
b as 
(select extract(month from event_date) as month,
case when user_id in (select user_id from a) then user_id end as user_id
from user_actions
where event_date between '07-01-2022' and '07-31-2022')
 
select month, count(distinct user_id) as monthly_active_users from b
group by month
  
--ex6: leetcode-monthly-transactions.
select 
    date_format(trans_date, '%Y-%m') as month,
    country, 
    count(id) as trans_count,
    sum(case when state = 'approved' then 1 else 0 end) as approved_count,
    sum(amount) as trans_total_amount,
    sum(case when state = 'approved' then amount else 0 end) as approved_total_amount
from Transactions
group by country, month

--ex7: leetcode-product-sales-analysis.

With a as
(select product_id, year, quantity, price,
    row_number () over (partition by product_id order by year) as year_num
    from sales 
),
c as
(select b.product_id, a.year as first_year, a.quantity, a.price from Product as b
left join a on b.product_id = a.product_id
where a.year_num = 1)

Select distinct Sales.product_id, c.first_year, c.quantity, c. price from sales
left join c on Sales.product_id = c.product_id
--ex8: leetcode-customers-who-bought-all-product+/mns.
--ex9: leetcode-employees-whose-manager-left-thenb -company.
--ex10: leetcode-primary-department-for-each-employee.
--ex11: leetcode-movie-rating.
--ex12: leetcode-who-has-the-most-friends.
