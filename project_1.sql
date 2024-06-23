alter table sales_dataset_rfm_prj
alter column ordernumber type integer using ordernumber::numeric,
alter column quantityordered type integer using quantityordered::numeric,
alter column priceeach type decimal using priceeach::numeric,
alter column orderlinenumber type integer using orderlinenumber::numeric,
alter column sales type decimal using sales::numeric,
alter column msrp type integer using msrp::numeric, 
alter column orderdate type date using to_date(orderdate, 'MM/DD/YYYY')
