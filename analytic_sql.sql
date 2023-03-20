select e.empno, e.ename, e.job, sal,
	   rank() over(order by sal desc) as rank,
	   dense_rank() over(order by sal desc) as dense_rank,
	   row_number() over(order by sal desc) as row_number 
from hr.emp e 

select e.empno, e.ename, e.job, e.deptno, sal,
	   rank() over(partition by e.deptno order by sal desc) as rank,
	   dense_rank() over(partition by e.deptno order by sal desc) as dense_rank,
	   row_number() over(partition by e.deptno order by sal desc) as row_number 
from hr.emp e 

select e.*,
	   rank() over(order by e.hiredate asc) as hiredate_rank
from hr.emp e 

select e.*,
	   dense_rank() over(partition by e.deptno order by e.sal desc) as sal_dense_rank_asc,
	   dense_rank() over(partition by e.deptno order by e.sal) as sal_dense_rank_desc
from hr.emp e 

select * 
from 
(
select e.*,
	   row_number() over(partition by e.deptno order by e.sal desc) as sal_row_number 
from hr.emp e 
) as sal_rank
where sal_row_number = 1

select * 
from 
(
select e.*,
	   row_number() over(partition by e.deptno order by e.sal desc) as sal_row_number 
from hr.emp e 
) as sal_rank
where sal_row_number <= 2

with 
temp_01 as 
(
select *,
	   case when highest_sal = 1 then 'highest sal'
	   		when lowest_sal = 1 then 'lowest sal'
	   		else 'middle sal' end as classification
from
(select e.*,
	   row_number() over(partition by e.deptno order by e.sal desc) as highest_sal,
	   row_number() over(partition by e.deptno order by e.sal asc) as lowest_sal
from hr.emp e
) as sal_row_number
where highest_sal = 1 or lowest_sal = 1
),
temp_02 as
(
select deptno, max(sal) as max_sal, min(sal) as min_sal from temp_01
group by deptno
)
select t1.*, max_sal - min_sal as sal_diff
from temp_01 t1
	join temp_02 t2 on t1.deptno = t2.deptno

with 
comm as 
(select e.*,
	rank() over(order by e.comm desc nulls last) as comm_rank,
	row_number() over(order by e.comm desc nulls last) as comm_row_number
from emp e 
)
select * from comm
--where comm_rank = 1 or comm_row_number = 1

select e.*,
	   rank() over(order by coalesce(comm, 0) desc) as comm_rank,
	   row_number() over(order by coalesce(comm, 0) desc) as comm_row_num
from hr.emp e 

select oi.order_id, oi.line_prod_seq, oi.product_id, oi.amount,
	   sum(oi.amount) over (partition by oi.order_id) as total_sum_by_order
from nw.order_items oi 
 
select oi.order_id, oi.line_prod_seq, oi.product_id, oi.amount,
	   sum(oi.amount) over (partition by oi.order_id) as total_sum_by_order,
	   sum(oi.amount) over (partition by oi.order_id order by line_prod_seq) as cum_sum_by_order_01,
	   sum(oi.amount) over (partition by oi.order_id order by line_prod_seq rows between unbounded preceding and current row) as cum_sum_by_order_02,
	   sum(oi.amount) over () as total_sum
from nw.order_items oi 
where oi.order_id between 10248 and 10250

select oi.order_id, oi.line_prod_seq, oi.product_id, oi.amount, 
	   max(oi.amount) over (partition by oi.order_id) as max_by_order,
	   max(oi.amount) over (partition by oi.order_id order by oi.line_prod_seq) as cum_max_by_order
from nw.order_items oi 

select oi.order_id, oi.line_prod_seq, oi.product_id, oi.amount, 
	   min(oi.amount) over (partition by oi.order_id) as min_by_order,
	   min(oi.amount) over (partition by oi.order_id order by oi.line_prod_seq) as cum_min_by_order
from nw.order_items oi 

select oi.order_id, oi.line_prod_seq, oi.product_id, oi.amount, 
	   avg(oi.amount) over (partition by oi.order_id) as avg_by_order,
	   avg(oi.amount) over (partition by oi.order_id order by oi.line_prod_seq) as cum_avg_by_order
from nw.order_items oi 

select oi.order_id, oi.line_prod_seq, oi.product_id, oi.amount, 
	   count(*) over (partition by oi.order_id) as cnt_by_order,
	   count(*) over (partition by oi.order_id order by oi.line_prod_seq) as cum_cnt_by_order
