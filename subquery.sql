select *
from hr.emp e 
where sal >= (select avg(sal) from hr.emp)

select avg(sal) from hr.emp

select *
from hr.emp_salary_hist esh 
where esh.todate = (select max(todate) from hr.emp_salary_hist esh2 where esh.empno = esh2.empno)

select e.ename ,e.deptno 
	,(select d.dname from hr.dept d where e.deptno = d.deptno) as dname
from hr.emp e 

select dname
from (select * from hr.dept d) as dept

select d.*
from hr.dept d 
where d.deptno in (select e.deptno from hr.emp e where e.sal > 1000)

select d.*
from hr.dept d 
where exists (select e.deptno from hr.emp e where d.deptno = e.deptno and e.sal > 1000)

select *
from nw.orders o 
where order_id in (select order_id from nw.order_items oi where oi.amount > 100)

select *
from nw.orders o 
where exists (select order_id from nw.order_items oi where o.order_id = oi.order_id and oi.amount > 100)

select *
from hr.emp e 
where e.deptno in (20, 30)

select *
from hr.emp e 
where e.deptno = 20 or e.deptno = 30

select *
from hr.dept d 
where d.deptno in (select e.deptno from hr.emp e where e.sal < 1300)

select *
from hr.dept d 
where (d.deptno, d.loc) in (select e.deptno, 'DALLAS' from hr.emp e where e.sal < 1300)

select e.*
from hr.emp e 
where e.sal <= (select avg(sal) from hr.emp e2)

select d.*
from hr.dept d 
where d.deptno = (select d.deptno from hr.emp e where e.sal < 1300)

select o.*
from nw.orders o 
where (customer_id, order_date) 
		in (select o2.customer_id ,max(o2.order_date) from nw.orders o2 group by o2.customer_id)

select o.*
from nw.orders o 
where (customer_id, order_date) 
		= (select o2.customer_id ,max(o2.order_date) from nw.orders o2 where customer_id = 'VINET' group by o2.customer_id)

select o.*
from nw.orders o 
where exists (select oi.order_id from nw.order_items oi where o.order_id = oi.order_id and oi.amount > 100)

select o.*
from nw.orders o 
where exists (select 1 from nw.order_items oi where o.order_id = oi.order_id and oi.amount > 100)


select esh.*
from hr.emp_salary_hist esh 
where esh.todate = (select max(esh2.todate) from hr.emp_salary_hist esh2 where esh.empno = esh2.empno)

select c.*
from nw.customers c 
where exists (select 1 from nw.orders o where c.customer_id = o.customer_id group by o.customer_id having count(*) > 2)

select c.*
from nw.customers c 
where exists (select 1 from nw.orders o where c.customer_id = o.customer_id and o.order_date >= to_date('19770101', 'yyyymmdd'))


select o.*
from nw.orders o 
where exists (select 1 from nw.order_items oi  where o.order_id = oi.order_id and oi.amount > 100 )

select o.*
from nw.orders o 
where o.order_id in (select order_id from nw.order_items oi where oi.amount > 100)

select c.*
from nw.customers c 
where exists (select 1 from nw.orders o where c.customer_id = o.customer_id group by o.customer_id having count(*) >= 2)

select c.*
from nw.customers c 
where exists (select 1 from nw.orders o where c.customer_id = o.customer_id and o.order_date >= to_date('19970101', 'yyyymmdd'))

select c.*
from nw.customers c 
where not exists (select 1 from nw.orders o where c.customer_id = o.customer_id and o.order_date >= to_date('19970101', 'yyyymmdd'))

select c.*
from nw.customers c 
	left join (select o.customer_id from nw.orders o where o.order_date >= to_date('19970101', 'yyyymmdd') group by o.customer_id) as o2 on c.customer_id = o2.customer_id
where o2.customer_id is null


select esh.*
from hr.emp_salary_hist esh 
where esh.todate = (select max(esh2.todate) from hr.emp_salary_hist esh2 where esh.empno = esh2.empno)

select esh.*
from hr.emp_salary_hist esh 
where esh.todate = (select esh2.todate from hr.emp_salary_hist esh2 where esh.empno = esh2.empno)

select e.*
from hr.emp e 
where e.sal = (select max(e2.sal) from hr.emp e2) 

select e.*
from hr.emp e
	join (select max(e2.sal) as sal from hr.emp e2) as e2 on e.sal = e2.sal

select * from 
(
select e.*
	,row_number() over (order by e.sal desc) as row_number
from hr.emp e 
) as row_num
where row_num.row_number = 1

select e.* 
from hr.emp e 
where (e.deptno, e.sal) in (select e2.deptno, max(e2.sal) from hr.emp e2 group by e2.deptno)

