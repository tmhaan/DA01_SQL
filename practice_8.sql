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

--ex3: leetcode-exchange-seats.

--ex4: leetcode-restaurant-growth.

--ex5: leetcode-investments-in-2016.

--ex6: leetcode-department-top-three-salaries.

--ex7: leetcode-last-person-to-fit-in-the-bus.
--ex8: leetcode-product-price-at-a-given-date.
