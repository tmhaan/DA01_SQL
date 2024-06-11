--Ex1: hackerank-revising-the-select-query. 
select NAME from CITY
    where COUNTRYCODE = 'USA' and POPULATION >= 120000;

--Ex2: hackerank-japanese-cities-attributes. 
select * from CITY
    where COUNTRYCODE = 'JPN';

--Ex3: hackerank-weather-observation-station-1. 
select CITY, STATE from STATION;

--Ex4: hackerank-weather-observation-station-6. 
select distinct CITY from STATION
    where CITY like 'a%' or CITY like 'e%' or CITY like 'i%' or CITY like 'o%' or CITY like  'u%';

--Ex5: hackerank-weather-observation-station-7. 
select distinct CITY from STATION
    where CITY like '%a' or CITY like '%e' or CITY like '%i' or CITY like '%o' or CITY like  '%u';

--Ex6: hackerank-weather-observation-station-9. 
select distinct CITY from STATION
    where not (CITY like 'a%' or CITY like 'e%' or CITY like 'i%' or CITY like 'o%' or CITY like  'u%');

--Ex7: hackerank-name-of-employees. 
select name from Employee
    order by name;

--Ex8: hackerank-salary-of-employees. 
select name from Employee
    where salary > 2000 and months < 10
    order by employee_id;

--Ex9: leetcode-recyclable-and-low-fat-products. 
select product_id from Products
    where low_fats = 'Y' and recyclable = 'Y';

--Ex10: leetcode-find-customer-referee. 
select name from Customer
    where not referee_id = 2 or referee_id is null;

--Ex11: leetcode-big-countries. 
select name, population, area from World 
    where area >= 3000000 or population >= 25000000;

--Ex12: leetcode-article-views. 
select distinct author_id as id from Views 
    where viewer_id = author_id
    order by id;

--Ex13: datalemur-tesla-unfinished-part. 
SELECT part, assembly_step FROM parts_assembly
  where assembly_step >= 1 and finish_date is NULL;

--Ex14: datalemur-lyft-driver-wages. 
select * from lyft_drivers
 where yearly_salary <= 30000 or yearly_salary >= 70000;

--Ex15: datalemur-find-the-advertising-channel.
select advertising_channel from uber_advertising
    where year = 2019 and money_spent > 100000;


