--Ex1: leetcode-mmediate-food-delivery.
with a as 
    (select delivery_id, customer_id, order_date, customer_pref_delivery_date as x,
        row_number () over (partition by customer_id order by order_date) as row_num
        from Delivery)
select round(y,2) as immediate_percentage from (select 
    (sum(case when delivery.order_date = x then 1 else 0 end)*100/count(*)) as y
    from delivery
    left join a on delivery.delivery_id = a.delivery_id
    where row_num = 1)A

--ex2: leetcode-game-play-analysis.
SELECT
  ROUND(COUNT(DISTINCT player_id) / (SELECT COUNT(DISTINCT player_id) FROM Activity), 2) AS fraction
FROM Activity
WHERE (player_id, DATE_SUB(event_date, INTERVAL 1 DAY))
  IN (SELECT player_id, MIN(event_date) AS first_login FROM Activity GROUP BY player_id)

--ex3: leetcode-exchange-seats.
with a as 
(select student, id - 1 as new_id from Seat 
where id%2 = 0
union
select student, 
case when odd_id = 1 then id else id + 1 end as new_id from (
    Select student, id, 
    row_number() over (order by id desc) as odd_id 
    from Seat 
    where id % 2 = 1)A)

select new_id as id, student 
    from a 
order by id

--ex4: leetcode-restaurant-growth.
With a as 
(select visited_on, sum(amount) as total_amount from Customer 
group by visited_on)

SELECT * from (select 
        visited_on,
         SUM(total_amount) OVER (ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS amount,
         ROUND(AVG(total_amount) OVER (ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS average_amount
    FROM a)A
    where visited_on >= (select min(visited_on) + 6 from a)
    order by visited_on

--ex5: leetcode-investments-in-2016.
with a as (select pid, tiv_2015 from Insurance 
group by tiv_2015
having count(tiv_2015) > 1)

select round(sum(tiv_2016),2) as tiv_2016 from 
(select pid, tiv_2015, tiv_2016, lat, lon  from Insurance 
group by lat, lon 
having count(lat) = 1)A
where tiv_2015 in (select tiv_2015 from a)

--ex6: leetcode-department-top-three-salaries.
With a as
(select id, 
dense_rank() over (partition by departmentId order by salary desc) as ranking 
from Employee)

select Department.name as Department, Employee.name as Employee, salary as Salary 
from Employee 
left join Department on Employee.departmentId = Department.id
left join a on Employee.id = a.id
where ranking <= 3

--ex7: leetcode-last-person-to-fit-in-the-bus.
select distinct first_value(person_name) over (order by turn desc) as person_name from 
(select person_name, weight, turn,
sum(weight) over (order by turn rows between unbounded preceding and current row) as total_weight
from Queue)A
where total_weight <= 1000

--ex8: leetcode-product-price-at-a-given-date.
