--1- write a query to print emp name , their manager name and diffrence in their age (in days) for employees whose year of birth is before their managers year of birth

select e1.emp_name, e2.emp_name as manage_name, DATEDIFF(DAY,e1.dob,e2.dob) as age_diff_days
from employee e1
inner join employee e2
on e1.manager_id = e2.emp_id
where datepart(year,e1.dob) < datepart(year,e2.dob)

--2- write a query to find subcategories who never had any return orders in the month of november (irrespective of years)

select sub_category
from orders o
left join returns r on o.order_id=r.order_id
where DATEPART(month,order_date)=11
group by sub_category
having count(r.order_id)=0;

 /*WHY NOT
select sub_category
from orders as o
left join returns as r
on o.order_id = r.order_id
where datepart(month,o.order_date) = 11 and  r.order_id is null*/ 

--3 - orders table can have multiple rows for a particular order_id when customers buys more than 1 product in an order.
--write a query to find order ids where there is only 1 product bought by the customer.

select order_id, count(1) as cnt from orders
group by order_id
having count(order_id) = 1

--4- write a query to print manager names along with the comma separated list(order by emp salary) of all employees directly############string_agg

select  e2.emp_name as manager_name,STRING_AGG(e1.emp_name,',') as Employess
from employee e1
inner join employee e2
on e1.manager_id = e2.emp_id
group by e2.emp_name

--5- write a query to get number of business days between order_date and ship_date (exclude weekends). 
--Assume that all order date and ship date are on weekdays only##############
select order_id,order_date,ship_date ,datediff(day,order_date,ship_date)-2*datediff(week,order_date,ship_date) as no_of_business_days
from 
orders

select datediff(week,order_date,ship_date) from orders
--6- write a query to print 3 columns : category, total_sales and (total sales of returned orders)
--NOTE - CASE statement wtih aggregation and group by

select o.category , sum(o.sales) as ttl_sales,
sum(case when r.return_reason is not null then o.sales end) as returned_sales
from orders o
left join returns r
on o.order_id = r.order_id
group by o.category

--####7- write a query to print below 3 columns: category, total_sales_2019(sales in year 2019), total_sales_2020(sales in year 2020)

select category,
sum(case when DATEPART(YEAR,order_date) = '2019' then sales end) as ttl_sales_2019, 
sum(case when DATEPART(YEAR,order_date) = '2020' then sales end) as ttl_sales_2020
from orders
group by category

--8- write a query print top 5 cities in west region by average no of days between order date and ship date.

select top 5 city,
avg(DATEDIFF(DAY, order_date,ship_date)) as avg_days
from orders
where region = 'West' 
group by city
order by avg_days desc

--9- write a query to print emp name, manager name and senior manager name (senior manager is manager's manager)

select e1.emp_name, e2.emp_name as manager_name, e3.emp_name as sr_manager_name
from employee e1
inner join employee e2
on e1.manager_id = e2.emp_id
inner join employee e3
on e2.manager_id = e3.emp_id