select * from hr.salgrade s 

select e.* , s.grade as salgrade
from hr.emp e 
	join hr.salgrade s on e.sal between s.losal and s.hisal 

select * from hr.emp_salary_hist;
select * from hr.emp_dept_hist edh; 

select esh.* ,  edh.deptno 
from hr.emp_salary_hist esh 
	join hr.emp_dept_hist edh on esh.empno = edh.empno and esh.fromdate between edh.fromdate and edh.todate 

select 1 as rnum
	union all
	select 2 as rnum	
	
with 
temp_01 as 
(
	select 1 as rnum
	union all
	select 2 as rnum
)
select d.* , b.*
from hr.dept d 
	cross join temp_01 b;