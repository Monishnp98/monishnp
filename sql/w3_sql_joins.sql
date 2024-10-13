-- example 1 :orders and returns table used in join
-- example 2 :employee and depatrment tables used in join

--1- write a query to get region wise count of return orders

select o.region, count(distinct(o.order_id)) as returned_orders
from orders as o
inner join returns as r
on o.order_id = r.order_id
group by o.region
order by returned_orders  desc

--2- write a query to get category wise sales of orders that were not returned 

select category, sum(sales) as sale_confirmed
from orders as o
left join returns as r
on o.order_id = r.order_id
where r.order_id is null
group by category
order by sale_confirmed desc

--3- write a query to print dep name and average salary of employees in that dep 

select d.dep_name,AVG(salary) as avg_salary
from employee e
inner join dept d
on e.dept_id = d.dep_id
group by d.dep_name
order by avg_salary desc

--4- write a query to print dep names where none of the emplyees have same salary.

select  d.dep_name, count(*)
from employee e
inner join dept d
on e.dept_id = d.dep_id
group by dep_name
having count(e.dept_id) = count(distinct(e.salary))

--5- write a query to print sub categories where we have all 3 kinds of returns (others,bad quality,wrong items)

select sub_category
from orders as o
inner join returns as r
on o.order_id = r.order_id
group by sub_category
having count(distinct(r.return_reason)) = 3

--6- write a query to find cities where not even a single order was returned.

select o.city
from orders as o
left join returns as r
on o.order_id = r.order_id
group by o.city
having count(r.order_id) = 0

--7- write a query to find top 3 subcategories by sales of returned orders in east region

select top 3 o.sub_category, sum(o.sales) as returned_sales
from orders as o
inner join returns as r
on o.order_id = r.order_id
where region = 'East'
group by o.sub_category
order by returned_sales desc

--8- write a query to print dep name for which there is no employee

select d.dep_id,d.dep_name
from dept d 
left join employee e on e.dept_id=d.dep_id
group by d.dep_id,d.dep_name
having count(e.emp_id)=0;


--9- write a query to print employees name for which dep id is not avaiable in dept table

select e.*
from employee e 
left join dept d  on e.dept_id=d.dep_id
where d.dep_id is null;