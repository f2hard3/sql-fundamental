select * 
from hr.emp e;

select e.*, d.* 
from hr.emp e 
	join hr.dept d on e.deptno = d.deptno ;

select e.*, d.dname
from hr.emp e 
	join hr.dept d on e.deptno = d.deptno 
where e.job = 'SALESMAN' ;

select d.dname, e.empno, e.ename, e.job, esh.*
from hr.emp e
	join hr.dept d on e.deptno = d.deptno 
	join hr.emp_salary_hist esh on e.empno = esh.empno 
where d.dname in ('SALES', 'RESEARCH')
order by d.dname;

select d.dname, e.empno, e.ename, e.job, esh.*
from hr.emp e
	join hr.dept d on e.deptno = d.deptno 
	join hr.emp_salary_hist esh on e.empno = esh.empno 
where d.dname in ('SALES', 'RESEARCH') and esh.fromdate >= to_date('19830101', 'yyyymmdd')
order by 1, 2, 3, esh.fromdate ;

with
temp_01 as
(
select d.dname, e.empno, e.ename, e.job, esh.fromdate, esh.todate, esh.sal 
from hr.dept d 
	join hr.emp e on d.deptno = e.deptno 
	join hr.emp_salary_hist esh on e.empno = esh.empno 
where d.dname in ('SALES', 'RESEARCH')
order by d.dname, e.empno, esh.fromdate 
)
select empno, max(ename) as ename, avg(sal) as avg_sal
from temp_01
group by empno;

select e.ename, e.empno, edh.deptno, d.dname, edh.fromdate, edh.todate  
from emp e
	join emp_dept_hist edh on e.empno = edh.empno
	join dept d on edh.deptno = d.deptno 
where e.ename = 'SMITH'

select c.contact_name, c.address, o.order_id, o.order_date, o.shipped_date, o.ship_address
from nw.customers c
	join nw.orders o on c.customer_id = o.customer_id 
where c.contact_name = 'Antonio Moreno' 
and o.order_date between to_date('19970101', 'yyyymmdd') and to_date('19971231', 'yyyymmdd')  

SELECT customer_id, company_name, contact_name, contact_title, address, city, region, postal_code, country, phone, fax
FROM nw.customers;

SELECT order_id, customer_id, employee_id, order_date, required_date, shipped_date, ship_via, freight, ship_name, ship_address, ship_city, ship_region, ship_postal_code, ship_country
FROM nw.orders;

select c.customer_id, c.contact_name, o.order_id, o.order_date, e.first_name || ' ' || e.last_name as employee_name, s.company_name 
from nw.customers c 
	join nw.orders o on c.customer_id = o.customer_id 
	join nw.employees e on o.employee_id = e.employee_id
	join nw.shippers s on o.ship_via = s.shipper_id  
where c.city = 'Berlin'


select c.category_name, p.product_id, p.product_name, s.company_name  
from nw.categories c 
	join nw.products p on c.category_id = p.category_id
	join nw.suppliers s on p.supplier_id = s.supplier_id 
where c.category_name = 'Beverages'

select c.contact_name, c.address, o.order_id, p.product_id, o.order_date, o.shipped_date, o.ship_address, p.product_name, oi.amount, s.company_name 
from nw.customers c
	join nw.orders o on c.customer_id = o.customer_id
	join nw.order_items oi on o.order_id = oi.order_id 
	join nw.products p on oi.product_id = p.product_id 
	join nw.categories c2 on p.category_id = c2.category_id 
	join nw.suppliers s on p.supplier_id = s.supplier_id 
where c.contact_name = 'Antonio Moreno' 
and o.order_date between to_date('19970101', 'yyyymmdd') and to_date('19971231', 'yyyymmdd')  









