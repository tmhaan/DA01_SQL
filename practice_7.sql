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
SELECT  * from (
  select distinct card_name,
  first_value (issued_amount) over (partition by card_name order by issue_year, issue_month) as issued_amount
  FROM monthly_cards_issued
  )A
order by issued_amount desc

--ex3: datalemur-third-transaction.
select user_id, spend, transaction_date from 
  (select user_id, spend, transaction_date,
  row_number() over (partition by user_id order by transaction_date) as row_num
  from transactions
  order by user_id, transaction_date)A
where row_num = 3

--ex4: datalemur-histogram-users-purchases.
Select transaction_date, user_id, purchase_count from (
  SELECT transaction_date, user_id, count(product_id) purchase_count
  FROM user_transactions
  group by user_id, transaction_date
  order by transaction_date DESC
  limit 3)A
order by transaction_date

--ex5: datalemur-rolling-average-tweets.
with t1 as (
    SELECT user_id , tweet_date , tweet_count
    from tweets
    order by 1 , 2 desc )

select user_id , tweet_date ,
(select round(avg(tweet_count),2) from tweets 
where user_id = t1.user_id 
  and tweet_date between t1.tweet_date - INTERVAL '2 DAY' and t1.tweet_date )
from t1
order by 1 , 2

--ex6: datalemur-repeated-payments.
WITH a as(
SELECT *,
Extract(
minute FROM transaction_timestamp - lag(transaction_timestamp) OVER(PARTITION BY merchant_id,credit_card_id,amount)) as flag 
from transactions)
select count(*) as payment_count from a
where flag < 10

--ex7: datalemur-highest-grossing.
--ex8: datalemur-top-fans-rank.
