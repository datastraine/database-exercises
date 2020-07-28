use employees;

-- Create a current employee column from
select temp.emp_no, 
       dept_no,
       start_date, 
       end_date,
       if (end_date > curdate(), true, false) as 'is_current_employee' 
from dept_emp
join (select emp_no, max(from_date) as start_date, max(to_date) as end_date
from dept_emp
group by emp_no) temp 
on dept_emp.emp_no = temp.emp_no
and dept_emp.to_date = temp.end_date
and dept_emp.from_date = temp.start_date
;

-- Create a column that groups last name by A-H, I-Q, or R-Z
select first_name, 
       last_name,
	   case 
	   	  when left(last_name, 1) in ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H') then "A-H"
	   	  when left(last_name, 1) in ('I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q') then "I-Q"
	   	  when left(last_name, 1) in ('R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z') then "R-Z"
	   	  	end
from employees;

-- How many employees are born in each decade
select
       sum(case when year(birth_date) >= 1950 and year(birth_date) < 1960 then "1" else null end) '50s',
       sum(case when year(birth_date) >= 1960 and year(birth_date) < 1970 then "1" else null end) '60s',
       sum(case when year(birth_date) >= 1970 and year(birth_date) < 1980 then "1" else null end) '70s',
       sum(case when year(birth_date) >= 1980 and year(birth_date) < 1990 then "1" else null end) '80s',
       sum(case when year(birth_date) >= 1990 and year(birth_date) < 2000 then "1" else null end) '90s',
       sum(case when year(birth_date) >= 2000 and year(birth_date) < 2010 then "1" else null end) '00s',
       sum(case when year(birth_date) >= 2010 and year(birth_date) < 2020 then "1" else null end) '10s'
from employees;

-- What is the average salary for each of the following department groups: R&D, Sales & Marketing, Prod & QM, Finance & HR, Customer Service?
select case 
		   when dept_name = "Customer Service" then "Customer Service"
		   when dept_name in ('Finance', 'Human Resources') then "Finance & HR"
		   when dept_name in ('Sales', 'Marketing') then "Sales & Marketing"
		   when dept_name in ('Production','Quality Management') then "Prod & QM"
		   when dept_name in ('Research', 'Development') then "R&D"
		   else null end as dept_group,
		   avg(salary) as avg_salary 
from salaries
join dept_emp on dept_emp.emp_no = salaries.emp_no
join departments on departments.dept_no = dept_emp.dept_no
group by dept_group;