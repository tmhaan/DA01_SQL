--Ex1: hackerrank-weather-observation-station-3.
select distinct CITY from STATION
    where ID % 2 = 0;

--Ex2: hackerrank-weather-observation-station-4.
select count(CITY) - count(distinct CITY) from STATION;

--Ex3: hackerrank-the-blunder.
select ceiling((avg(salary))-AVG(replace(Salary, 0, ''))) from EMPLOYEES;

--Ex4: datalemur-alibaba-compressed-mean.
SELECT 
    round(
    ((SUM(item_count * order_occurrences))/(SUM(order_occurrences)))::numeric
    ,1) 
FROM items_per_order;

--Ex5: datalemur-matching-skills.
SELECT candidate_id FROM candidates 
  Where skill in ('Python','Tableau','PostgreSQL') 
  GROUP BY candidate_id 
  HAVING COUNT(skill) = 3;

---Ex6: datalemur-verage-post-hiatus-1.
SELECT * FROM ( 
  SELECT user_id,
    EXTRACT(DAY FROM MAX(post_date)- MIN(post_date)) AS days_between 
  FROM posts 
    where EXTRACT(YEAR FROM post_date)='2021' 
    GROUP BY user_id )A 
WHERE days_between>0


--Ex7: datalemur-cards-issued-difference.
SELECT * from (
  select card_name,
    (max(issued_amount) - min(issued_amount)) as difference
  from monthly_cards_issued
  GROUP BY card_name )A
order by difference DESC

--Ex8: datalemur-non-profitable-drugs.
Select manufacturer, drug_count, ABS(revenue-costs) as total_loss from (
  select manufacturer,
  count(drug) as drug_count,
  sum(total_sales) as revenue,
  sum(cogs) as costs
  from pharmacy_sales
  where total_sales < cogs
  GROUP BY manufacturer
)A
order by total_loss desc

--Ex9: leetcode-not-boring-movies.
select * from Cinema
    where id % 2 = 1 and description != 'boring'
    order by rating desc;

--Ex10: leetcode-number-of-unique-subject.
select teacher_id,
    count(distinct subject_id) as cnt
    from Teacher
group by teacher_id

--Ex11: leetcode-find-followers-count.
Select user_id,
    count(follower_id) as followers_count
from Followers 
group by user_id
order by user_id

--Ex12: leetcode-classes-more-than-5-students.
select class from Courses
group by class
having count(student) >=5
