use employees; 

-- Find all employees with the same hire date as '101010'
select emp_no
from employees 
where hire_date IN (select hire_date
		  from employees
		  where emp_no = '101010');
		  
-- Find all the titles held by all employees with the first name Aamod
select title, count(title) from titles
where emp_no in (select `emp_no`
				 from employees 
				 where first_name = 'Aamod')
group by title;

-- How many people in the employees table are no longer working for the company
select count(distinct emp_no) 
from employees 
where emp_no not in (select emp_no 
					from dept_emp
					where to_date = '9999-01-01');

/* -- How to check the work
select count(distinct emp_no) - 240124
from employees;

					
select count(distinct emp_no) from dept_emp
where to_date > curdate() */

-- Find all the current department managers that are female
select first_name,
	   last_name
from employees
where emp_no in (select emp_no
  			     from dept_manager
  			     where to_date > curdate())
and gender = "F";

-- Find all the employees that currently have a higher than average salary
select first_name, 
	   last_name, 
	   salary
from employees
join salaries on salaries.emp_no = employees.emp_no and salaries.to_date > curdate()
where salary > (select avg(salary) 
from salaries 
);

-- How many current salaries are within 1 standard deviation of the highest salary? 
select count(salary)
from salaries
where salary >= (select max(salary) - STD(salary)
	 			from salaries)
and to_date > curdate();


-- What percentage of all salaries is this?
select count(salary)/(select count(salary) from salaries) * 100
from salaries
where salary >= (select max(salary) - STD(salary)
	 			from salaries)
and to_date > curdate();


/*- Bonus -*/

--  Find all the department names that currently have female managers.
select dept_name 
from departments
where dept_no in (select `dept_no`
			      from dept_manager
			      where to_date > curdate()
			      and emp_no in (
			      select emp_no
			      from employees
			      where gender = 'F')
);

-- Find the first and last name of the employee with the highest salary.
select first_name,
	   last_name
from employees
where emp_no in (select emp_no
				from salaries
				where salary = (select max(salary)
								from salaries)
	);
	
-- Find the department name that the employee with the highest salary works in.
select dept_name
from departments
where dept_no in (select dept_no
				 from dept_emp
				 where emp_no in (select emp_no
				 				  from salaries
				 				  where salary = (select max(salary)
				 				  					from salaries)
				 )
);