from nw.order_items oi 

select e.empno, e.ename, e.deptno, e.sal, e.hiredate,
	   sum(sal) over (partition by e.deptno order by e.hiredate) as cum_sum_by_hiredate
from hr.emp e 

select e.empno, e.ename, e.deptno, e.sal, e.hiredate,
	   avg(sal) over (partition by e.deptno) as avg_sal,
	   sal - avg(sal) over (partition by e.deptno) as diff_sal
from hr.emp e 

with
temp_01 as (
select e.deptno, avg(sal) as avg_sal
from hr.emp e 
group by e.deptno 
)
select e2.empno, e2.ename, e2.deptno, e2.hiredate, e2.sal, e2.sal - avg_sal as diff_sal
from hr.emp e2 
	 join temp_01 e1 on e1.deptno = e2.deptno
order by e2.deptno 

select e.empno, e.ename, e.deptno, e.sal, e.hiredate,
	   sum(sal) over (partition by e.deptno) as dept_sum_sal,
	   round(sal / sum(sal) over (partition by e.deptno), 2) as dept_sum_sal_ratio
from hr.emp e 

select e.empno, e.ename, e.deptno, e.sal, e.hiredate,
	   max(sal) over (partition by e.deptno) as dept_max_sal,
	   round(sal / max(sal) over (partition by e.deptno), 2) as dept_max_sal_ratio
from hr.emp e 

with
temp_01 as (
select oi.product_id , sum(oi.amount) as sum_by_prod
from nw.order_items oi 
group by product_id 
)
select product_id, sum_by_prod,
	   sum(sum_by_prod) over () as total_sum,
	   round(1.0 * sum_by_prod /  sum(sum_by_prod) over (), 2) as sum_by_prod_ratio
from temp_01
order by 4 desc

with
temp_01 as (
select o.employee_id, oi.product_id, sum(oi.amount) as sum_by_emp_prod
from nw.orders o  
	join nw.order_items oi on o.order_id = oi.order_id 
group by o.employee_id, oi.product_id  
)
select *,
	max(sum_by_emp_prod) over(partition by employee_id) as max_by_emp_prod,
	sum_by_emp_prod / max(sum_by_emp_prod) over(partition by employee_id) as ratio_by_max_emp_prod
	from temp_01
order by 1, 5 desc

with 
temp_01 as
(
select max(p.category_id) as category_id, oi.product_id, sum(oi.amount) as sum_by_prod
from nw.order_items oi 
	join nw.products p on oi.product_id = p.product_id 
group by oi.product_id 
),
temp_02 as
(
select *,
	   sum(sum_by_prod) over (partition by category_id) as sum_by_cat,
	   row_number() over (partition by category_id order by sum_by_prod desc) as prod_rank_by_cat,
	   sum_by_prod / sum(sum_by_prod) over (partition by category_id) as sum_ratio
from temp_01
)
select * from temp_02
where sum_ratio >= 0.05 and prod_rank_by_cat <= 3


select *,
	sum(p.unit_price) over (order by p.unit_price) as unit_price_sum
from nw.products p 

select *,
	sum(p.unit_price) over (order by p.unit_price rows between unbounded preceding and current row) as unit_price_sum
from nw.products p 

select *,
	sum(p.unit_price) over (order by p.unit_price rows unbounded preceding) as unit_price_sum
from nw.products p 

select p.product_id , p.product_name , p.category_id , p.unit_price ,
	sum(unit_price) over (partition by category_id order by unit_price rows between 1 preceding and 1 following) as unit_price_sum
from nw.products p 

select p.product_id , p.product_name , p.category_id , p.unit_price ,
	sum(unit_price) over (partition by category_id order by unit_price rows between unbounded preceding and unbounded following) as unit_price_sum
from nw.products p 

select p.product_id , p.product_name , p.category_id , p.unit_price ,
	sum(unit_price) over (partition by category_id order by unit_price rows between current row and unbounded following) as unit_price_sum
from nw.products p 

with
temp_01 as (
select p.category_id , date_trunc('day', o.order_date) as order_date , sum(oi.amount) as sum_by_daily_cat
from order_items oi 
	join orders o on oi.order_id = o.order_id 
	join products p on oi.product_id = p.product_id 
group by p.category_id, date_trunc('day', o.order_date)
order by 1, 2
)
select *,
	sum(sum_by_daily_cat) over (partition by category_id order by order_date rows between 2 preceding and current row),
	sum(sum_by_daily_cat) over (partition by category_id order by order_date range between interval '2' day preceding and current row)
