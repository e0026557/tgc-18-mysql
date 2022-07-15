-- 1 - Find all the offices and display only their city, phone and country
SELECT city, phone, country FROM offices;

-- 2 - Find all rows in the orders table that mentions FedEx in the comments.
SELECT * FROM orders WHERE comments LIKE '%fedex%';

-- 3 - Show the contact first name and contact last name of all customers in descending order by the customer's name
-- Default sort is by ASC
SELECT contactFirstName, contactLastName, customerName FROM customers
ORDER BY customerName DESC;

-- 4 - Find all sales rep who are in office code 1, 2 or 3 and their first name or last name contains the substring 'son'
SELECT * FROM employees
WHERE jobTitle = 'sales rep'
AND officeCode < 4
AND (firstName LIKE '%son%'
OR lastName LIKE '%son%');

-- 5 - Display all the orders bought by the customer with the customer number 124, along with the customer name, the contact's first name and contact's last name.
SELECT orderNumber, customerName, contactFirstName, contactLastName FROM orders 
JOIN customers 
ON orders.customerNumber = customers.customerNumber;
WHERE orders.customerNumber = 124

-- 6 - Show the name of the product, together with the order details,  for each order line from the orderdetails table
SELECT productName, orderNumber, orders.productCode,	quantityOrdered,	priceEach,	orderLineNumber
FROM orderdetails JOIN
products ON orderdetails.productCode = products.productCode;