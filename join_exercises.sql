/* - Part 1 -*/
use join_example_db;

-- Inner Join
select * from roles
join users on users.role_id = roles.id;

-- Left Join
select * from roles
left join users on users.role_id = roles.id;

-- Right Join
select * from roles
right join users on users.role_id = roles.id;

-- How many users belong to each role
select roles.name as roles, count(users.name) total
from roles
left join users on users.role_id = roles.id
group by roles.name;

/* - Part 2 -*/
use employees;

-- Current department managers
select dept_name as "Departemnt Name", 
       concat(first_name, " ", last_name) as "Department Manager" 
from departments
left join dept_manager on dept_manager.`dept_no` = departments.dept_no
left join employees on employees.emp_no = dept_manager.emp_no
where dept_manager.to_date > CURDATE()
order by dept_name;

-- Current departments managed by women  
select dept_name as "Departemnt Name", 
       concat(first_name, " ", last_name) as "Department Manager" 
from departments
left join dept_manager on dept_manager.`dept_no` = departments.dept_no
left join employees on employees.emp_no = dept_manager.emp_no
where dept_manager.to_date > CURDATE()
and gender = 'F'
order by dept_name;

-- Of the people who currently work in customer service, how many are assigned to each role
select title, count(*) from departments
join dept_emp on dept_emp.dept_no = departments.dept_no
join titles on titles.emp_no = dept_emp.emp_no
where dept_name = "Customer Service"
and dept_emp.to_date > curdate()
and titles.to_date > curdate()
group by title
order by title;

-- Current department managers and their salary
select dept_name as "Departemnt Name", 
       concat(first_name, " ", last_name) as "Department Manager",
       salary
from departments
left join dept_manager on dept_manager.`dept_no` = departments.dept_no
left join employees on employees.emp_no = dept_manager.emp_no
left join salaries on salaries.emp_no = employees.emp_no
where dept_manager.to_date > CURDATE()
and salaries.to_date > CURDATE()
order by dept_name;

-- The number of employees in each department
select departments.dept_no, 
       dept_name, 
       count(dept_emp.emp_no) as num_employees
from departments
join dept_emp on dept_emp.dept_no = departments.dept_no
where to_date > curdate()
group by departments.dept_no, dept_name;

-- Department with the highest CURRENT average salary
select dept_name,  
	   avg(salary)
from departments
left join dept_emp on dept_emp.dept_no = departments.dept_no
left join salaries on dept_emp.emp_no = salaries.emp_no
where dept_emp.to_date > curdate()
and salaries.to_date > curdate()
group by dept_name
order by avg(salary) desc
limit 1;

-- The highest paid employee in the Marketing department
-- Note: You can also solve this by using without joining the departments table
select first_name, 
	   last_name,
from employees
left join salaries on salaries.emp_no = employees.emp_no
left join dept_emp on dept_emp.emp_no = salaries.emp_no
left join departments on departments.dept_no = dept_emp.dept_no
where salaries.to_date > curdate()
and dept_emp.to_date > curdate()
and dept_name = 'Marketing'
order by salary desc
limit 1;


-- The current highest paid department manager
select first_name, 
	   last_name, 
	   salary,
	   dept_name 
from departments
left join dept_manager on dept_manager.`dept_no` = departments.dept_no
left join employees on employees.emp_no = dept_manager.emp_no
left join salaries on salaries.emp_no = employees.emp_no
where dept_manager.to_date > CURDATE()
and salaries.to_date > CURDATE()
order by salary desc 
limit 1;

-- All current employees, their department name, and their current manager's name
select concat(first_name, " ", last_name) as "Employee Name",
	   dept_name as "Department Name",
	   Manager_Name as "Manager Name"
from employees
left join dept_emp on dept_emp.emp_no = employees.emp_no
left join departments on departments.dept_no = dept_emp.dept_no
left join (select concat(first_name, " ", last_name) as Manager_Name,
		   dept_no
		   from employees
		   left join dept_manager on dept_manager.emp_no = employees.emp_no
		   where to_date > curdate()
		   ) manager
on manager.dept_no = departments.dept_no
where dept_emp.to_date > curdate()
order by dept_name, concat(first_name, " ", last_name);

-- Highest paid employee in each department
select dept_name as "Department Name", EmpName as "Employeee Name", maxsalary as "Salary" from (select dept_name, 
	   max(salary) as maxsalary
from departments 
left join dept_emp on dept_emp.dept_no = departments.dept_no
left join employees on employees.emp_no = dept_emp.emp_no
left join salaries on salaries.emp_no = employees.emp_no
where dept_emp.to_date > curdate()
and salaries.to_date > curdate()
group by dept_name
) temp1
left join (select concat(first_name, " ", last_name) as EmpName,
	   max(salary) as maxsal
from employees
left join salaries on salaries.emp_no = employees.emp_no
where to_date > curdate()
group by concat(first_name, " ", last_name)
) temp2
on temp2.maxsal = temp1.maxsalary