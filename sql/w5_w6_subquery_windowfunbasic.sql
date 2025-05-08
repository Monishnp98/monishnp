--w5-- subquery, Union
--1- write a query to produce below output from icc_world_cup table. 
--team_name, no_of_matches_played , no_of_wins , no_of_losses

with cte1 as (select Team_1 as Team_name, 
case when Team_1 = Winner then 1 else 0 end as flag
from icc_world_cup
union all
select Team_2 as Team_name,
case when Team_2 = Winner then 1 else 0 end as flag
from icc_world_cup)

select  Team_name, count(*) as no_of_matches_played,sum(flag) as no_of_wins ,(count(*) -  sum(flag)) as no_of_losses
from cte1
group by Team_name


--2- write a query to print first name and last name of a customer using orders table(everything after first space can be considered as last name)
--customer_name, first_name,last_name

select customer_name , 
trim(SUBSTRING(customer_name,1,CHARINDEX(' ',customer_name))) as first_name
--CHARINDEX fetches the index of mentioned strinf element(1,index of ' ')
, SUBSTRING(customer_name,CHARINDEX(' ',customer_name)+1,len(customer_name)) as second_name
--from index ' ' to index of len of string
from orders


--3- write a query to print below output using drivers table. 
--Profit rides are the no of rides where end location of a ride is same as start location of immediate next ride for a driver

/* id, total_rides , profit_rides
dri_1,5,1
dri_2,2,0 */
	
with cte1 as (select d1.* from 
drivers as d1
inner join drivers as d2
on d1.id = d2.id and
d1.end_loc = d2.start_loc),

cte2 as (select id, count(*) as ttl_ride
from drivers
group by id)

select cte2.id, cte2.ttl_ride, count(*)-1 as profit_rides
from cte2
left join cte1 
on cte1.id = cte2.id
group by cte2.id,ttl_ride

--4- write a query to print customer name and no of occurence of character 'n' in the customer name.
--customer_name , count_of_occurence_of_n

select customer_name, 
LEN(customer_name)-len(REPLACE(lower(customer_name),'n','')) count_of_occurence_of_n
from orders
group by customer_name
--len(MONISH)- len(MOISH) = 6-1 = 5

--W6- Window function basics

--1- write a query to find premium customers from orders data. Premium customers are those who have done more orders than average no of orders per customer.

with cte1 as(select order_id, count(*) as order_cnts
from orders
group by order_id)

select cte1.order_id, order_cnts
from cte1
where cte1.order_cnts > (select AVG(order_cnts) as avg_cnt
from cte1)

--2- write a query to find employees whose salary is more than average salary of employees in their department

with cte1 as (select dept_id, avg(salary) as avg_sal
from employee
group by dept_id)

select e.*,c.avg_sal  as avg_sal
from employee e
inner join cte1 c
on e.dept_id = c.dept_id
where e.salary > c.avg_sal 

--similar way

select e.* from employee e
inner join (select dept_id,avg(salary) as avg_sal from employee group by dept_id)  d
on e.dept_id=d.dept_id
where salary>avg_sal


--3- write a query to find employees whose age is more than average age of all the employees.
select * from employee
where emp_age > (select avg(emp_age) from employee)


--4- write a query to print emp name, salary and dep id of highest salaried employee in each department 

with cte1 as (select *, rank() over(partition by dept_id order by salary desc) as rnk 
from employee)
select * from cte1
where rnk = 1

--similar way

select e.* from employee e
inner join (select dept_id,max(salary) as max_sal from employee group by dept_id)  d
on e.dept_id=d.dept_id
where salary=max_sal

--5- write a query to print emp name, salary and dep id of highest salaried overall
select * from employee
where salary = (select max(salary) from employee)

--6- write a query to print product id and total sales of highest selling products (by no of units sold) in each category
with cte1 as (select category,product_id, sum(quantity) as quan_sold,sum(sales) as ttl_sales
from orders
group by category,product_id),

cte2 as (select category,product_id, ttl_sales, quan_sold ,rank() over(partition by category order by quan_sold desc) as rnk
from cte1)

select * from cte2
where rnk =1


--W6

--1- write a query to find premium customers from orders data. Premium customers are those who have done more orders than average no of orders per customer.

with cte1 as(select order_id, count(*) as order_cnts
from orders
group by order_id)

select cte1.order_id, order_cnts
from cte1
where cte1.order_cnts > (select AVG(order_cnts) as avg_cnt
from cte1)

--2- write a query to find employees whose salary is more than average salary of employees in their department

with cte1 as (select dept_id, avg(salary) as avg_sal
from employee
group by dept_id)

select e.*,c.avg_sal  as avg_sal
from employee e
inner join cte1 c
on e.dept_id = c.dept_id
where e.salary > c.avg_sal 

--similar way

select e.* from employee e
inner join (select dept_id,avg(salary) as avg_sal from employee group by dept_id)  d
on e.dept_id=d.dept_id
where salary>avg_sal


--3- write a query to find employees whose age is more than average age of all the employees.
select * from employee
where emp_age > (select avg(emp_age) from employee)


--4- write a query to print emp name, salary and dep id of highest salaried employee in each department 

with cte1 as (select *, rank() over(partition by dept_id order by salary desc) as rnk 
from employee)
select * from cte1
where rnk = 1

--similar way

select e.* from employee e
inner join (select dept_id,max(salary) as max_sal from employee group by dept_id)  d
on e.dept_id=d.dept_id
where salary=max_sal

--5- write a query to print emp name, salary and dep id of highest salaried overall
select * from employee
where salary = (select max(salary) from employee)

--6- write a query to print product id and total sales of highest selling products (by no of units sold) in each category
with cte1 as (select category,product_id, sum(quantity) as quan_sold,sum(sales) as ttl_sales
from orders
group by category,product_id),

cte2 as (select category,product_id, ttl_sales, quan_sold ,rank() over(partition by category order by quan_sold desc) as rnk
from cte1)

select * from cte2
where rnk =1