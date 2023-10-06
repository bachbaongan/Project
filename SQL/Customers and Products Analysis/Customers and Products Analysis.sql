/*-- Project: Customers and Products Analysis Using SQL

Welcome to my project where I will be conducting data analysis on a scale model car database to extract KPI's in order to make smarter decisions.
analyze data from a sales records database for scale model cars and extract information for decision-making.
During this project, there are THREE questions we want to ask ourselves.
 
Question 1: Which products should we order more of or less of?
Question 2: How should we tailor marketing and communication strategies to customer behaviors?
Question 3: How much can we spend on acquiring new customers?

Within the clase model care database, we will be working with 8 tables.

The tables are as follows:

1. productslines table - this table contains product category data. The product line is the primary key. 
This table has a relationship with the product table on the product line column which is a one-to-many relationship.

2. products table - this table contains product data. The productCode is the primary key and productLine the foreign key. 
This table has a relationship with the productlines table on the productLine column which is a many-to-one relationship and 
the orderdetails table on the productCode column which is a one-to-one relationship.

3. orderdetails table - this table contains order details data. The orderNumber & productCode are the composite key. 
This table has a relationship with the products table productCode colum which is a one-to-one relationship and 
the order table on the orderNumber column which is a one-to-one relationship.

4. orders table - this table contains orders recieved data. The orderNumber is the primary key and the customerNumber is the foreign key. 
This table has a relationship with the orderdetails table on the orderNumber table which is a one-to-one relationship and 
the customer table on the customerNumber column which is a many-to-one relationship.

5. customers table - this table contains customer data. The customerNumber is the primary key and salesRepEmployeeNumber is the foreign key. 
This table has a relationship with the orders table on the customerNumber column which is a one-to-many relationship, 
the payments table on the customerNumber column which is a one-to-one relationship and 
the employees table on the employeeNumber column which is a many-to-one relationship.

6. payments table - this table contains payment data. The customerNumber & checkNumber are both the composite key. 
This table has a relationship with the customers table on the customerNumber column which is a one-to-one relationship.

7. employees table - this table contains employee data. The employeeNumber is the primary key and officeCode is the foreign key. 
This table has a self-referencing relationship between the employeeNumber and reportsTo columns which is a one-to-many relationship, 
 the customers table on the salesRepEmployeeNumber column which is a one-to- many relationship and 
 the offices table on teh officeCode column which is a many-to-one relationship.

8. offices table - this table contains office data. The officeCode is the primary Key. 
This table has a relationship with the employees table on the officeCode table which is a one-to-many relationship.

-- SQL queries I will be executing to analyse the tables:

*/

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
  
 /*Question 1: Which Products Should We Order More of or Less of? 
 To answer this question, we need to figure the quantity of low stock and product performance. 
 We will priority restock the product with high performance that are on the brick of being out of stock. */
  
 --the low stock for each product
SELECT productCode, 
	Round((SUM(quantityOrdered)*1.0/ ( SELECT quantityInStock 
										 FROM products as p
										WHERE p.productCode=od.productCode)), 2) as low_stock														
  FROM orderdetails as od
 GROUP BY productCode
 ORDER BY low_stock DESC
  LIMIT 10;
  
  --the product performance for each product 
  SELECT productCode, 
		 SUM(quantityOrdered*priceEach) as product_performance																
    FROM orderdetails 
  GROUP BY productCode
  ORDER BY product_performance DESC
     LIMIT 10;
	 
 -- Write a query to combine low stock and product performance queries using CTE to display priority products for restocking 
 --1--The table will include productCode and product_performance information
 
With low_stock_products as (
SELECT productCode, 
	   Round((SUM(quantityOrdered)*1.0/ ( SELECT quantityInStock 
											FROM products as p
										   WHERE p.productCode=od.productCode)), 2) as low_stock
  FROM orderdetails as od
 GROUP BY productCode
 ORDER BY low_stock DESC
  LIMIT 10
 )
  SELECT productCode, 
				   SUM(quantityOrdered*priceEach) as product_performance																
    FROM orderdetails 
 WHERE productCode IN (SELECT productCode
						FROM low_stock_products)	
  GROUP BY productCode
  ORDER BY product_performance DESC
     LIMIT 10;

 