from temp_01

with
temp_01 as (
select date_trunc('day', o.order_date)::date as order_date , sum(oi.amount) as daily_sum
from order_items oi 
	join orders o on oi.order_id = o.order_id 
group by date_trunc('day', o.order_date)::date
order by 1
)
select order_date, daily_sum,
	avg(daily_sum) over (order by order_date rows between 2 preceding and current row) as ma_3day
from temp_01

with
temp_01 as (
select date_trunc('day', o.order_date)::date as order_date , sum(oi.amount) as daily_sum
from order_items oi 
	join orders o on oi.order_id = o.order_id 
group by date_trunc('day', o.order_date)::date
order by 1
)
select order_date, daily_sum,
	avg(daily_sum) over (order by order_date rows between 1 preceding and 1 following) as ca_3days
from temp_01

with
temp_01 as (
select date_trunc('day', o.order_date)::date as order_date , sum(oi.amount) as daily_sum
from order_items oi 
	join orders o on oi.order_id = o.order_id 
group by date_trunc('day', o.order_date)::date
order by 1
)
select order_date, daily_sum,
	avg(daily_sum) over (order by order_date rows between 2 preceding and current row) as ma_3days_01,
	case when row_number() over (order by order_date) <= 2 then null
	else avg(daily_sum) over (order by order_date rows between 2 preceding and current row) end as ma_3days_02
from temp_01
	
with
temp_01 as (
select date_trunc('day', o.order_date)::date as order_date , sum(oi.amount) as daily_sum
from order_items oi 
	join orders o on oi.order_id = o.order_id 
group by date_trunc('day', o.order_date)::date
order by 1
),
temp_02 as (
select order_date, daily_sum,
	avg(daily_sum) over (order by order_date rows between 2 preceding and current row) as ma_3days_01,
	row_number() over(order by order_date)
from temp_01
)
select *,
	case when row_number <= 2 then null
	else ma_3days_01 end as ma_days_02
from temp_02


select generate_series('1996-07-04'::date, '1996-07-23'::date, '1 day'::interval)::date as order_date

with
ref_days as (
select generate_series('1996-07-04'::date, '1996-07-23'::date, '1 day'::interval)::date as order_date
),
temp_01 as (
select date_trunc('day', o.order_date)::date as order_date, sum(amount) as daily_sum
from order_items oi 
	join orders o on oi.order_id = o.order_id 
group by date_trunc('day', o.order_date)::date
),
temp_02 as 
(
select rd.order_date, coalesce(daily_sum, 0) as daily_sum
from ref_days rd
	left outer join temp_01 t1 on rd.order_date = t1.order_date
)
select *,
	avg(daily_sum) over (order by order_date rows between 2 preceding and current row) as ma_3days_01,
	avg(coalesce(daily_sum, 0)) over (order by order_date rows between 2 preceding and current row) as ma_3days_01
from temp_02

select e.empno , e.deptno , e.sal ,
	sum(e.sal) over (partition by e.deptno order by e.sal) as sum,
	sum(e.sal) over (partition by e.deptno order by e.sal range between unbounded preceding and current row) as sum_range,
	sum(e.sal) over (partition by e.deptno order by e.sal rows between unbounded preceding and current row) as sum_row
from hr.emp e 

select e.empno , e.deptno , e.sal , date_trunc('month', e.hiredate)::date as hiremonth ,
	sum(e.sal) over (partition by e.deptno order by date_trunc('month', e.hiredate)) as sum,
	sum(e.sal) over (partition by e.deptno order by date_trunc('month', e.hiredate) rows between unbounded preceding and current row) as sum_rows
from hr.emp e 

select e.empno , e.deptno , e.sal ,
	avg(e.sal) over (partition by e.deptno order by e.sal range between unbounded preceding and current row) as avg_range,
	avg(e.sal) over (partition by e.deptno order by e.sal rows between unbounded preceding and current row) as avg_row,
	sum(e.sal) over (partition by e.deptno order by e.sal range between unbounded preceding and current row) as sum_range,
	sum(e.sal) over (partition by e.deptno order by e.sal rows between unbounded preceding and current row) as sum_row
from hr.emp e 



