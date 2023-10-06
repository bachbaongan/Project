
-- Summary Number of attributes and Number of rows with each table using.
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

/* Question 1: Which Products Should We Order More of or Less of? */ 
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

/* Answer: Analysing the query results of comparing low stock with product performance we can see that, 6 out of 10 cars belong to the 'Classic Cars' product line, 
which we sell frequently with high product performance. Therefore, we should restock "Classic Cars" properly.*/

/*Question 2: How Should We Match Marketing and Communication Strategies to Customer Behavior? */
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

/* Answer: Analysing the query results of top and bottom customers in terms of profit generation, we need to offer loyalty rewards and priority services for our top 
customers to retain them. Also for bottom customers, we need to solicit feedback to better understand their preferences, expected pricing, discounts and offers to increase our sales.*/

/*Question 3: How Much Can We Spend on Acquiring New Customers? */
-- Write a query to compute the average of customer profits using the CTE on the previous screen.
-- Customer LTV(Lifetime Value)
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

/* Answer: The average customer lifetime value of our store is $ 39,040. This means for every new customer we make a profit of 39,040 dollars. We can use this to predict 
how much we can spend on new customer acquisition, and at the same time maintain or increase our profit levels.*/ 
 