--2--The table will include productCode,product name, productLine and product_performance
With low_stock_products as (
SELECT productCode, 
		Round((SUM(quantityOrdered)*1.0/ ( SELECT quantityInStock 
											 FROM products as p
										    WHERE p.productCode=od.productCode)), 2) as low_stock
  FROM orderdetails as od
 GROUP BY productCode
 ORDER BY low_stock 
  LIMIT 10
 )
  SELECT p.productCode, p.productName, p.productLine,
				   SUM(od.quantityOrdered*od.priceEach) as product_performance																
    FROM products as p
	 JOIN orderdetails as od ON p.productCode = od.productCode
 WHERE p.productCode IN (SELECT productCode 
						   FROM low_stock_products)	
  GROUP BY p.productCode
  ORDER BY product_performance DESC
     LIMIT 10;

/*Question 2: How Should We Match Marketing and Communication Strategies to Customer Behavior?
To answer this question, we need to determine the VIPs (who bring the most profit) and the less engaged (who bring the less profit). 
Then we gonna build the suitable promotion campaign for each group of customers. */
SELECT o.customerNumber, 
				 sum(od.quantityOrdered*(od.priceEach-p.buyPrice)) as profit
   FROM orders as o
    JOIN orderdetails as od ON o.orderNumber=od.orderNumber
    JOIN products as p ON od.productCode=p.productCode
 GROUP BY o.customerNumber
 ORDER BY profit DESC;

 --The Top five VIP customers
 WITH Profit_customer AS (
 SELECT o.customerNumber, 
				 sum(od.quantityOrdered*(od.priceEach-p.buyPrice)) as profit
   FROM orders as o
    JOIN orderdetails as od ON o.orderNumber=od.orderNumber
    JOIN products as p ON od.productCode=p.productCode
 GROUP BY o.customerNumber
 ORDER BY profit DESC
 )
 
 SELECT c.contactLastName, c.contactFirstName, c.city, c.country
   FROM customers as c
    JOIN Profit_customer as pc
	     ON c.customerNumber=pc.customerNumber
GROUP by pc.customerNumber
ORDER BY profit DESC
LIMIT 5;

 --The Top five least-engaged customers
  WITH Profit_customer AS (
 SELECT o.customerNumber, 
				 sum(od.quantityOrdered*(od.priceEach-p.buyPrice)) as profit
   FROM orders as o
    JOIN orderdetails as od ON o.orderNumber=od.orderNumber
    JOIN products as p ON od.productCode=p.productCode
 GROUP BY o.customerNumber
 ORDER BY profit DESC
 )
 
 SELECT c.contactLastName, c.contactFirstName, c.city, c.country
   FROM customers as c
    JOIN Profit_customer as pc
	     ON c.customerNumber=pc.customerNumber
GROUP by pc.customerNumber
ORDER BY profit ASC
LIMIT 5;
 
 /*Question 3: How Much Can We Spend on Acquiring New Customers? */
-- Write a query to compute the average of customer profits using the CTE on the previous screen.
-- Customer LTV(Lifeime Value)
  WITH 
  Profit_customer AS (
 SELECT o.customerNumber, 
				 sum(od.quantityOrdered*(od.priceEach-p.buyPrice)) as profit
   FROM orders as o
    JOIN orderdetails as od ON o.orderNumber=od.orderNumber
    JOIN products as p ON od.productCode=p.productCode
 GROUP BY o.customerNumber
 ORDER BY profit DESC
 )
 
 SELECT AVG(profit) as ltv
   FROM Profit_customer
   ;
   
  /* 
 Conclusion:
 
  Question 1: Which products should we order more of or less of?
  
    Answer 1: Analysing the query results of comparing low stock with product performance we can see that,
    6 out 10 cars belong to 'Classic Cars' product line, which we sell frequently with high product performance.
   Therefore, we should restocl "Classic Cars" properly.
		      
 
  Question 2: How should we tailor marketing and communication strategies to customer behaviors?
  
    Answer 2: Analysing the query results of top and bottom customers in terms of profit generation,
    we need to offer loyalty rewards and priority services for our top customers to retain them.
	Also for bottom customers we need to solicit feedback to better understand their preferences, 
    expected pricing, discount and offers to increase our sales
 
  Question 3: How much can we spend on acquiring new customers?
  
    Answer 3: The average customer liftime value of our store is $ 39,040. This means for every new customer we make profit of 39,040 dollars. 
	We can use this to predict how much we can spend on new customer acquisition, 
	at the same time maintain or increase our profit levels.
	          
  PROJECT END */  
