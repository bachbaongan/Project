# Project: Customers and Products Analysis Using SQL

In this project, I will be conducting data analysis on a scale model car database to extract key performance indicators (KPIs) to make smarter decisions, by answering **THREE questions**:

  * Question 1: Which products should we order more of or less of?
  * Question 2: How should we tailor marketing and communication strategies to customer behaviours?
  * Question 3: How much can we spend on acquiring new customers?

## The scale model cars database schema

Within the class model care database, we will be working with 8 tables.
![Scale model cars database](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/2e0ebeb6-f6a8-4e26-82c4-5da3596b8e4e)

  * Customers: customer data
  * Employees: all employee information
  * Offices: sales office information
  * Orders: customers' sales orders
  * OrderDetails: sales order line for each sales order
  * Payments: customers' payment records
  * Products: a list of scale model cars
  * ProductLines: a list of product line categories


## Database summary
~~~~sql
SELECT 'Customer' AS Table_name, 13 AS number_of_attributes, COUNT(*) AS number_of_row
FROM Customers
UNION ALL 
SELECT 'Products' AS Table_name, 9 AS number_of_attributes, COUNT(*) AS number_of_row
FROM products  
UNION ALL
SELECT 'ProductLines' AS Table_name, 4 AS number_of_attributes, COUNT(*) AS number_of_row
FROM productlines   
UNION ALL
SELECT 'Orders' AS Table_name, 7 AS number_of_attributes, COUNT(*) AS number_of_row
FROM orders
UNION ALL
SELECT 'Orderdetails' AS Table_name, 5 AS number_of_attributes, COUNT(*) AS number_of_row
FROM orderdetails 
UNION ALL
SELECT 'Payments' AS Table_name, 4 AS number_of_attributes, COUNT(*) AS number_of_row
FROM payments  
UNION ALL
SELECT 'Employees' AS Table_name, 8 AS number_of_attributes, COUNT(*) AS number_of_row
FROM employees    
UNION ALL
SELECT 'Offices' AS Table_name, 9 AS number_of_attributes, COUNT(*) AS number_of_row
FROM offices;
~~~~
#### Output:
<img width="330" alt="Summary database" src="https://github.com/bachbaongan/Portfolio_Data/assets/144385168/b9e81e19-588a-4a98-8185-880268924b84">

## Question and Solution:
### 1: Which products should we order more of or less of?
~~~~sql
-- Write a query to compute the low stock for each product using a correlated subquery  
SELECT productCode, Round((SUM(quantityOrdered)*1.0/ ( SELECT quantityInStock 
					               FROM products AS p
					               WHERE p.productCode=od.productCode)), 2) AS low_stock														
FROM orderdetails AS od
GROUP BY productCode
ORDER BY low_stock DESC
LIMIT 10;
  
-- Write a query to compute the product performance for each product.
SELECT productCode, SUM(quantityOrdered*priceEach) AS product_performance																
FROM orderdetails 
GROUP BY productCode
ORDER BY product_performance DESC
LIMIT 10;
	 
-- Write a query to combine low stock and product performance queries using CTE to display priority products for restocking 
With low_stock_products AS (
SELECT productCode, 
       Round((SUM(quantityOrdered)*1.0/ ( SELECT quantityInStock 
					  FROM products AS p
					  WHERE p.productCode=od.productCode)), 2) AS low_stock
FROM orderdetails AS od
GROUP BY productCode
ORDER BY low_stock 
LIMIT 10
)
SELECT p.productCode, p.productName, p.productLine,SUM(od.quantityOrdered*od.priceEach) as product_performance																
FROM products as p
JOIN orderdetails as od ON p.productCode = od.productCode
WHERE p.productCode IN (SELECT productCode 
			FROM low_stock_products)	
GROUP BY p.productCode
ORDER BY product_performance DESC
LIMIT 10;
~~~~
#### Output:
<img width="522" alt="Question 1" src="https://github.com/bachbaongan/Portfolio_Data/assets/144385168/6db3e27b-4c62-48f9-b3f8-7c33c920e65e">

Analyzing the query results of comparing low stock with product performance we can see that, 6 out of 10 cars belong to the 'Classic Cars' product line, 
which we sell frequently with high product performance. Therefore, we should restock "Classic Cars" properly.

### 2: How should we tailor marketing and communication strategies to customer behaviours?
~~~~sql
-- Write a query to find the Top five VIP customers
WITH Profit_customer AS (
SELECT o.customerNumber, sum(od.quantityOrdered*(od.priceEach-p.buyPrice)) AS profit
FROM orders AS o
JOIN orderdetails AS od ON o.orderNumber=od.orderNumber
JOIN products AS p ON od.productCode=p.productCode
GROUP BY o.customerNumber
ORDER BY profit DESC
)
SELECT c.contactLastName, c.contactFirstName, c.city, c.country
FROM customers AS c
JOIN Profit_customer AS pc ON c.customerNumber = pc.customerNumber
GROUP by pc.customerNumber
ORDER BY profit DESC
LIMIT 5;
~~~~
#### Output:
**Top 5 VIP customers**

 <img width="392" alt="Question 2 top 5 VIP" src="https://github.com/bachbaongan/Portfolio_Data/assets/144385168/ee285176-b94b-4de4-a0c0-5d1f8717b2bf">
~~~~sql
-- Write a query to find The Top five least-engaged customers
WITH Profit_customer AS (
SELECT o.customerNumber, sum(od.quantityOrdered*(od.priceEach-p.buyPrice)) AS profit
FROM orders AS o
JOIN orderdetails AS od ON o.orderNumber=od.orderNumber
JOIN products AS p ON od.productCode=p.productCode
GROUP BY o.customerNumber
ORDER BY profit DESC
)
SELECT c.contactLastName, c.contactFirstName, c.city, c.country
FROM customers AS c
JOIN Profit_customer AS pc ON c.customerNumber=pc.customerNumber
GROUP by pc.customerNumber
ORDER BY profit ASC
LIMIT 5;
~~~~

#### Output:
**Top 5 least-engaged customers**

<img width="385" alt="Question 2 top 5 worst" src="https://github.com/bachbaongan/Portfolio_Data/assets/144385168/3f162cb3-343c-4748-8be0-0d04613cdb97">

Analyzing the query results of top and bottom customers in terms of profit generation, we need to offer loyalty rewards and priority services for our top customers to retain them. Also for bottom customers, we need to solicit feedback to better understand their preferences, expected pricing, discounts and offers.

### 3: How much can we spend on acquiring new customers?
~~~~sql
WITH Profit_customer AS (
SELECT o.customerNumber, sum(od.quantityOrdered*(od.priceEach-p.buyPrice)) as profit
FROM orders as o
JOIN orderdetails as od ON o.orderNumber=od.orderNumber
JOIN products as p ON od.productCode=p.productCode
GROUP BY o.customerNumber
ORDER BY profit DESC
) 
SELECT AVG(profit) as ltv
FROM Profit_customer;
~~~~

#### Output: 
<img width="104" alt="Question 3" src="https://github.com/bachbaongan/Portfolio_Data/assets/144385168/39a2a286-315d-4868-b8c2-84108ac79082">

The average customer lifetime value of our store is $ 39,040. This means for every new customer we make a profit of 39,040 dollars. We can use this to predict how much we can spend on new customer acquisition, and at the same time maintain or increase our profit levels.
