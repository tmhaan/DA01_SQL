--Ex1: datalemur-yoy-growth-rate.
With a as
(select 
extract(year from transaction_date) as yr,
product_id,
sum(spend) as curr_year_spend
from user_transactions
group by yr, product_id
order by yr)

select yr, product_id, curr_year_spend, prev_year_spend, 
round(((curr_year_spend - prev_year_spend)*100.00 / prev_year_spend),2) as yoy_rate
from (select 
a.yr, a.product_id, curr_year_spend, 
lag(curr_year_spend) over(partition by a.product_id order by yr) as prev_year_spend
from user_transactions as b 
right join a on a.product_id = b.product_id
group by yr, a.product_id, curr_year_spend
order by a.product_id, a.yr)x

--ex2: datalemur-card-launch-success.
--ex3: datalemur-third-transaction.
--ex4: datalemur-histogram-users-purchases.
--ex5: datalemur-rolling-average-tweets.
--ex6: datalemur-repeated-payments.
--ex7: datalemur-highest-grossing.
--ex8: datalemur-top-fans-rank.
