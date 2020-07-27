-- Switch to your data base
use darden_1027;

-- create a temp table for the data asked
CREATE TEMPORARY TABLE employees_with_departments AS
SELECT employees.employees.emp_no, 
	   employees.employees.first_name, 
	   employees.employees.last_name, 
	   employees.departments.dept_no, 
	   employees.departments.dept_name
FROM employees.employees
JOIN employees.dept_emp USING(emp_no)
JOIN employees.departments USING(dept_no)
LIMIT 100;

-- Confirm the temp table was created
select * from employees_with_departments;

-- add a column for full_name
alter table employees_with_departments add full_name VARCHAR(31);

-- check to see if it took
describe employees_with_departments;

-- update to place in the full_name data
update employees_with_departments
set full_name = concat(first_name, " ", last_name);

-- remove the first_name and last_name columns
alter table employees_with_departments drop column first_name;
alter table employees_with_departments drop column last_name;

-- select all from the temp table
select * from employees_with_departments;

-- find another way to create the table
CREATE TEMPORARY TABLE another_way AS
SELECT employees.employees.emp_no, 
	   concat(employees.employees.first_name, " ", employees.employees.last_name) as full_name, 
	   employees.departments.dept_no, 
	   employees.departments.dept_name
FROM employees.employees
JOIN employees.dept_emp USING(emp_no)
JOIN employees.departments USING(dept_no)
LIMIT 100;

select * from another_way;

-- Create a temp table from sakila.payment
Create TEMPORARY TABLE payment as 
select * from sakila.payment;

-- Change amount to be in cents
alter table payment add cents_amount int(64);

update payment
set cents_amount = amount * 100;

ALTER TABLE payment MODIFY cents_amount INT(64) AFTER amount;
ALTER TABLE payment DROP COLUMN amount;
ALTER TABLE payment CHANGE cents_amount amount INT(64);

select * from payment;

-- Find out how the average pay in each department compares to the overall average pay
use darden_1027;
create TEMPORARY TABLE STD_SAL as
select employees.departments.dept_name, 
       avg(employees.salaries.salary) as DEPT_AVG_SAL, 
	   (select avg(employees.salaries.salary) from employees.salaries where employees.salaries.to_date > curdate()) as AVG_SALARY,
	   (select STD(employees.salaries.salary) from employees.salaries where employees.salaries.to_date > curdate()) as STD_SALARY
from employees.salaries
join employees.dept_emp on employees.dept_emp.emp_no = employees.salaries.emp_no
join employees.departments on employees.departments.dept_no = employees.dept_emp.dept_no
where employees.salaries.to_date > curdate()
and employees.dept_emp.to_date > curdate()
group by employees.departments.dept_name;

select dept_name, (dept_avg_sal - AVG_SALARY)/STD_SALARY as salary_z_score 
from STD_SAL


-- alt method with similar results
use darden_1027;
create TEMPORARY TABLE Z_SCORE as
select employees.dept_emp.emp_no,
	   employees.departments.dept_name, 
	   employees.salaries.salary,
	   (select avg(employees.salaries.salary) from employees.salaries where employees.salaries.to_date > curdate()) as AVG_SALARY,
	   (select STD(employees.salaries.salary) from employees.salaries where employees.salaries.to_date > curdate()) as STD_SALARY
from employees.salaries
join employees.dept_emp on employees.dept_emp.emp_no = employees.salaries.emp_no
join employees.departments on employees.departments.dept_no = employees.dept_emp.dept_no
where employees.salaries.to_date > curdate()
and employees.dept_emp.to_date > curdate();

select dept_name, avg((salary - AVG_SALARY)/STD_SALARY) from Z_SCORE
group by dept_name

-- alt method 2 with similar results
use darden_1027;
create TEMPORARY TABLE alt2 as 
select sal.emp_no,
	   dept.dept_name, 
       sal.salary
from employees.salaries as sal
join employees.dept_emp as de on de.emp_no = sal.emp_no
join employees.departments as dept on dept.dept_no = de.dept_no
where sal.to_date > curdate()
and de.to_date > curdate();

ALTER TABLE alt2 ADD mean_salary FLOAT;
ALTER TABLE alt2 ADD sd_salary FLOAT;
ALTER TABLE alt2 ADD z_salary FLOAT;

UPDATE alt2 SET mean_salary = (SELECT avg(salary) FROM employees.salaries
							   where to_date > curdate());
UPDATE alt2 SET sd_salary = (SELECT STD(salary) FROM employees.salaries
							   where to_date > curdate());	
UPDATE alt2 SET z_salary = (salary - mean_salary) / sd_salary;

select dept_name, avg(z_salary) as salary_z_score 
from alt2
group by dept_name