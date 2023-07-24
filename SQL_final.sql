drop database fmcg;
create database fmcg;

drop table if exists sales;

create table sales(Storemanager varchar(100), Brandname varchar(50), City varchar(50), Date date, Fiscalyear int, Mealtype varchar(50), Receiptno bigint, 
Region varchar(50), Salestype varchar(50), State varchar(50), Storename varchar(50), Storestatus varchar(50), Netamt int);

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Sales1.csv'
into table sales
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;

select * from sales;

SHOW VARIABLES LIKE 'secure_file_priv';

show databases;
use fmcg;

drop table sales;
show tables;
rename table salesdatacleaned22062023 to salesdata;
rename table salesdata to sales;
describe sales;

alter table sales change `Store Manager` `Store_manager` text(100);
alter table sales change `Brand Name` `Brand_name` text(100);
alter table sales change `Fiscal Year` `Fiscal_year` int(100);
alter table sales change `Meal Type` `Meal_type` text(100);
alter table sales change `Receipt No` `Receipt_no` bigint(100);
alter table sales change `Sales Type` `Sales_Type` text(200);
alter table sales change `Store Name` `Store_name` text(200);
alter table sales change `Store Status` `Store_status` text(150);
alter table sales change `Net Amt` `Net_Amt` double;

-- 1. Total Sales
select Region, round(sum(Netamt),0) as Total_Sales from sales
group by Region;

-- 2. Storewise Sales
select Storename, round(sum(Netamt),0) as Total_sales from sales
group by Storename;

-- 3. Sales Growth
select Region, Fiscalyear, sum(Netamt)/(Select sum(Netamt) from sales) * 100 as 'Growth' from sales
group by Region, Fiscalyear;

-- 4. Daily Sales Trend
SELECT
    SUM(CASE WHEN Fiscalyear = 2017 THEN Netamt ELSE 0 END) AS 2017_sales,
    SUM(CASE WHEN Fiscalyear = 2018 THEN Netamt ELSE 0 END) AS 2018_sales
FROM
    sales
WHERE
    (Date >= '2017-01-01' AND Date <= '2017-12-31')
    OR
    (Date >= '2018-01-01' AND Date <= '2018-12-31');
     

-- 5. Brandwise Sales
select Brandname, round(sum(Netamt),0) as Total_Sales from sales
group by Brandname;


-- 6. AM wise Sales
select Storemanager, round(sum(Netamt),0) as Total_Sales from sales
group by Storemanager;

-- 7. Sales Comparison
SELECT
    Fiscalyear,
    StoreManager,
    SUM(CASE WHEN Fiscalyear = 2016 THEN `Netamt` ELSE 0 END) AS Sales_2016,
    SUM(CASE WHEN Fiscalyear = 2017 THEN `Netamt` ELSE 0 END) AS Sales_2017,
    SUM(CASE WHEN Fiscalyear = 2018 THEN `Netamt` ELSE 0 END) AS Sales_2018,
    SUM(`Netamt`) AS Total_Sales
FROM
    sales
WHERE
    Fiscalyear IN (2016, 2017, 2018)
GROUP BY
    Fiscalyear, StoreManager
ORDER BY
    Fiscalyear, StoreManager;


-- 8. Productwise sales
select `Mealtype`, sum(`Netamt`) from sales
group by `Mealtype`;

