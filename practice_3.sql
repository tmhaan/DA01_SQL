--Ex1: hackerrank-more-than-75-marks.
select Name from STUDENTS
    where Marks > 75
    order by (right(Name,3)), ID;

--Ex2: leetcode-fix-names-in-a-table.
select user_id,
    concat(upper(left(name, 1)), lower(substring(name,2,length(name)))) as name
    from Users
order by user_id;

--Ex3: datalemur-total-drugs-sales
select manufacturer,
  '$' || left(sale, -6) || ' million' as sale
from (
  select manufacturer, sum(total_sales),
   round(sum(total_sales), -6)::varchar AS sale
  from pharmacy_sales 
  group by manufacturer
  order by sum(total_sales) desc
)A

--Ex4: avg-review-ratings.
SELECT 
  extract(month from submit_date) as mth,
  product_id product, 
  round(avg(stars), 2) avg_stars
FROM reviews
group by mth, product_id
order by mth, product_id

--Ex5: teams-power-users.
SELECT sender_id, 
  count(message_id) as count_messages
FROM messages
where extract (year from sent_date) = 2022 and extract(month from sent_date) = 8
group by sender_id
order by count(message_id) desc
limit 2

--Ex6: invalid-tweets.
select 
    tweet_id
from Tweets
where length(content) > 15


