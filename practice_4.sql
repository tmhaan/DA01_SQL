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
select *,
  round(((count_null*100)/total),1) as uncategorised_call_pct
from (
  select
  count(*) as total,
  count(case
    when call_category = 'n/a' or call_category = 'NULL' then 1
  end) as count_null
  FROM callers
)A 

--Ex4: datalemur-find-customer-referee.
--Ex5: stratascratch the-number-of-survivors.