select e.* 
from hr.emp e 
where e.sal = (select max(e2.sal) from hr.emp e2 where e.deptno  = e2.deptno)

select * 
from
(select e.*
	,row_number() over(partition by e.deptno order by e.sal desc)
from hr.emp e) as e
where row_number = 1
order by e.empno

drop table if exists hr.emp_dept_hist_01

create table hr.emp_dept_hist_01
as
select * from hr.emp_dept_hist edh 

update hr.emp_dept_hist_01
set todate = to_date('1983-12-24', 'yyyy-mm-dd')
where empno = 7934 and todate=to_date('99991231', 'yyyymmdd')

select edh.*
from hr.emp_dept_hist_01 edh
where (edh.empno, edh.todate) in (select edh2.empno, max(edh2.todate) as todate from hr.emp_dept_hist_01 edh2 group by edh2.empno)
order by empno

select edh.*
from hr.emp_dept_hist_01 edh
where edh.todate = (select max(edh2.todate) as todate from hr.emp_dept_hist_01 edh2 where edh.empno = edh2.empno)
order by empno

select *
from (
select *
	,row_number() over(partition by edh.empno order by edh.todate desc)
from hr.emp_dept_hist_01 edh 
) as edh
where row_number = 1
order by empno

select o.order_id ,o.order_date ,o.shipped_date ,c.contact_name ,c.city 
from nw.orders o 
	join nw.customers c on o.customer_id = c.customer_id 
where o.order_date in (select min(o2.order_date) from nw.orders o2 group by o2.customer_id )

select o.order_id ,c.customer_id  ,o.order_date ,o.shipped_date ,c.contact_name ,c.city 
from nw.orders o 
	join nw.customers c on o.customer_id = c.customer_id 
where o.order_date = (select min(o2.order_date) from nw.orders o2 where o.customer_id = o2.customer_id)

with temp_01 
as
(
select o.order_id ,c.customer_id  ,o.order_date ,o.shipped_date ,c.contact_name ,c.city 
from nw.orders o 
	join nw.customers c on o.customer_id = c.customer_id 
where o.order_date = (select min(o2.order_date) from nw.orders o2 where o.customer_id = o2.customer_id)
)  
select customer_id ,count(*) from temp_01 t group by customer_id having count(*) > 1


select *
from
(
select o.order_id ,c.customer_id  ,o.order_date ,o.shipped_date ,c.contact_name ,c.city 
	,row_number() over(partition by o.customer_id order by o.order_date)
from nw.orders o 
	join nw.customers c on o.customer_id = c.customer_id 
) as a
where a.row_number = 1

select o.customer_id ,avg(oi.amount) avg_amount
from nw.orders o 
	join nw.order_items oi on o.order_id = oi.order_id 
group by o.customer_id 

select p.product_name ,o.order_id ,oi.amount ,c.contact_name ,c.city 
from nw.orders o 
	join nw.order_items oi on o.order_id = oi.order_id 
	join nw.customers c on o.customer_id = c.customer_id 
	join nw.products p on oi.product_id = p.product_id 
where (oi.amount) >= 
(select avg(oi.amount) avg_amount
from nw.orders o2 
	join nw.order_items oi on o2.order_id = oi.order_id 
where o.customer_id = o2.customer_id 
)
order by o.order_id 

 
select * from
(select p.product_name ,o.order_id ,oi.amount ,c.contact_name ,c.city 
	,avg(oi.amount) over (partition by c.customer_id rows between unbounded preceding and unbounded following) avg_amount
from nw.orders o 
	join nw.order_items oi on o.order_id = oi.order_id 
	join nw.customers c on o.customer_id = c.customer_id 
	join nw.products p on oi.product_id = p.product_id 
) oo
where oo.amount >= avg_amount
order by oo.contact_name

select e.*
from hr.emp e 
where e.deptno in (20, 30)

select e.*
from hr.emp e 
where e.deptno = 20 or e.deptno = 30

select e.*
from hr.emp e 
where e.deptno in (20, 30, null)

select e.*
from hr.emp e 
where e.deptno = 20 or e.deptno = 30 or deptno = null

select e.*
from hr.emp e 
where e.deptno not in (20, 30, null)

select e.*
from hr.emp e 
where not e.deptno = 20 and not e.deptno = 30 and not deptno = null


drop table if exists nw.region

create table nw.region
as
select o.ship_region as region_name
from nw.orders o 
group by o.ship_region 

insert into nw.region values('XX')

select distinct * from nw.region

select r.*
from nw.region r
where r.region_name in 
(
select o.ship_region 
from nw.orders o 
)

