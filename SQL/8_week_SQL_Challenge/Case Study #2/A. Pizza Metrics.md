## A. Pizza Metrics
### 1. How many pizzas were ordered?
~~~~sql
SELECT COUNT(*) AS number_pizza_order
FROM Customer_orders_temp;
~~~~
### Output:
![cs2 aq1](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/171a5c9a-94fa-476c-9e08-9e4d2f9c57a0)

* Total of 14 pizzas were ordered

### 2. How many unique customer orders were made?
~~~~sql
SELECT COUNT( DISTINCT order_id) as unique_customer_order
FROM customer_orders_temp;
~~~~
### Output:
![cs2 aq2](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/fd5a6faf-6fe7-4618-92c1-bdc7d89de1ab)

* There are 10 unique customer orders

### 3. How many successful orders were delivered by each runner?
~~~~sql
SELECT runner_id, COUNT(order_id) as successful_orders
FROM runner_orders_temp
WHERE cancellation is null
GROUP BY runner_id;
~~~~
### Output:
![cs2 aq3](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/16ac1dcd-f049-4909-b30f-119e0a294fac)

* Runner 1 successfully delivered 4 orders
* Runner 2 successfully delivered 3 orders
* Runner 3 successfully delivered 1 order
  
### 4. How many of each type of pizza was delivered?
~~~~sql
SELECT pn.pizza_name, COUNT(c.order_id) as number_pizza
FROM customer_orders_temp as c
JOIN runner_orders_temp as r ON c.order_id=r.order_id
JOIN pizza_runner.pizza_names as pn ON c.pizza_id = pn.pizza_id
WHERE cancellation is null
GROUP BY pn.pizza_name;
~~~~
### Output:
![cs2 aq4](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/6a07d428-48e8-47b9-b7e5-9319c49ffd40)

* There are 3 Vegetarian and 9 Meatlovers delivered

### 5. How many Vegetarian and Meatlovers were ordered by each customer?
~~~~sql
SELECT c.customer_id, 
SUM(CASE WHEN pn.pizza_name ='Vegetarian' THEN 1 ELSE 0 END) as "Vegetarian_pizzas",
SUM(CASE WHEN pn.pizza_name ='Meatlovers' THEN 1 ELSE 0 END) as "Meatlovers_pizzas"
FROM customer_orders_temp as c
JOIN runner_orders_temp as r ON c.order_id=r.order_id
JOIN pizza_runner.pizza_names as pn ON c.pizza_id = pn.pizza_id
GROUP BY c.customer_id
ORDER BY c.customer_id;
~~~~
### Output:
![cs2 aq5](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/8ed2e41a-6e8f-401c-b2fb-bf5635ebc5d1)

* Customer 101 ordered 1 Vegetarian pizza and 2 Meatlovers pizzas
* Customer 102 ordered 1 Vegetarian pizzas and 2 Meatlovers pizzas
* Customer 103 ordered 1 Vegetarian pizza and 3 Meatlovers pizzas 
* Customer 104 ordered 3 Meatlovers pizza
* Customer 105 ordered 1 Vegetarian pizza

### 6. What was the maximum number of pizzas delivered in a single order?
~~~~sql
SELECT DISTINCT c.order_id, COUNT(pizza_id) as pizza_per_order, 
DENSE_RANK () OVER (ORDER BY COUNT(c.pizza_id) DESC) as rank
FROM customer_orders_temp as c
JOIN runner_orders_temp as r ON c.order_id=r.order_id
WHERE r.cancellation is null
GROUP BY c.order_id
ORDER BY rank ;
~~~~
### Output:
![cs2 aq6](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/b3d65af2-3647-4b5b-8d1e-b82fb20f99e1)
* Maximum number of pizzas delivered in a single order is 3 pizzas

### 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
~~~~sql
SELECT c.customer_id, 
SUM(CASE WHEN c.exclusions is not null or c.extras is not null THEN 1 ELSE 0 END ) AS at_least_1_change,
SUM(CASE WHEN c.exclusions is null and c.extras is null THEN 1 ELSE 0 END ) AS no_change
FROM customer_orders_temp as c
JOIN runner_orders_temp as r ON c.order_id=r.order_id
WHERE r.cancellation is null
GROUP BY c.customer_id
ORDER BY c.customer_id;
~~~~
### Output:
![cs2 aq7](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/8ab29a19-6c4a-4df6-8398-6d3708de7a1f)

* Customers 101 and 102 prefer the pizza with the original recipe
* Customer 103, 104 and 105 have their preference for pizza topping and requested at least 1 change (extra or exclusion topping) on their pizza

### 8. How many pizzas were delivered that had both exclusions and extras?  
~~~~sql
SELECT COUNT(c.pizza_id) as number_pizza_exclusions_extras
FROM customer_orders_temp as c
JOIN runner_orders_temp as r ON c.order_id=r.order_id
WHERE r.cancellation is null
AND c.exclusions is not null and c.extras is not null;
~~~~
### Output:
![cs2 aq8](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/adcb641e-9d91-4d93-b2e0-f1a6f78be0e2)

* Only 1 pizza delivered that had both extra and exclusion topping

### 9. What was the total volume of pizzas ordered for each hour of the day?
~~~~sql
SELECT EXTRACT(HOUR From order_time) as hour_of_day, COUNT(pizza_id) as number_pizza
FROM customer_orders_temp as c
GROUP BY EXTRACT(HOUR From order_time)
ORDER BY hour_of_day;
~~~~
### Output:
![cs2 aq9](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/79dc52d9-947c-4c69-b854-7e608994a4f1)

* Highest volume of pizza ordered is at 13 (1:00 pm), 18 (6:00 pm), 21 (9:00 pm) and 23 (11:00 pm)
* Lowest volume of pizza ordered is at 11 (11:00 am) and 19 (7:00 pm)

### 10. What was the volume of orders for each day of the week?
~~~~sql
SELECT TO_CHAR(order_time,'DAY') as day_of_week,  COUNT(pizza_id) as number_of_pizza
FROM customer_orders_temp as c
GROUP BY TO_CHAR(order_time,'DAY')
ORDER BY number_of_pizza DESC;
~~~~
### Output:
![cs2 aq10](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/db2e0845-6471-4c1f-a425-524f1a7e64ea)
* There are 5 pizzas ordered on Friday and Monday
* There are 3 pizzas ordered on Saturday
* There is 1 pizza ordered on Sunday
