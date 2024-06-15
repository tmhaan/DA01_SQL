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

--Ex7: user-activity-for-the-past-30-days.
select activity_date as day,
    count(distinct user_id) as active_users
from Activity
where activity_date between '2019-06-28' and '2019-07-27'
group by activity_date
having count(activity_type) > 0

--Ex8: number-of-hires-during-specific-time-period.
select extract(month from joining_date) as month,
    count(id)
from employees
where extract( year from joining_date) = '2022' and extract(month from joining_date) between '1' and '7'
group by month

--Ex9: positions-of-letter-a.
select 
    position ('a' in first_name) as position_a
from worker
where first_name = 'Amitah'

--Ex10: macedonian-vintages.
select title, 
    substring(title, (position (' ' in title) + 1), 4)::numeric as year
from winemag_p2
where country = 'Macedonia'
