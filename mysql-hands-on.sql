-- 1 - Find all the offices and display only their city, phone and country
SELECT city, phone, country FROM offices;

-- 2 - Find all rows in the orders table that mentions FedEx in the comments.
SELECT * FROM orders WHERE comments LIKE '%fedex%';

-- 3 - Show the contact first name and contact last name of all customers in descending order by the customer's name
-- Default sort is by ASC
SELECT contactFirstName, contactLastName, customerName FROM customers
ORDER BY customerName DESC;

-- 4 - Find all sales rep who are in office code 1, 2 or 3 and their first name or last name contains the substring 'son'
-- Note: Remember to use brackets for OR clauses because AND clauses will be evaluated first
SELECT * FROM employees
WHERE jobTitle = 'sales rep'
AND officeCode < 4
AND (firstName LIKE '%son%'
OR lastName LIKE '%son%');

-- 5 - Display all the orders bought by the customer with the customer number 124, along with the customer name, the contact's first name and contact's last name.
SELECT orders.orderNumber, customerName, contactFirstName, contactLastName FROM orders 
JOIN customers 
ON orders.customerNumber = customers.customerNumber
JOIN orderdetails 
ON orders.orderNumber = orderdetails.orderNumber
WHERE orders.customerNumber = 124;

-- 6 - Show the name of the product, together with the order details,  for each order line from the orderdetails table
SELECT productName, orderNumber, orders.productCode,	quantityOrdered,	priceEach,	orderLineNumber
FROM orderdetails JOIN
products ON orderdetails.productCode = products.productCode;

SELECT products.*, orderdetails.*
FROM orderdetails JOIN
products ON orderdetails.productCode = products.productCode;

-- 7 - Display sum of all the payments made by each company from the USA. 
SELECT customerName, SUM(amount) AS 'total_payments'
FROM payments
JOIN customers ON payments.customerNumber = customers.customerNumber
WHERE country = 'USA'
GROUP BY customerName

-- Grouping by customer number ensures that there are no issues when there are 2 customers with the same name
SELECT payments.customerNumber, customerName, SUM(amount)
FROM payments
JOIN customers ON payments.customerNumber = customers.customerNumber
GROUP BY payments.customerNumber, customerName

-- 8 - Show how many employees are there for each state in the USA
SELECT state, COUNT(*) AS 'employee_count'
FROM employees 
JOIN offices ON employees.officeCode = offices.officeCode
WHERE country = 'USA'
GROUP BY state


-- 9 - From the payments table, display the average amount spent by each customer. Display the name of the customer as well.
SELECT customerName, AVG(amount)
FROM payments
JOIN customers ON payments.customerNumber = customers.customerNumber
GROUP BY payments.customerNumber, customerName

-- 10 - From the payments table, display the average amount spent by each customer but only if the customer has spent a minimum of 10,000 dollars.
SELECT customerName, AVG(amount)
FROM payments
JOIN customers ON payments.customerNumber = customers.customerNumber
GROUP BY payments.customerNumber, customerName
HAVING SUM(amount) >= 10000

-- 11  - For each product, display how many times it was ordered, and display the results with the most orders first and only show the top ten.
SELECT productCode, COUNT(*)
FROM orderdetails
GROUP BY productCode
ORDER BY COUNT(*) DESC
LIMIT 10

SELECT productCode, COUNT(*) AS 'times_ordered'
FROM orderdetails
GROUP BY productCode
ORDER BY times_ordered DESC
LIMIT 10

-- 12 - Display all orders made between Jan 2003 and Dec 2003
SELECT *
FROM orders
WHERE orderDate BETWEEN '2003-01-01' AND '2003-12-31'

-- 13 - Display all the number of orders made, per month, between Jan 2003 and Dec 2003
SELECT MONTH(orderDate), COUNT(*)
FROM orders
WHERE orderDate BETWEEN '2003-01-01' AND '2003-12-31'
GROUP BY MONTH(orderDate)
