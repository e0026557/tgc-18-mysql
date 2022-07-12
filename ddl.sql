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
