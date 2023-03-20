select pg_typeof(to_date('2022-01-01', 'yyyy-mm-dd'))

select to_timestamp('2022-01-01', 'yyyy-mm-dd') 

select to_timestamp('2022-01-01 14:36:52', 'yyyy-mm-dd hh24:mi:ss') 

select to_date('2022-01-01', 'yyyy-mm-dd')::timestamp

select to_timestamp('2022-01-01', 'yyyy-mm-dd')::text 

select to_timestamp('2022-01-01 14:36:52', 'yyyy-mm-dd hh24:mi:ss')::date 

with
temp_01 as (
select e.* , to_char(e.hiredate, 'yyyy-mm-dd') as hiredate_str
from hr.emp e 
)
select *, pg_typeof(hiredate_str) from temp_01
union all
select *, pg_typeof(hiredate_str) from temp_01


with
temp_01 as (
select e.* , to_char(e.hiredate, 'yyyy-mm-dd') as hiredate_str
from hr.emp e 
)
select empno, ename, hiredate, hiredate_str,
		to_date(hiredate_str, 'yyyy-mm-dd') as hiredate_01,
		to_timestamp(hiredate_str, 'yyyy-mm-dd') as hiretime_01,
		to_timestamp(hiredate_str, 'yyyy-mm-dd hh24:mi:ss') as hiretime_02,
		to_char(hiredate, 'yyyymmdd hh24:mi:ss') as hiredate_str_01,
		to_char(hiredate, 'Month dd yyyy') as hiredate_str_02,
		to_char(hiredate, 'MONTH dd yyyy') as hiredate_str_03,
		to_char(hiredate, 'Month w d') as hiredate_str_04,
		to_char(hiredate, 'Month, day') as hiredate_str_05
from temp_01

with
temp_01 as (
select e.*,
		to_char(e.hiredate, 'yyyy-mm-dd') as hire_date_str ,
		hiredate::timestamp as hiretime
from hr.emp e 
)
select empno, ename, hiredate, hire_date_str, hiretime,
		to_char(hiretime, 'yyyy/mm/dd hh24:mi:ss') as hiretime_01, 
		to_char(hiretime, 'yyyy/mm/dd PM hh12:mi:ss') as hiretime_02,
		to_timestamp('2022-03-04 22:10:15', 'yyyy-mm-dd hh24:mi:ss')  as timestamp_01,
		to_char(to_timestamp('2022-03-04 22:10:15', 'yyyy-mm-dd hh24:mi:ss'), 'yyyy/mm/dd AM hh12:mi:ss') as timestr_01
from temp_01


select e.*,
		extract(year from e.hiredate) as year,
		extract(month from e.hiredate) as month,
		extract(day from e.hiredate) as day
from hr.emp e 

select e.*,
		date_part('year', e.hiredate) as year,
		date_part('month', e.hiredate) as month,
		date_part('day', e.hiredate) as day
from hr.emp e 


select  date_part('hour', '2022-02-03 13:04:10'::timestamp) as hour,
		date_part('minute', '2022-02-03 13:04:10'::timestamp) as minute,
		date_part('second', '2022-02-03 13:04:10'::timestamp) as second

select extract(hour from '2022-02-03 13:04:10'::timestamp) as hour,
		extract(minute from '2022-02-03 13:04:10'::timestamp) as minute,
		extract(second from '2022-02-03 13:04:10'::timestamp) as second;
	
	
	
	
select to_date('2022-01-01', 'yyyy-mm-dd') + 2 as date_01

select to_date('2022-01-01', 'yyyy-mm-dd') - 2 as date_01;

select to_timestamp('2022-01-01 14:36:52', 'yyyy-mm-dd hh24:mi:ss') + interval '7 hours' as timestamp_01

select to_timestamp('2022-01-01 14:36:52', 'yyyy-mm-dd hh24:mi:ss') + interval '2 days' as timestamp_01

select to_timestamp('2022-01-01 14:36:52', 'yyyy-mm-dd hh24:mi:ss') + interval '2 days 7 hours 30 minutes' as timestamp_01
		
select to_date('2022-01-01', 'yyyy-mm-dd') + interval '2 days' as date_01
		
select to_date('2022-01-03', 'yyyy-mm-dd') - to_date('2022-01-01', 'yyyy-mm-dd'),
		pg_typeof(to_date('2022-01-03', 'yyyy-mm-dd') - to_date('2022-01-01', 'yyyy-mm-dd'))
		
select to_date('2022-01-01', 'yyyy-mm-dd') - to_date('2022-01-03', 'yyyy-mm-dd'),
		pg_typeof(to_date('2022-01-03', 'yyyy-mm-dd') - to_date('2022-01-01', 'yyyy-mm-dd'))
		

select to_timestamp('2022-01-01 14:36:52', 'yyyy-mm-dd hh24:mi:ss') - to_timestamp('2022-01-01 12:36:52', 'yyyy-mm-dd hh24:mi:ss') as time_01,
		pg_typeof(to_timestamp('2022-01-01 14:36:52', 'yyyy-mm-dd hh24:mi:ss') - to_timestamp('2022-01-01 12:36:52', 'yyyy-mm-dd hh24:mi:ss')) as type
		
		
with temp_01 as (
select e.empno , e.ename , e.hiredate , now() , current_timestamp, current_date , current_time , date_trunc('second', now()) as now_trunc, now() - hiredate as working_days 
from hr.emp e 
)
select *,
		date_part('year',working_days),
		justify_interval(working_days),
		age(hiredate),
		date_part('year', justify_interval(working_days)) || 'year ' || date_part('month', justify_interval(working_days)) || 'month' as working_year_month,
		date_part('year', age(hiredate)) || 'year ' || date_part('month', age(hiredate)) || 'month' as working_year_month_01
from temp_01


-- trunc / date_trunc function

select trunc(99.9999, 2) 

select date_trunc('day', '2022-03-03 14:05:32'::timestamp) 

select date_trunc('day', to_date('2022-03-03', 'yyyy-mm-dd'))

select date_trunc('day', '2022-03-03'::date)::date

select date_trunc('month', '2022-03-03'::date)::date

select date_trunc('year', '2022-03-03'::date)::date

select date_trunc('week', '2022-03-03'::date)::date

select date_trunc('week', '2022-03-03'::date)::date + interval '6 days'

select date_trunc('week', '2022-03-03'::date)::date - 1

select (date_trunc('week', '2022-03-03'::date)::date - 1+ interval '6 days')::date

select (date_trunc('month', '2022-03-03'::date) + interval  '1 month' - interval '1 day')::date

select date_trunc('hour', now())

drop table if exists hr.emp_test

create table hr.emp_test
as
select e.* , hiredate + current_time as hiretime 
from hr.emp e 

select * from hr.emp_test

select date_trunc('month', hiredate) as hire_month, count(*)
from hr.emp_test et 
group by date_trunc('month', hiredate) 

select date_trunc('day', hiretime) as hire_day, count(*)
from hr.emp_test et 
group by date_trunc('day', hiretime) 




		
