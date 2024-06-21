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
    where visited_on >= min(visited_on) + 6
    order by visited_on

--ex5: leetcode-investments-in-2016.

--ex6: leetcode-department-top-three-salaries.

--ex7: leetcode-last-person-to-fit-in-the-bus.
--ex8: leetcode-product-price-at-a-given-date.
