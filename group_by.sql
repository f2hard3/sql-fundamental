 select e.deptno, max(sal), min(sal), round(avg(sal), 2)
 from hr.emp e 
 group by e.deptno 
 
 select e.deptno, max(sal), min(sal), round(avg(sal), 2) as avg_sal
 from hr.emp e 
 group by e.deptno 
 having avg(sal) >= 2000 
 
 with 
 temp_01 as (
 select e.deptno, max(sal), min(sal), round(avg(sal), 2) as avg_sal
 from hr.emp e 
 group by e.deptno 
 )
 select * from temp_01
 where avg_sal >= 2000
 
 select e.empno, max(e.ename) as ename, avg(esh.sal)
 from hr.emp e 
 	join hr.dept d on e.deptno = d.deptno 
 	join hr.emp_salary_hist esh on e.empno = esh.empno
 where d.dname in ('SALES', 'RESEARCH')
 group by e.empno 
 
 select d.deptno, max(d.dname) as dname, round(avg(esh.sal), 2), count(*)
 from hr.emp e 
 	join hr.dept d on e.deptno = d.deptno 
 	join hr.emp_salary_hist esh on e.empno = esh.empno
 where d.dname in ('SALES', 'RESEARCH')
 group by d.deptno 
 order by 1, 2

drop table if exists hr.emp_test;

create table hr.emp_test
as
select * from hr.emp 

insert into hr.emp_test 
select 8000, 'CHMIN', 'ANALYST', 7839, to_date('19810101', 'YYYYMMDD'), 3000, 1000, 20  

select * from hr.emp_test

select deptno, count(*), sum(et.comm), max(et.comm), min(et.comm), avg(et.comm)
from hr.emp_test et 
group by deptno
order by 1  

select * from hr.emp e 

select mgr, count(*), sum(comm)
from hr.emp e
group by e.mgr  
 
select deptno, max(e.job), min(e.ename), max(e.hiredate), min(e.hiredate) 
from hr.emp e 
group by e.deptno 

select count(distinct et.job)
from hr.emp_test et 

select count(et.job)
from hr.emp_test et 

select count(*)
from hr.emp_test et 

select et.deptno, count(*), count(distinct et.job)
from hr.emp_test et 
group by et.deptno


select to_char(hiredate, 'yyyy') as hire_year, count(*), avg(e.sal)
from hr.emp e 
group by to_char(hiredate, 'yyyy')
order by 1


select floor(sal/1000) * 1000 as bin_range, count(*), sum(sal)
from hr.emp e  
group by floor(sal/1000) * 1000
order by 1

select case when job = 'SALESMAN' then 'SALESMAN' else 'OTHERS' end as job, avg(e.sal), max(e.sal), min(e.sal), count(*)
from hr.emp e 
group by case when job = 'SALESMAN' then 'SALESMAN' else 'OTHERS' end



select *, case when job = 'SALESMAN' then sal else 0 end
from hr.emp e 

select *, case when job = 'SALESMAN' then sal end as sales_sal, case when job = 'MANAGER' then sal end as manager_sal
from hr.emp e 


select job, sum(sal) as sales_sum
from hr.emp e 
group by job

select sum(case when job = 'SALESMAN' then sal end) as sales_sum, 
	   sum(case when job = 'MANAGER' then sal end) as manager_sum,
	   sum(case when job = 'ANALYST' then sal end) as analyst_sum,
	   sum(case when job = 'CLERK' then sal end) as clerk_sum, 
	   sum(case when job = 'PRESIDENT' then sal end) as president_sum
from hr.emp e

select deptno, job, count(*), sum(sal) as sal_sum
from hr.emp e 
group by e.deptno, e.job 
order by 1, 2


select deptno, sum(sal),
	   sum(case when job='SALESMAN' then sal end) as sales_sum,
	   sum(case when job = 'MANAGER' then sal end) as manager_sum,
	   sum(case when job = 'ANALYST' then sal end) as analyst_sum,
	   sum(case when job = 'CLERK' then sal end) as clerk_sum,
	   sum(case when job = 'PRESIDENT' then sal end) as president_sum
from hr.emp e 
group by deptno 

