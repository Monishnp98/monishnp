--AbY - ankit bansal Youtube
--Linked in questions

-- 1. Find the top 3 cities with the highest sales per month. 
-- (sales_table):
-- | sale_id | city   | sale_date | amount | 
-- |---------|----------|------------|--------
-- | 1    | Mumbai  | 2024-01-10 | 5000 
-- | 2    | Delhi  | 2024-01-15 | 7000 
-- | 3    | Bangalore| 2024-01-20 | 10000
-- | 4    | Chennai | 2024-02-05 | 3000 
-- | 5    | Mumbai  | 2024-02-08 | 9000 

WITH cte1 AS (
    SELECT 
        city, 
        DATEPART('MONTH', sale_date) AS month, 
        SUM(amount) AS month_sales
    FROM sales_table 
    GROUP BY city, DATEPART('MONTH', sale_date)),

cte2 AS (
    SELECT 
        city, 
        month, 
        month_sales,
        DENSE_RANK() OVER (PARTITION BY month ORDER BY month_sales DESC) AS drnk
    FROM cte1)

SELECT city, month, month_sales
FROM cte2
WHERE drnk <= 3
ORDER BY month, month_sales DESC;




--find the no gold medals per swimmer, for swimmer who won only gold medals
with gold as (select GOLD as swimmer_name, count(GOLD) as no_golds
from events
group by GOLD)

select * from gold 
where swimmer_name not in 
(select SILVER from events union all select BRONZE from events) 



/*1) The marketing department wishes to classify its efforts based on the total number of units sold for each product.
You have been tasked with calculating the total number of units sold for each product and categorizing ad performance based on the following criteria for items sold*/

select  product_id , sum(quantity) as summed_qty,
case 	
		when sum(quantity) >= 30 then 'Outstanding'
		when sum(quantity) >= 20  and sum(quantity) < 30 then 'Satisfactory'
		when sum(quantity) >= 10  and sum(quantity) < 20 then 'Unsatisfactory'
		when sum(quantity) >= 1  and  sum(quantity) < 10 then 'Poor'
		else 'invalid' end as criteria 
from marketing_campaign
group by product_id

    /*
    NOTE : You had the grouped and used cte for "case when", when you solved it first time. 
    No need yo have a seperate cte for CASE WHEN. you can validate CASE WHEN with "sum(quantity)" instead of using "summed_qty"
    */


--LINK - https://lnkd.in/gWZ_WD8m
/*2)A table named “famous” has two columns called user id and follower id. 
It represents each user ID has a particular follower ID. These follower IDs are also users of hashtag#Facebook / hashtag#Meta.
Then, find the famous percentage of each user. Famous Percentage = number of followers a user has / total number of users on the platform. */

select * from famous 

with cte1 as(
select distinct(user_id)
from famous
union
select distinct(follower_id)
from famous)

select user_id , (count(*) * 100.0/ (select count(*) from cte1)) as famous_percentage
from famous 
group by user_id
order by famous_percentage desc	


--LINK - https://lnkd.in/gW63hRvU
/*3) Given a table 'sf_transactions' of purchases by date, calculate the month-over-month percentage change in revenue. 
The output should include the year-month date (YYYY-MM) and percentage change, 
rounded to the 2nd decimal point, and sorted from the beginning of the year to the end of the year. 
The percentage change column will be populated from the 2nd month forward and calculated as ((this month’s revenue — last month’s revenue) / last month’s revenue)*100.
*/

with cte1 as(
select FORMAT(created_at,'yyyy-MM') as yr_mnth, sum(value) as current_month_sale
from sf_transactions
group by FORMAT(created_at,'yyyy-MM'))

select yr_mnth , round(((current_month_sale - prv_mnth_sale)/ cast(prv_mnth_sale as float)) * 100,2) as mom_revenue_per from 
(select * , lag(current_month_sale) over(order by yr_mnth) as prv_mnth_sale
from cte1) as sq


-- https://lnkd.in/gXPMAD48
-- 5)Given a list of projects and employees mapped to each project, calculate by the amount of project budget allocated to each employee. 
-- The output should include the project title and the project budget rounded to the closest integer. Order your list by projects with the highest budget per employee first.
select * from ms_projects
select * from  ms_emp_projects

select p.id, p.title, (p.budget)/count(*) as emp_portion
from ms_projects p
inner join ms_emp_projects mp
on p.id = mp.project_id
group by p.id, p.title, p.budget 
--each project will have only one total budget, So we can have it in group by
order by emp_portion desc 


