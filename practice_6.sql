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
SELECT product_id, year AS first_year, quantity, price 
FROM sales
WHERE (product_id, year) IN (
    SELECT product_id, MIN(year) 
    FROM sales 
    GROUP BY product_id
);

--ex8: leetcode-customers-who-bought-all-product+/mns.
select customer_id from Customer 
group by customer_id
having count(distinct product_key) = (select count(product_key) from Product)

--ex9: leetcode-employees-whose-manager-left-thenb -company.
select employee_id from Employees
where salary < 30000 and manager_id not in (select employee_id from employees)
order by employee_id

--ex10: leetcode-primary-department-for-each-employee.
select count(company_id) as duplicate_companies from (select 
  company_id from job_listings
  group by company_id, title
  having count(company_id) > 1 and count(title)>1)A
  
--ex11: leetcode-movie-rating.
SELECT user_name AS results FROM
(
SELECT a.name AS user_name, COUNT(*) AS counts FROM MovieRating AS b
    JOIN Users AS a
    on a.user_id = b.user_id
    GROUP BY b.user_id
    ORDER BY counts DESC, user_name ASC LIMIT 1
) first_query
UNION ALL
SELECT movie_name AS results FROM
(
SELECT c.title AS movie_name, AVG(d.rating) AS rate FROM MovieRating AS d
    JOIN Movies AS c
    on c.movie_id = d.movie_id
    WHERE substr(d.created_at, 1, 7) = '2020-02'
    GROUP BY d.movie_id
    ORDER BY rate DESC, movie_name ASC LIMIT 1
) second_query;

--ex12: leetcode-who-has-the-most-friends.
select id, count(*) num from
(
    (select requester_id id from RequestAccepted)
    union all
    (select accepter_id id from RequestAccepted)
) as A
group by id order by num desc limit 1;
