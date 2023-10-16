-- Get to know the data
--
SELECT *
FROM customers
LIMIT 5;

SELECT *
FROM orders
LIMIT 5;

SELECT *
FROM order_details
LIMIT 5;

SELECT *
FROM products
LIMIT 5;

SELECT *
FROM employees;


-- Combine orders and employees tables to see who is responsible for each other:
SELECT CONCAT(e.first_name, ' ',e.last_name) AS employee_name,
       o.order_id,
       o.order_date
FROM employees AS e
JOIN orders AS o ON e.employee_id = o.employee_id
ORDER BY order_date DESC
LIMIT 20;

-- Combine orders and customers tables to get more detailed information about each customer:
SELECT o.order_id, c.company_name, c.contact_name, o.order_date
FROM customers AS c
JOIN orders AS o ON c.customer_id = o.customer_id
LIMIT 10;

-- Combine order_details, products, and orders to get detailed order information including the product name and quantity:
SELECT o.order_id, p.product_name, od.quantity, o.order_date
FROM order_details od
JOIN products p ON od.product_id = p.product_id
JOIN orders o ON od.order_id = o.order_id
LIMIT 10;


-- Ranking Employee Sales Performance
--
WITH employee_sale AS (
SELECT e.employee_id, e.first_name, e.last_name,
       SUM(od.unit_price * od.quantity * (1-od.discount)) AS total_sale
FROM orders AS o
JOIN order_details AS od ON o.order_id = od.order_id
JOIN employees AS e ON o.employee_id = e.employee_id
GROUP BY e.employee_id
)
SELECT employee_id, first_name, last_name, 
       ROUND(total_sale, 2) AS total_sale,
       RANK() OVER (ORDER BY total_sale DESC) AS sale_rank
FROM employee_sale;


-- Monthly sales
--
WITH monthly_sale AS (
SELECT EXTRACT(month from o.order_date) AS Month,
	   EXTRACT(year from o.order_date) AS Year,
       SUM(od.unit_price * od.quantity * (1-od.discount)) AS total_sale
FROM orders AS o 
JOIN order_details AS od ON o.order_id = od.order_id
GROUP BY EXTRACT(year from o.order_date),EXTRACT(month from o.order_date)
)
SELECT month as Month,
       SUM(total_sale) OVER (ORDER BY month) AS "Monthly Sales"
FROM monthly_sale
ORDER BY month;


-- Month-Over-Month Sales Growth
--
WITH monthly_sale AS (
SELECT EXTRACT(month from o.order_date) AS Month,
	   EXTRACT(year from o.order_date) AS Year,
       SUM(od.unit_price * od.quantity * (1-od.discount)) AS total_sale
FROM orders AS o 
JOIN order_details AS od ON o.order_id = od.order_id
GROUP BY EXTRACT(year from o.order_date),EXTRACT(month from o.order_date)
),
lagged_sale AS (
SELECT month, year, total_sale,
       LAG(total_sale) OVER (ORDER BY year,month) AS previous_month_sale
FROm monthly_sale
)
SELECT Year, Month,
       ((total_sale - previous_month_sale)/previous_month_sale)* 100 AS "Growth Rate"
FROM lagged_sale;
	

-- Identifying High-Value Customers
--
WITH order_value AS (
SELECT o.customer_id, o.order_id, 
       SUM(od.unit_price * od.quantity *(1-od.discount)) AS "Order Value"
FROM orders AS o
JOIN order_details AS od ON o.order_id = od.order_id
GROUP BY o.customer_id, o.order_id
)
SELECT customer_id, order_id, "Order Value",
       CASE WHEN "Order Value" > AVG("Order Value") OVER () THEN 'Above Average'
            ELSE 'Below Average'
            END AS "Value Category"
FROM order_value
LIMIT 10;
       
-- Percentage of Sales for Each Category
--
WITH category_sale AS (
SELECT c.category_id, c.category_name,
       SUM(od.unit_price * od.quantity * (1-od.discount)) AS total_sale
FROM categories as c
JOIN products as p ON c.category_id = p.category_id
JOIN order_details as od ON p.product_id = od.product_id
GROUP BY c.category_id
)
SELECT category_id, category_name,
       total_sale/SUM(total_sale) OVER () * 100 AS sale_percentage
FROM category_sale;


-- Top 3 Products Per Category
--
WITH product_sale AS (
SELECT p.category_id, p.product_id, p.product_name,
       SUM(od.unit_price * od.quantity * (1-od.discount)) AS total_sale
FROM products AS p
JOIN order_details AS od ON p.product_id = od.product_id
GROUP BY p.category_id, p.product_id
)
SELECT category_id, product_id, product_name, total_sale
FROM ( SELECT category_id, product_id, product_name, total_sale,
              ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY total_sale DESC) AS rn
	   FROM product_sale 
       ) AS subtab
WHERE rn <=3;
	

