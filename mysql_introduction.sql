select * from mysql.user;

select user, host from mysql.user;

select * from mysql.help_topic;

select help_topic_id, help_category_id, url from mysql.help_topic;

show databases;

use zillow;

select database();

SHOW CREATE DATABASE zillow; 

# Table Exercise 

# 3
use `employees`;
# 4
show tables;
# 5 - VARCHAR, INT, DATE
# 6 - salaries, 
# 7 - all of them
# 8 - titles, salaries, employees, dept manager, dept_emp
# 9 - Table Departments Column dept_no will join with table dept_emp and then pull emp_no to join to table employees
#10 
Show Create Table dept_manager;