select deptno, count(*),
	   count(case when job='SALESMAN' then 1 end) as sales_count,
	   count(case when job='MANAGER' then 1 end) as manager_count,
	   count(case when job='ANALYST' then 1 end) as analyst_count,
	   count(case when job='CLERK' then 1 end) as clerk_count,
	   count(case when job='PRESIDENT' then 1 end) as president_count
from hr.emp e 
group by deptno 


select deptno, count(*),
	   sum(case when job='SALESMAN' then 1 else 0 end) as sales_count,
	   sum(case when job='MANAGER' then 1 else 0 end) as manager_count,
	   sum(case when job='ANALYST' then 1 else 0 end) as analyst_count,
	   sum(case when job='CLERK' then 1 else 0 end) as clerk_count,
	   sum(case when job='PRESIDENT' then 1 else 0 end) as president_count
from hr.emp e 
group by deptno 


select deptno, job, sum(sal)
from hr.emp e 
group by rollup(deptno, job) 
order by 1, 2

select e.deptno, e.job, sum(e.sal)
from hr.emp e 
group by cube(deptno, job)
order by 1, 2

select c.category_name, p.product_name, sum(oi.amount)
from nw.order_items oi 
	join nw.products p on oi.product_id = p.product_id 
	join nw.categories c on p.category_id = c.category_id 
group by c.category_name, p.product_name 
order by 1, 2

select c.category_name, p.product_name, sum(oi.amount)
from nw.order_items oi 
	join nw.products p on oi.product_id = p.product_id 
	join nw.categories c on p.category_id = c.category_id 
group by rollup(c.category_name, p.product_name)
order by 1, 2

select to_char(o.order_date, 'yyyy')as year, to_char(o.order_date, 'mm') as month, to_char(o.order_date, 'dd') as day, sum(oi.amount) as sum_amount
from nw.order_items oi 
	join nw.orders o on oi.order_id = o.order_id 
group by to_char(o.order_date, 'yyyy'), to_char(o.order_date, 'mm'), to_char(o.order_date, 'dd')
order by 1, 2, 3
	
select to_char(o.order_date, 'yyyy')as year, to_char(o.order_date, 'mm') as month, to_char(o.order_date, 'dd') as day, sum(oi.amount) as sum_amount
from nw.order_items oi 
	join nw.orders o on oi.order_id = o.order_id 
group by rollup(to_char(o.order_date, 'yyyy'), to_char(o.order_date, 'mm'), to_char(o.order_date, 'dd'))
order by 1, 2, 3

with
temp_01 as
( 
select to_char(o.order_date, 'yyyy')as year, to_char(o.order_date, 'mm') as month, to_char(o.order_date, 'dd') as day, sum(oi.amount) as sum_amount
from nw.order_items oi 
	join nw.orders o on oi.order_id = o.order_id 
group by rollup(to_char(o.order_date, 'yyyy'), to_char(o.order_date, 'mm'), to_char(o.order_date, 'dd'))
order by 1, 2, 3
)
select case when year is null then 'total amount' else year end as year,
	   case when year is null then null else case when month is null then 'year amount' else month end end as month,
	   case when year is null or month is null then null else case when day is null then 'month amount' else day end end as day,
	   sum_amount
from temp_01
order by year, month, day
		

select deptno, job, sum(sal)
from hr.emp e 
group by cube(deptno, job) 
order by 1, 2

select c.category_name , p.product_name, e.last_name || ' ' || e.first_name as emp_name, sum(oi.amount) as amount
from nw.order_items oi 
	join nw.products p on oi.product_id = p.product_id 
	join nw.categories c on p.category_id = c.category_id 
	join nw.orders o on oi.order_id = o.order_id 
	join nw.employees e on o.employee_id = e.employee_id 
group by c.category_name, p.product_name, e.last_name || ' ' || e.first_name  
order by 1, 2, 3


select c.category_name , p.product_name, e.last_name || ' ' || e.first_name as emp_name, sum(oi.amount) as amount
from nw.order_items oi 
	join nw.products p on oi.product_id = p.product_id 
	join nw.categories c on p.category_id = c.category_id 
	join nw.orders o on oi.order_id = o.order_id 
	join nw.employees e on o.employee_id = e.employee_id 
group by cube(c.category_name, p.product_name, e.last_name || ' ' || e.first_name)
order by 1, 2, 3









