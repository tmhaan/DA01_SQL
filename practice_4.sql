--Ex1: datalemur-laptop-mobile-viewership.
SELECT 
  count(case 
  when device_type = 'laptop' then 1 end) 
  as laptop_views, 
  
  count(case when device_type in ('phone','tablet') then 1 end) 
  as mobile_views 
FROM viewership;

--Ex2: datalemur-triangle-judgement.
SELECT
    *,
    IF(x + y > z AND x + z > y AND y + z > x, 'Yes', 'No') AS triangle
FROM Triangle;

--Ex3: datalemur-uncategorized-calls-percentage.
SELECT 
  round(((count_null*100)/ total),1) as uncategorised_call_pct
from (
  select 
  sum((case when call_category IS NULL or call_category = 'n/a' then 1 end)) as count_null,
  count(*)::numeric as total
  from callers
)A

--Ex4: datalemur-find-customer-referee.
select name from Customer
    where not referee_id = 2 or referee_id is null;

--Ex5: stratascratch the-number-of-survivors.
select survived,
    count(case when pclass = 1 then 1 end) as first_class,
    count(case when pclass = 2 then 1 end) as second_class,
    count(case when pclass = 3 then 1 end) as third_class
from titanic
group by survived;
