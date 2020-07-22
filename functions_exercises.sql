/* Update queries from the order_by_exercises for employees whose names start and end with 'E'. Use concat() 
to combine their first and last name together as a single column named full_name. */
select concat(first_name, " ", last_name) as full_name
from employees
where last_name like '%E' and last_name like 'E%'
order by emp_no;

select concat(first_name, " ", last_name) as full_name
from employees
where last_name like '%E' and last_name like 'E%'
order by emp_no DESC;

-- Converts the names produced in your last query to all uppercase.
select upper(concat(first_name, " ", last_name)) as full_name
from employees
where last_name like '%E' and last_name like 'E%'
order by emp_no DESC;

/* Uses datediff() to find how many days employees born on Christmas and hired in the 90s,  
have been working at the company */
select concat(first_name, " ", last_name) as full_name,
	   datediff(curdate(), hire_date) as days_at_company,
       hire_date,
       birth_date
from employees
where birth_date like '%-12-25'
and hire_date between '1990-01-01' and '1999-12-31'
order by birth_date asc, hire_date desc; 

-- Finds the minimum salary for the company
select min(salary)
from salaries;

/* Create a username that is all lowercase, and consist of: 
the first character of the employees first name, 
the first 4 characters of the employees last name, 
an underscore, 
the month the employee was born, 
and the last two digits of the year that they were born */
select lower(concat(substr(first_name, 1, 1), substr(last_name, 1, 4), "_" , 
			 substr(birth_date, 6, 2), substr(birth_date, 3, 2))) as user_name,
        first_name,
        last_name,
        birth_date
from employees 