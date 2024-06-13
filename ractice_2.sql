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

