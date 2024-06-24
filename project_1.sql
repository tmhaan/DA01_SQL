-- question 1,2
alter table sales_dataset_rfm_prj
alter column ordernumber type integer using ordernumber::numeric,
alter column ordernumber set not null,
alter column quantityordered type integer using quantityordered::numeric,
alter column quantityordered set not null,
alter column priceeach type decimal using priceeach::numeric,
alter column priceeach set not null,
alter column orderlinenumber type integer using orderlinenumber::numeric,
alter column orderlinenumber set not null,
alter column sales type decimal using sales::numeric,
alter column sales set not null,
alter column msrp type integer using msrp::numeric,
alter column orderdate type date using to_date(orderdate, 'MM/DD/YYYY')
alter column orderdate set not null

-- question 3
alter table sales_dataset_rfm_prj
add column contactlastname varchar (20), 
add column contactfirstname varchar (20);

UPDATE sales_dataset_rfm_prj
SET contactlastname = split_part(contactfullname, '-', 2),
    contactfirstname = split_part(contactfullname, '-', 1);

--question 4 
alter table sales_dataset_rfm_prj
add column qtr_id int,
add column month_id int,
add column year_id int;

update sales_dataset_rfm_prj
set qtr_id = extract(quarter from orderdate),
	month_id = extract(month from orderdate),
	year_id = extract(year from orderdate);

--question 5
--- calculate quartile percentile
WITH quartiles AS (
    SELECT 
        percentile_cont(0.25) WITHIN GROUP (ORDER BY quantityordered) AS q1,
        percentile_cont(0.75) WITHIN GROUP (ORDER BY quantityordered) AS q3
    FROM sales_dataset_rfm_prj
),

--- calculate the iqr which is q3 - q1 
iqr_calc AS (
    SELECT q1, q3, q3 - q1 AS iqr
    FROM quartiles
)
  
SELECT 
    s.*,
    b.lower_bound,
    b.upper_bound,
    CASE 
        WHEN s.quantityordered < b.lower_bound THEN 'Lower Outlier'
        WHEN s.quantityordered > b.upper_bound THEN 'Upper Outlier'
        ELSE 'Non-Outlier'
    END AS outlier_status
FROM sales_dataset_rfm_prj s, 
  
--- create new table that calculate bounds using iqr in table quartiles
	(select *, 
	q1 - 1.5 * iqr AS lower_bound,
	q3 + 1.5 * iqr AS upper_bound
	from iqr_calc)b 
WHERE s.quantityordered < b.lower_bound OR s.quantityordered > b.upper_bound;

-- question 6
alter table sales_dataset_rfm_prj
rename to sales_dataset_rfm_prj_clean
