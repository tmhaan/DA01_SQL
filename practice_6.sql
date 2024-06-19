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
--ex6: leetcode-monthly-transactions.
--ex7: leetcode-product-sales-analysis.
--ex8: leetcode-customers-who-bought-all-products.
--ex9: leetcode-employees-whose-manager-left-the-company.
--ex10: leetcode-primary-department-for-each-employee.
--ex11: leetcode-movie-rating.
--ex12: leetcode-who-has-the-most-friends.
