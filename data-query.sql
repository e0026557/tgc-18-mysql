-- Display all columns and all rows
-- '*' refers to all rows
SELECT * FROM employees;

-- SELECT <column name> FROM <table name>
SELECT customerName, phone, city FROM customers;

-- 'AS' to rename each column name (for reporting purposes)
SELECT first_name AS 'First Name', last_name AS 'Last Name' FROM employees;

-- Filter rows using 'WHERE'
SELECT * FROM employees WHERE officeCode = 1;

SELECT city, addressLine1, addressLine2, country FROM offices WHERE country = 'USA';

-- 'LIKE' for string matching (case insensitive for SQL)
SELECT * FROM employees WHERE jobTitle LIKE 'Sales Rep'

-- '%' is used as a wildcard
-- Find all employees where job title starts with 'Sales'
SELECT * FROM employees WHERE jobTitle LIKE 'Sales%'

-- Find all employees where job title ends with 'Sales'
SELECT * FROM employees WHERE jobTitle LIKE '%Sales'

-- Find all employees where job title has 'Sales' anywhere
SELECT * FROM employees WHERE jobTitle LIKE '%Sales%'

-- Filter using logical operators
-- AND (Priority over OR)
SELECT * FROM employees WHERE officeCode = '1' 
AND jobTitle = 'sales rep';

-- OR
SELECT * FROM employees WHERE officeCode = '1' 
OR officeCode = '2';

SELECT * FROM employees WHERE jobTitle LIKE 'sales' AND officeCode = '1' 
OR officeCode = '2';

SELECT * FROM employees WHERE jobTitle LIKE 'sales' AND (officeCode = '1' 
OR officeCode = '2');

SELECT country, state, creditLimit FROM customers WHERE (country = 'USA' 
AND state = 'NV' 
AND creditLimit > 5000)
OR creditLimit > 1000;

-- JOIN (Default is INNER JOIN)
SELECT * FROM employees JOIN offices 
ON employees.officeCode = offices.officeCode
WHERE country='usa';

-- only show customers with sales rep
SELECT customerName, firstName, lastName, email FROM customers
JOIN employees ON customers.salesRepEmployeeNumber = employees.employeeNumber;

-- Shows all customers with their sales rep info, regardless of whether customers have a sale rep or not
SELECT customerName, firstName, lastName, email FROM customers
LEFT JOIN employees ON customers.salesRepEmployeeNumber = employees.employeeNumber;

-- Shows all customers for all employees regardless of whether they have customers
SELECT customerName, firstName, lastName, email FROM customers
RIGHT JOIN employees ON customers.salesRepEmployeeNumber = employees.employeeNumber;

-- 3-way JOIN
SELECT customerName, firstName, lastName, offices.phone FROM customers JOIN employees
ON customers.salesRepEmployeeNumber = employees.employeeNumber
JOIN offices ON employees.officeCode = offices.officeCode;

SELECT customerName AS 'Customer Name', customers.country AS 'Customer Country', firstName, lastName, offices.phone FROM customers JOIN employees
ON customers.salesRepEmployeeNumber = employees.employeeNumber
JOIN offices ON employees.officeCode = offices.officeCode
WHERE customers.country='USA'

-- To differentiate which column to show if both tables have the same name
SELECT firstName, lastName, employees.officeCode, city FROM employees JOIN offices ON employees.officeCode = office.officeCode

-- AGGREGATION
SELECT COUNT(*) FROM customers;