select e.empno , e.deptno , e.sal , date_trunc('month', e.hiredate)::date as hiremonth ,
	avg(e.sal) over (partition by e.deptno order by date_trunc('month', e.hiredate)) as avg,
	avg(e.sal) over (partition by e.deptno order by date_trunc('month', e.hiredate) rows between unbounded preceding and current row) as avg_rows,
	sum(e.sal) over (partition by e.deptno order by date_trunc('month', e.hiredate)) as sum,
	sum(e.sal) over (partition by e.deptno order by date_trunc('month', e.hiredate) rows between unbounded preceding and current row) as sum_rows
from hr.emp e 

select e.empno , e.deptno , e.hiredate , e.ename ,
	lag(e.ename, 1) over (partition by e.deptno order by e.hiredate) as prev_ename
from hr.emp e 

select e.empno , e.deptno , e.hiredate , e.ename ,
	lag(e.ename, 2, 'No Previous') over (partition by e.deptno order by e.hiredate) as prev_ename
from hr.emp e 


select e.empno , e.deptno , e.hiredate , e.ename ,
	lead(e.ename, 1, 'No Next') over (partition by e.deptno order by e.hiredate) as next_ename
from hr.emp e 

select e.empno , e.deptno , e.hiredate , e.ename ,
	lag(e.ename) over (partition by e.deptno order by e.hiredate desc) as lag_desc_ename
	--lead(e.ename) over (partition by e.deptno order by e.hiredate) as lead_asc_ename
from hr.emp e 


select e.empno , e.deptno , e.hiredate , e.ename ,
	lag(e.ename, 1, 'No Previous') over (partition by e.deptno order by e.hiredate) as prev_ename
from hr.emp e 

select e.empno , e.deptno , e.hiredate , e.ename ,
	coalesce(lag(e.ename) over (partition by e.deptno order by e.hiredate), 'No Previous') as prev_ename
from hr.emp e 

with 
temp_01 as (
select date_trunc('day', o.order_date)::date as order_date
	, sum(oi.amount) as daily_sum
from nw.order_items oi 
	join nw.orders o on oi.order_id = o.order_id 
group by date_trunc('day', o.order_date)::date 
)
select *
	, coalesce(lag(daily_sum) over (order by order_date), daily_sum) as prev_daily_sum
	, daily_sum - coalesce(lag(daily_sum) over(order by order_date), daily_sum) as diff_prev
from temp_01


select e.empno ,e.ename ,e.deptno ,e.hiredate ,e.sal  
	,first_value(sal) over(partition by e.deptno order by e.hiredate) as first_hiredate_sal 
from hr.emp e 

select e.empno ,e.ename ,e.deptno ,e.hiredate ,e.sal  
	,last_value(sal) over(partition by e.deptno order by e.hiredate) as last_hiredate_sal_01
	,last_value(sal) over(partition by e.deptno order by e.hiredate rows between unbounded preceding and unbounded following) as last_hiredate_sal_02
from hr.emp e 

select e.empno ,e.ename ,e.deptno ,e.hiredate ,e.sal 
	,last_value (sal) over (partition by e.deptno order by e.hiredate rows between unbounded preceding and unbounded following) as last_hiredate_sal_01
	,first_value (sal) over (partition by e.deptno order by e.hiredate desc) as last_hiredate_sal_01
from hr.emp e 


select e.empno ,e.ename ,e.deptno ,e.hiredate ,e.sal  
	,first_value(sal) over(partition by e.deptno order by e.hiredate) as first_hiredate_sal 
	,min(sal) over(partition by e.deptno order by e.hiredate) as min_sal
from hr.emp e 


select e.empno ,e.ename ,e.job ,e.sal 
	,rank() over(order by sal desc) as rank
	,cume_dist() over(order by sal desc) as cume_dist
	,cume_dist() over(order by sal desc) * 12.0 as xxtile 
from hr.emp e 


select e.empno ,e.ename ,e.job ,e.sal 
	,rank() over(order by sal asc) as rank
	,cume_dist() over(order by sal asc) as cume_dist
	,cume_dist() over(order by sal asc) * 12.0 as xxtile 
from hr.emp e 


select oi.order_id 
	,rank() over(order by oi.amount desc) as rank
	,cume_dist() over(order by amount desc) as cume_dist
from nw.order_items oi 

select e.empno ,e.ename ,e.job ,e.sal 
	,rank() over(order by sal desc) as rank 
	,percent_rank() over(order by sal desc) as percent_rank
	,1.0 * (rank() over(order by sal desc) - 1) / 11 as percent_rank_calc
from hr.emp e 


