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

