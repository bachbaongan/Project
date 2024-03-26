# 🍕Case Study #2 - Pizza Runner
![2](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/2a76e725-e079-44ed-9790-678ef0651712)

## 📖 Table of contents:

* [Business task](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%232/README.md#business-task)
* [Entity Relationship Diagram](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%232/README.md#entity-relationship-diagram)
* [Data Cleaning & Transformation](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%232/README.md#-data-cleaning--transformation)
* [Question and Solution](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%232/README.md#question-and-solution)

   *  [A. Pizza Metrics](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%232/README.md#a-pizza-metrics)
   *  [B. Runner and Customer Experience](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%232/README.md#b-runner-and-customer-experience)
   *  [C. Ingredient Optimisation](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%232/README.md#c-ingredient-optimisation)
   *  [D. Pricing and Ratings](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%232/README.md#d-pricing-and-ratings)
   *  [E. Bonus Questions](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%232/README.md#e-bonus-questions)  	

## Business task: 
Danny is expanding his new Pizza Empire and at the same time, he wants to Uberize it, so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

## Entity Relationship Diagram
![Pizza Runner](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/adbb7d47-6e4b-450b-b419-1d711adac42c)

## 🧹 Data Cleaning & Transformation
### Table: customer_orders
![Customer before](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/ec282ecd-8476-4ab3-9935-297eda0c09b9)

Create a temporary table with all the columns and remove incorrect values 
~~~~sql
CREATE TEMP TABLE customer_orders_temp AS 
SELECT order_id, customer_id, pizza_id, 
CASE WHEN exclusions LIKE 'null' or exclusions ='' THEN null -- Remove text 'null' and blank space and replace with null values
	 ELSE exclusions END as exclusions,
CASE WHEN extras LIKE 'null' or extras='' THEN null -- Remove text 'null' and blank space and replace with null values
	 ELSE extras END as extras,
order_time
FROM pizza_runner.customer_orders;
~~~~

#### Output new temporary table:
![customer after](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/804e5878-8c33-4764-9710-2a70b13f5d1a)

### Table: runner_orders
![runner before](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/c195265f-387c-4bb9-aa85-d8b87167837b)

Create a temporary table with all the columns and remove incorrect values 

~~~~sql
CREATE TEMP TABLE runner_orders_temp AS
SELECT order_id, runner_id,
CASE WHEN pickup_time LIKE 'null' THEN null -- Remove text 'null' and replace with null values
	 ELSE pickup_time END as pickup_time, 
CASE WHEN distance LIKE 'null' THEN null   -- Remove text 'null' and replace with null values
	 WHEN distance LIKE '%km' THEN TRIM('km' from distance)  --Remove "km" 
	 ELSE distance END AS distance,
CASE WHEN duration LIKE 'null' THEN null --Remove text 'null' and replace with null values
     WHEN duration LIKE '%minutes' THEN TRIM('minutes' FROM duration) --Remove "minutes" 
	 WHEN duration LIKE '%minute' THEN TRIM ('minute' FROM duration) --Remove "minute" 
	 WHEN duration LIKE '%mins' THEN TRIM ('mins' FROM duration) --Remove "mins" 
	 ELSE duration END AS duration,
CASE WHEN cancellation ='' or cancellation LIKE 'null' THEN null -- Remove text 'null' and blank space and replace with null values
	 ELSE cancellation END as cancellation
FROM pizza_runner.runner_orders
~~~~

Alter `pickup_time`, `distance` and `duration` to the correct data type

~~~~sql
ALTER TABLE runner_orders_temp ALTER COLUMN pickup_time TYPE timestamp USING (pickup_time::timestamp);
ALTER TABLE runner_orders_temp ALTER COLUMN distance TYPE numeric USING (distance::numeric);
ALTER TABLE runner_orders_temp ALTER COLUMN duration TYPE numeric USING (duration::numeric);
~~~~

#### Output new temporary table:
![runner after](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/32a8eb36-a6e6-418a-b966-c6a2b9b53b8a)

## Question and Solution
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

## B. Runner and Customer Experience
### 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
~~~~sql
SELECT weeks.week_start_date, 
ROUND(EXTRACT(epoch FROM (weeks.week_start_date - '2021-01-01'::DATE))/(3600*24*7),0)+1 as registration_week, 
COUNT(*) AS number_runner_signup
FROM (
SELECT generate_series('2021-01-01'::DATE, '2021-01-20'::DATE, '1 week'::Interval) AS week_start_date) as weeks
LEFT JOIN pizza_runner.runners as r ON r.registration_date >= weeks.week_start_date 
AND r.registration_date < weeks.week_start_date + '1 week'::Interval
GROUP BY weeks.week_start_date
ORDER BY weeks.week_start_date;
~~~~
### Output:
![cs2 bq1](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/5ff44cbe-41d6-44d3-9754-facd3602e4bf)

* There are 2 new runners signed up on Week 1 of Jan 2021
* There is 1 new runner signed up on Week 2 and 3 of Jan 2021

### 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
~~~~sql
SELECT r.runner_id, ROUND(AVG(EXTRACT(epoch FROM (r.pickup_time - c.order_time)/60)),0) as average_minute_pickup_time
FROM runner_orders_temp as r
JOIN customer_orders_temp as c ON c.order_id=r.order_id
WHERE r.distance!=0
GROUP BY r.runner_id
ORDER BY r.runner_id;
~~~~
### Output:
![cs2 bq2](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/72560c92-d182-4496-8f38-66adaedd11d0)

* It takes Runner 1 **16** minutes to pickup the order at the Pizza Runner HQ
* It takes Runner 2 **24** minutes to pickup the order at the Pizza Runner HQ
* It takes Runner 3 **10** minutes to pickup the order at the Pizza Runner HQ

### 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
~~~~sql
WITH prep_time AS (
SELECT r.order_id, COUNT(c.pizza_id) as number_of_pizza,c.order_time, r.pickup_time,
(EXTRACT(epoch FROM (r.pickup_time - c.order_time)/60)) as prepare_time
FROM runner_orders_temp as r
JOIN customer_orders_temp as c ON c.order_id=r.order_id
WHERE distance != 0 
GROUP BY r.order_id, c.order_time, r.pickup_time
)
SELECT number_of_pizza, ROUND(AVG(prepare_time),0) as average_prep_time
FROM prep_time
GROUP BY number_of_pizza
ORDER BY number_of_pizza;
~~~~
### Output:
![cs2 bq3](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/6081c8e3-101c-40f8-9973-1704033f752e)

* A single pizza order takes 12 minutes to prepare
* An order with 2 pizzas takes 18 minutes to prepare
* An order with 3 pizzas takes 29 minutes to prepare

### 4. What was the average distance travelled for each customer?
~~~~sql
SELECT c.customer_id, ROUND(avg(r.distance),1) as average_km_distance
FROM runner_orders_temp as r
JOIN customer_orders_temp as c ON c.order_id=r.order_id
WHERE distance != 0 
GROUP BY c.customer_id
ORDER BY c.customer_id;
~~~~
### Output:
![cs2 bq4](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/97bef24e-1452-4874-8185-00387213eae6)

* Customer 104 resides closest to Pizza Runner HQ, with an average distance of 10km, while Customer 105 resides farthest away, at 25km

### 5. What was the difference between the longest and shortest delivery times for all orders?
~~~~sql
SELECT max(duration)-min(duration) as different_delivery_times
FROM runner_orders_temp as r
WHERE duration != 0;
~~~~
### Output:
![cs2 bq5](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/8fad26fe-c095-44c9-86fa-923631af14d6)

* The difference between the longest and shortest delivery time for all orders is 30 minutes

### 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
~~~~sql
SELECT runner_id, order_id, 
ROUND(distance/(duration/60),1) as average_speed --Average_speed(km/h)
FROM runner_orders_temp as r
WHERE duration != 0 
ORDER BY runner_id, average_speed;
~~~~
### Output:
![cs2 bq6](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/9f3a30fc-c529-4f13-8d75-0028ec1990d4)

* Runner 1’s average speed ranges from 37.5km/h to 60km/h
* Runner 2’s average speed ranges from 35.1km/h to 93.6km/h
* Runner 3’s average speed is 40km/h

### 7. What is the successful delivery percentage for each runner?

~~~~sql
SELECT runner_id, 
ROUND(CAST(SUM(CASE WHEN duration is null THEN 0 ELSE 1 END) AS DECIMAL)/COUNT(*)*100,0) as percentage_success
FROM runner_orders_temp 
GROUP BY runner_id
ORDER BY runner_id;
~~~~
### Output:
![cs2 bq7](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/716590cb-4220-43e4-89be-aaed498bfa5f)

* Runner 1 has a 100% successful delivery.
* Runner 2 has a 75% successful delivery.
* Runner 3 has a 50% successful delivery
It's inaccurate to solely attribute successful delivery to runners since order cancellations are beyond the runner's control

## C. Ingredient Optimisation

~~~~sql

~~~~
### Output:
## D. Pricing and Ratings

~~~~sql

~~~~
### Output:
## E. Bonus Questions	


~~~~sql

~~~~
### Output:




