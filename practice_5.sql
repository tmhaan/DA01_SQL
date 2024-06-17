--ex1: hackerrank-average-population-of-each-continent.
SELECT country.continent, 
    FLOOR(AVG(city.population)) 
FROM city, country
WHERE city.countrycode = country.code
GROUP BY country.continent;

--ex2: datalemur-signup-confirmation-rate.
SELECT round(confirmed_count,2) from (
  select
  (sum(case when texts.signup_action = 'Confirmed' then 1 else 0 end))/(select count(*) from emails)::decimal as confirmed_count
  FROM emails
  left join texts on emails.email_id = texts.email_id
)A

--ex3: datalemur-time-spent-snaps.
select age_bucket,
  round(((time_sending*100.00)/(total_spending)),2) as send_perc,
  round(((time_opening*100.00)/(total_spending)),2) as open_perc
from (
SELECT age.age_bucket,
  sum(case when activity_type = 'send' then act.time_spent end) as time_sending,
  sum(case when activity_type = 'open' then act.time_spent end) as time_opening,
  sum(act.time_spent) as total_spending
from age_breakdown as age
left join activities as act on act.user_id = age.user_id
where act.activity_type <> 'chat'
group by age_bucket
)A
order by age_bucket

--ex4: datalemur-supercloud-customer.

--ex5: leetcode-the-number-of-employees-which-report-to-each-employee.

--ex6: leetcode-list-the-products-ordered-in-a-period.

--ex7: leetcode-sql-page-with-no-likes.
