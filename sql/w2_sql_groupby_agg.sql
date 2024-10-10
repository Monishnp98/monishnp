--1)write a update statement to update city as null for order ids :  CA-2020-161389 , US-2021-156909
select * from orders 
where order_id in('CA-2020-161389' , 'US-2021-156909')

update orders set city = null
where  order_id in('CA-2020-161389' , 'US-2021-156909')

--2)write a query to find orders where city is null (2 rows)
select * from orders
where city is null

--3)write a query to get total profit, first order date and latest order date for each category
select category, min(order_date) as first_order_date, max(order_date) last_order_date
from orders
group by category

--4)write a query to find sub-categories where average profit is more than the half of the max profit in that sub-category

select sub_category
from orders
group by sub_category
having avg(profit) > max(profit)/2

--6)write a query to find total number of products in each category.
select category, count(distinct(product_id)) as no_prd_id
from orders
group by category

--7)write a query to find top 5 sub categories in west region by total quantity sold
select top 5 sub_category,sum(quantity) as ttl_qty_sold
from orders 
where region = 'West'
group by sub_category
order by ttl_qty_sold desc


--8)write a query to find total sales for each region and ship mode combination for orders in year 2020
select * from orders

select region, ship_mode, sum(sales) as ttl_sales
from orders
where DATEPART(YEAR,order_date) = '2020'
group by region, ship_mode
order by region, ttl_sales desc


--5)write a query to find students who have got same marks in Physics and Chemistry.

--1	Chemistry	91  
--1	Physics	91
--1	Maths	92
--2	Chemistry	80
--2	Physics	90
--3	Chemistry	80
--3	Maths	80
--4	Chemistry	71
--4	Physics	54
--5	Chemistry	79
 
 --o/p
 --1	Chemistry	91  
 --1	Physics	91          

select student_id,marks from exams
where subject in ('Physics','Chemistry')
group by student_id,marks
having  COUNT(1) = 2