select e.empno ,e.ename ,e.job ,e.sal 
	,ntile (5) over (order by sal desc) as ntile
from hr.emp e 

with
temp_01 as (
select oi.product_id ,sum(oi.amount) as sum_amount
from nw.orders o 
	join nw.order_items oi  ON oi.order_id = o.order_id  
group by oi.product_id 
order by 1
) 
select * from (
select t.product_id, p.product_name ,t.sum_amount
	,cume_dist () over (order by sum_amount) as percentile_norm
	,1.0 * row_number() over (order by sum_amount) / count(*) over () as rnum_norm
from temp_01 t
	join nw.products p on t.product_id = p.product_id	 
) as t
where t.percentile_norm >= 0.9

select percentile_disc(0.25) within group (order by sal) qt_1
	,percentile_disc(0.5) within group (order by sal) qt_2
	,percentile_disc(0.75) within group (order by sal) qt_3
	,percentile_disc(1.0) within group (order by sal) qt_4
from hr.emp e 

with
temp_01 as
(
select percentile_disc(0.25) within group (order by sal) qt_1
	,percentile_disc(0.5) within group (order by sal) qt_2
	,percentile_disc(0.75) within group (order by sal) qt_3
	,percentile_disc(1.0) within group (order by sal) qt_4
from hr.emp e 
)
select e2.empno ,e2.ename ,e2.sal 
	,cume_dist () over (order by sal)
	,t.qt_1	,t.qt_2 ,t.qt_3 ,t.qt_4
from hr.emp e2 
	cross join temp_01 t
order by sal

with
temp_01 as
(
select c.category_id ,max(c.category_name) as category_name
	,percentile_disc(0.25) within group (order by unit_price) qt_1
	,percentile_disc(0.5) within group (order by unit_price) qt_2
	,percentile_disc(0.75) within group (order by unit_price) qt_3
	,percentile_disc(1.0) within group (order by unit_price) qt_4
from nw.products p 
	join nw.categories c on p.category_id = c.category_id 
group by c.category_id 
)
select * from temp_01

with
temp_01 as
(
select c.category_id ,max(c.category_name) as category_name
	,percentile_disc(0.25) within group (order by unit_price) qt_1
	,percentile_disc(0.5) within group (order by unit_price) qt_2
	,percentile_disc(0.75) within group (order by unit_price) qt_3
	,percentile_disc(1.0) within group (order by unit_price) qt_4
from nw.products p 
	join nw.categories c on p.category_id = c.category_id 
group by c.category_id 
)
select p2.product_id ,p2.product_name ,p2.category_id ,t.category_name ,unit_price 
	,cume_dist() over(partition by p2.category_id order by unit_price) as cume_dist_by_cat
	,t.qt_1	,t.qt_2 ,t.qt_3 ,t.qt_4
from nw.products p2 
	join temp_01 t on p2.category_id = t.category_id

select 'cont' as classification
	,percentile_cont(0.25) within group (order by sal) qt_1
	,percentile_cont(0.5) within group (order by sal) qt_2
	,percentile_cont(0.75) within group (order by sal) qt_3
	,percentile_cont(1.0) within group (order by sal) qt_4 
from hr.emp e 
union all
select 'disc' as classification
	,percentile_disc(0.25) within group (order by sal) qt_1
	,percentile_disc(0.5) within group (order by sal) qt_2
	,percentile_disc(0.75) within group (order by sal) qt_3
	,percentile_disc(1.0) within group (order by sal) qt_4 
from hr.emp e 
	
with
temp_01 as
(
select 'cont' as classification
	,percentile_cont(0.25) within group (order by sal) qt_1
	,percentile_cont(0.5) within group (order by sal) qt_2
	,percentile_cont(0.75) within group (order by sal) qt_3
	,percentile_cont(1.0) within group (order by sal) qt_4 
from hr.emp e 
union all
select 'disc' as classification
	,percentile_disc(0.25) within group (order by sal) qt_1
	,percentile_disc(0.5) within group (order by sal) qt_2
	,percentile_disc(0.75) within group (order by sal) qt_3
	,percentile_disc(1.0) within group (order by sal) qt_4 
from hr.emp e 
)
select e2.empno ,e2.ename ,e2.sal 
	,cume_dist () over(order by sal)
	,qt_1 ,qt_2 ,qt_3 ,qt_3
from hr.emp e2 
	cross join temp_01 t 
where t.classification = 'disc'
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	




























































































































































































































































































































































