select c.customer_id, c.contact_name, o.order_id, o.customer_id 
from nw.customers c 
	left outer join nw.orders o on c.customer_id = o.customer_id 
where o.order_id is null;

select * from hr.emp;
select * from hr.dept;

select d.*, e.ename 
from hr.dept d 
	left outer join hr.emp e on d.deptno = e.deptno 
	
select d.*, e.ename 
from hr.emp e 
	right outer join hr.dept d on d.deptno = e.deptno 
	
select c.customer_id , c.contact_name , coalesce(o.order_id, 0) as order_id , o.order_date , e.first_name || ' ' || e.last_name as employee_name , s.company_name as shipper_name
from nw.customers c 
	left join nw.orders o on c.customer_id = o.customer_id 
	left join nw.employees e on o.employee_id = e.employee_id 
	left join nw.shippers s on o.ship_via = s.shipper_id 
where c.city = 'Madrid'

select d.* , e.empno , e.ename 
from hr.dept d 
	left join hr.emp e on d.deptno = e.deptno 
	
create table hr.emp_test
as select * from emp

select * from hr.emp_test

update hr.emp_test set deptno = null where empno = 7934

select d.* , e.empno , e.ename 
from hr.dept d 
	full outer join hr.emp_test e on d.deptno = e.deptno 






drop table if exists hr.emp_test








