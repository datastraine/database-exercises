-- Find unique titles from the titles table
select distinct title from titles;

-- Find unique last names that start and end with 'E' from the employees table
select distinct Last_name from employees
where last_name like '%E' and last_name like 'E%'
order by last_name;

-- Find the number of unique combinations of unique last name and first name combinations from the last question
select distinct Last_name, first_name from employees
where last_name like '%E' and last_name like 'E%'
order by last_name;

select count(distinct (concat(last_name, " ", first_name)))
from employees
where last_name like '%E' and last_name like 'E%';

-- Find the unique last names with a 'q' but not 'qu'. Your results should be:
select distinct(last_name) from employees
where last_name like '%q%'
and last_name not like '%qu%';

-- Find how many people share the previous queries last name
select last_name, count(*) from employees
where last_name like '%q%'
and last_name not like '%qu%'
group by last_name
order by last_name;

-- How people with the first name Irena', 'Vidya', or 'Maya' belong to each gender
select gender, count(*) from employees
where first_name in ('Irena', 'Vidya', 'Maya')
group by gender
order by gender;

-- Recall the query the generated usernames for the employees from the last lesson. Are there any duplicate usernames?
-- Yes
select user_name, count(*) from (select lower(concat(substr(first_name, 1, 1), substr(last_name, 1, 4), "_" , 
			 substr(birth_date, 6, 2), substr(birth_date, 3, 2))) as user_name,
        first_name,
        last_name,
        birth_date
from employees) temp 
group by user_name
having count(*) > 1
order by user_name

-- Bonus: how many duplicate usernames are there? 
select count(*)
from 
(select user_name, count(*) 
from 
	(select lower(concat(substr(first_name, 1, 1), substr(last_name, 1, 4), "_" , 
	 substr(birth_date, 6, 2), substr(birth_date, 3, 2))) as user_name,
     first_name,
     last_name,
     birth_date
from employees) temp 
group by user_name
having count(*) > 1
order by user_name
) temp2
-- Answer: 13251