select r.*
from nw.region r
where exists
(
select 1
from nw.orders o 
where o.ship_region = r.region_name
)

select r.*
from nw.region r
where r.region_name not in 
(
select o.ship_region 
from nw.orders o 
)

select r.*
from nw.region r
where not exists
(
select 1
from nw.orders o 
where o.ship_region = r.region_name
)

select 1 = 1;
select 1 = 2;
select null = null;
select 1 = 1 and null;
select 1 = 1 and null = null;
select 1 = 1 or null;
select not 1 = 1;
select not null;


select r.*
from nw.region r
where r.region_name not in 
(
select o.ship_region 
from nw.orders o 
where o.ship_region is not null
)


select r.*
from nw.region r
where not exists
(
select 1
from nw.orders o 
where o.ship_region = r.region_name
) and r.region_name is not null

select e.* ,(select d.dname from hr.dept d where e.deptno = d.deptno) as dname
from hr.emp e 

select e.* ,(select d.dname, d.deptno from hr.dept d where e.deptno = d.deptno) as dname
from hr.emp e 

select e.* ,(select d.dname from hr.dept d where e.deptno = d.deptno limit 1) as dname
from hr.emp e 

select d.* ,(select e.ename  from hr.emp e  where e.deptno = d.deptno) as ename
from hr.dept d 

select d.* ,(select e.ename  from hr.emp e  where e.deptno = d.deptno limit 1) as ename
from hr.dept d 

select e.*,
	(case when e.deptno = 10 then (select d.dname from hr.dept d where d.deptno=20) else (select d2.dname from hr.dept d2 where d2.deptno = e.deptno) end) as dname
from hr.emp e 

select e.*,
	(select avg(sal) from hr.emp e2 where e2.deptno = e.deptno) dept_avg_sal
from hr.emp e 

select e.*, d.avg_sal
from hr.emp e
	join (select deptno, avg(sal) as avg_sal from hr.emp e2 group by e2.deptno) d
	on e.deptno = d.deptno

select e.*,
	(select e2.ename from hr.emp e2 where e.mgr = e2.empno) as mgr_name
from hr.emp e 

select e.*, e2.ename as mgr_name
from hr.emp e 
	left join hr.emp e2 on e.mgr = e2.empno 
	
 select o.order_id, o.customer_id, o.employee_id ,o.order_date 
 	,(select c.contact_name from nw.customers c where o.customer_id = c.customer_id) as customer_name
 	,(select e.first_name || ' ' || last_name from nw.employees e where o.employee_id = e.employee_id) as employee_name
 	,case when o.ship_country = 'France' then (select c.contact_name from nw.customers c where c.customer_id = o.customer_id)
 										 else (select first_name || ' ' || last_name from nw.employees e2 where o.employee_id = e2.employee_id) end as new_name
 from nw.orders o 

select o.order_id, o.customer_id, o.employee_id ,o.order_date, c.contact_name , e.last_name || ' ' || e.first_name  as employee_name,
	case when o.ship_country = 'France' then c.contact_name else e.last_name || ' ' || e.first_name end as new_name
from nw.orders o 
	left join nw.customers c on o.customer_id = c.customer_id 
	left join nw.employees e on o.employee_id = e.employee_id 
	
select c.customer_id ,c.contact_name 
	,(select min(o.order_date) from nw.orders o where o.customer_id = c.customer_id ) as first_order_date
from nw.customers c 


select c.customer_id ,c.contact_name, oo.first_order_date 
from nw.customers c 
	left join (select o.customer_id, min(o.order_date) as first_order_date from nw.orders o group by o.customer_id) as oo
	on c.customer_id = oo.customer_id


select c.customer_id ,c.contact_name 
	,(select min(o.order_date) from nw.orders o where o.customer_id = c.customer_id ) as first_order_date
	,(select o2.ship_address from nw.orders o2 where o2.customer_id = c.customer_id and o2.order_date = (select min(o3.order_date) from nw.orders o3 where o3.customer_id = c.customer_id)) as first_ship_date
	,(select o4.shipped_date from nw.orders o4 where o4.customer_id = c.customer_id and o4.order_date = (select min(o5.order_date) from nw.orders o5 where o5.customer_id = c.customer_id)) as first_shipped_date
from nw.customers c 
order by c.customer_id 

select c.customer_id ,c.contact_name, o.order_date as first_order_date, o.ship_address ,o.shipped_date 
from nw.customers c 
	left join nw.orders o on c.customer_id = o.customer_id 
	and o.order_date = (select min(o2.order_date) from nw.orders o2 where c.customer_id = o2.customer_id)















































































