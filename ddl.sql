# Data Definition Language
# commands are case-insensitve

# Create a database
create database employees;

# Show databases
show databases;

# Set the current active database
use employees;

# Find current active database
select database();

# Show table
show tables;

# Describe table
# describe <table_name>
describe employees;

# Create a new table
create table employees (
  employee_id int unsigned auto_increment primary key,
  email varchar(320),
  gender varchar(1),
  notes text,
  employment_date date,
  designation varchar(100)
) engine = innodb;

# Delete a table
# drop table <table_name>
drop table employees;

# Inserting rows
# Note: No need to add primary key because it will be done by auto_increment
insert into employees (
  first_name, email, gender, notes, employment_date, designation
) values ('John Snow', 'asd@asd.com', 'm', 'Newbie', curdate(), 'Intern');

# See all the rows in a table
select * from employees;

# Update one row in a table
# IMPORTANT: Remember to use 'where' keyword to target specific row, otherwise all rows will be updated
update employees set email='asd@gmail.com' where employee_id = 1;

# Delete one row
# IMPORTANT: Remember to use 'where' keyword to target specific row, otherwise all rows will be deleted
delete from employees where employee_id = 1;

# Hands-on
# Create 'departments' table
create table departments (
  department_id int unsigned auto_increment primary key,
  name varchar(100)
) engine = innodb;

# Insert two or three departments 
insert into departments (
  name
) values ('finance');

insert into departments (
  name
) values ('sales');

insert into departments (
  name
) values ('HR');

# Adding multiple rows to a table
insert into departments (name) values ('accounting'), ('IT');

# Add a new column to an existing table
alter table employees add column name varchar(100);
ALTER TABLE employees RENAME COLUMN name TO first_name;
ALTER TABLE employees DROP COLUMN department_id;

# Add a foreign key between employees and departments
# Step 1: Add the column
# IMPORTANT: Data type of the foreign key MUST match the data type of the corresponding primary key
ALTER TABLE employees ADD COLUMN department_id int unsigned not null;

# Step 2: Indicate the newly added column to be a foreign key
# Note: We will not be able to add a foreign key if it makes any of the rows fail the constraint
alter table employees add constraint fk_employees_departments
  foreign key (department_id) references departments(department_id);

# Delete existing employee (so that we can now add in the foreign key)
delete from employees;

INSERT INTO employees (first_name, department_id, email, gender, notes, employment_date, designation) VALUES ('John Smith', 4, 'asd@asd.com', 'm', 'newbie', curdate(), 'intern');