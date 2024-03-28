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
### 1. What are the standard ingredients for each pizza?
~~~~sql
-- Create temporary pizza_recipes table where each row has pizza_id and its corresponding one topping id
CREATE TEMP TABLE pizza_recipes_temp AS (
SELECT pizza_id,
CAST(UNNEST(REGEXP_SPLIT_TO_ARRAY(toppings,',')) AS INTEGER) as topping_id 
-- UNNEST: ARRAY FUNCTION in POSTGRES which converts an ARRAY into columns
-- REGEXP_SPLIT_TO_ARRAY: convert this varchar list into an array 
FROM pizza_runner.pizza_recipes);
~~~~
### Output:
![cs2 cq1a](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/46213aec-3727-4329-90f2-97f07eaa70db)

~~~~sql
WITH CTE AS (
-- Find topping name for each pizza type
SELECT pn.pizza_name, pt.topping_name
FROM pizza_recipes_temp as prt 
JOIN pizza_runner.pizza_names as pn ON prt.pizza_id = pn.pizza_id
JOIN pizza_runner.pizza_toppings as pt ON pt.topping_id = prt.topping_id 
)
-- COMBINE topping name to have standard recipes for each type of pizza
SELECT cte.pizza_name, string_agg(topping_name,', ') as standard_topping
-- STRING_AGG(expression, delimiter): non-null input values concatenated into a string, separated by delimiter
FROM CTE
GROUP BY cte.pizza_name;
~~~~
### Output:

##### Topping name for each pizza type

![cs2 cq1b](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/206e7f68-d257-49e7-a923-ebc722a9f829)

##### Standard recipes for each type of pizza

![cs2 cq1c](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/206b4fb1-aa7a-40f9-9fab-b457814c4550)

### 2. What was the most commonly added extra?
~~~~sql
SELECT pt.topping_name, COUNT(sub.extra_topping_id) as topping_count
FROM (
	SELECT pizza_id, CAST(UNNEST(REGEXP_SPLIT_TO_ARRAY(extras,',')) AS INTEGER) as extra_topping_id 
	FROM customer_orders_temp ) as sub
JOIN pizza_runner.pizza_toppings pt ON pt.topping_id = sub.extra_topping_id
GROUP BY pt.topping_name
ORDER BY topping_count DESC;
~~~~
### Output:
![cs2 cq2](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/489dfb3a-34a4-4498-a978-b886adf14cd8)

* Bacon was the most commonly added extra

### 3. What was the most common exclusion?
~~~~sql
SELECT pt.topping_name, COUNT(sub.extra_topping_id) as topping_count
FROM (
	SELECT pizza_id, CAST(UNNEST(REGEXP_SPLIT_TO_ARRAY(extras,',')) AS INTEGER) as extra_topping_id 
	FROM customer_orders_temp ) as sub
JOIN pizza_runner.pizza_toppings pt ON pt.topping_id = sub.extra_topping_id
GROUP BY pt.topping_name
ORDER BY topping_count DESC;
~~~~
### Output:
![cs2 cq3](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/b3994a58-1f51-4c9c-a1dc-89e70d7dceb4)

* Cheese was the most common exclusion
  
### 4. Generate an order item for each record in the `customers_orders` table in the format of one of the following:

* Meat Lovers
* Meat Lovers - Exclude Beef
* Meat Lovers - Extra Bacon
* Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

#### Create a temporary table `Order_item_note` containing exclusions and extra notes for each pizza/order 
~~~~sql
CREATE TEMP TABLE Order_item_note AS (
-- Exclusion Notes Table		
SELECT cte.order_id, cte.pizza_id, cte.pizza_name, 
string_agg(CAST(cte.exclusion_topping_id AS VARCHAR),', ') as exclusions,
null as extras,
CONCAT('Exclude ',(string_agg(cte.topping_name,', '))) as note
FROM (
	SELECT sub.order_id, sub.pizza_id, sub.pizza_name, sub.exclusion_topping_id, pt.topping_name,
	COUNT(DISTINCT sub.exclusion_topping_id) as cnt
	FROM (
		SELECT c.order_id, c.pizza_id, pn.pizza_name, 
		CAST(UNNEST(REGEXP_SPLIT_TO_ARRAY(exclusions,',')) AS INTEGER) as exclusion_topping_id
		FROM customer_orders_temp as c
		JOIN pizza_runner.pizza_names as pn ON c.pizza_id = pn.pizza_id )as sub
	JOIN pizza_runner.pizza_toppings pt ON pt.topping_id = sub.exclusion_topping_id
	GROUP BY sub.order_id, sub.pizza_id, sub.exclusion_topping_id,sub.pizza_name, pt.topping_name
	ORDER BY sub.order_id, sub.pizza_id) as cte
GROUP BY cte.order_id, cte.pizza_id, cte.pizza_name

UNION ALL
-- Extra Notes Table
SELECT cte.order_id, cte.pizza_id, cte.pizza_name, 
null as exclusions,
string_agg(CAST(cte.extra_topping_id AS VARCHAR),', ') as extras,
CONCAT('Extra ',(string_agg(cte.topping_name,', '))) as note
FROM (
	SELECT sub.order_id, sub.pizza_id, sub.pizza_name, sub.extra_topping_id, pt.topping_name,
	COUNT(DISTINCT sub.extra_topping_id) as cnt
	FROM (
		SELECT c.order_id, c.pizza_id, pn.pizza_name, 
		CAST(UNNEST(REGEXP_SPLIT_TO_ARRAY(extras,',')) AS INTEGER) as extra_topping_id
		FROM customer_orders_temp as c
		JOIN pizza_runner.pizza_names as pn ON c.pizza_id = pn.pizza_id )as sub
	JOIN pizza_runner.pizza_toppings pt ON pt.topping_id = sub.extra_topping_id
	GROUP BY sub.order_id, sub.pizza_id, sub.extra_topping_id,sub.pizza_name, pt.topping_name
	ORDER BY sub.order_id, sub.pizza_id) as cte
GROUP BY cte.order_id, cte.pizza_id, cte.pizza_name);
~~~~
### Output:

##### Exclusion Notes Table
![cs2 cq4 a](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/c7e63c06-dec5-47ef-92bc-cbb2a202c379)

##### Extra Notes Table
![cs2 cq4b](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/4c73e701-9f19-46c2-b537-6230b2823a77)

##### Order_item_note Table
![cs2 cq4c](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/e1c9b33e-623a-42fa-8bf6-307eb3521690)

#### Combine all the information requested to `customer_orders`
~~~~sql
WITH special_note AS (
SELECT order_id, pizza_id, pizza_name,
STRING_AGG(exclusions,'') as exclusions,
STRING_AGG(extras,'') as extras,
CONCAT(pizza_name, ' - ', (string_agg(note, ' - '))) as order_item
FROM Order_item_note
GROUP BY order_id, pizza_id, pizza_name
ORDER BY order_id, pizza_id
)
SELECT c.order_id, c.pizza_id, pn.pizza_name,c.exclusions, c.extras, 
CASE WHEN c.exclusions IS NULL AND c.extras IS NULL THEN pn.pizza_name
ELSE special_note.order_item END as order_item
FROM customer_orders_temp c
JOIN pizza_runner.pizza_names as pn ON pn.pizza_id = c.pizza_id
LEFT JOIN special_note 
ON special_note.order_id = c.order_id 
AND special_note.pizza_id = c.pizza_id
AND (special_note.exclusions=c.exclusions
OR special_note.extras = c.extras)
ORDER BY c.ordeR_id, c.pizza_id;
~~~~
### Output:
![cs2 cq4d](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/61297657-3c29-47c5-8902-9d949f9f18aa)

### ⭐ Another way faster to solve the question
~~~~sql
WITH row_add AS (
--To keep the original order of all rows in the table
SELECT *, ROW_NUMBER () OVER () as row 
FROm customer_orders_temp
)
, sub as (
-- Find the name of exclusion and extra toping for each order/pizza
SELECT row, ra.order_id, pn.pizza_name, --
CASE WHEN ra.exclusions is not null 
AND pt.topping_id  IN ( SELECT CAST(UNNEST(REGEXP_SPLIT_TO_ARRAY(ra.exclusions,',')) AS INTEGER)) 
THEN pt.topping_name END AS exclusions,
CASE WHEN ra.extras is not null 
AND pt.topping_id  IN ( SELECT CAST(UNNEST(REGEXP_SPLIT_TO_ARRAY(ra.extras,',')) AS INTEGER)) 
THEN pt.topping_name END AS extras												
FROM pizza_runner.pizza_toppings as pt,
row_add as ra
JOIN pizza_runner.pizza_names as pn ON ra.pizza_id = pn.pizza_id
)
-- Convert and combine all the Exclusion and Extra to string to get final output
SELECT sub.order_id, 
CONCAT(sub.pizza_name,'', 
	  CASE WHEN COUNT(sub.exclusions)>0 THEN ' - Exclude ' ELSE '' END, STRING_AGG(sub.exclusions,', '),
	  CASE WHEN COUNT(sub.extras)>0 THEN ' - Extra ' ELSE '' END, STRING_AGG(sub.extras,', ')
	  ) AS pizza_order_items_note
FROM sub
GROUP BY sub.order_id, sub.pizza_name, sub.row
ORDER BY sub.row;
~~~~
### Output:
![Screenshot 2024-03-28 at 11 25 16 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/33fba57a-053e-4041-aea1-9000b3487882)


### 5. Generate an alphabetically ordered comma-separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
~~~~sql
WITH row_add AS (
SELECT *, ROW_NUMBER () OVER () as row
FROm customer_orders_temp
)
, sub AS (
SELECT row, ra.order_id, pn.pizza_name,pt.topping_name,
CASE WHEN ra.exclusions is not null 
	 AND pt.topping_id  IN ( SELECT CAST(UNNEST(REGEXP_SPLIT_TO_ARRAY(ra.exclusions,',')) AS INTEGER)) 
	 THEN 0 ELSE 
		CASE WHEN pt.topping_id  IN ( SELECT CAST(UNNEST(REGEXP_SPLIT_TO_ARRAY(pr.toppings,',')) AS INTEGER)) 
		THEN COUNT(pt.topping_name) ELSE 0 END 
END AS count_topping,
CASE WHEN ra.extras is not null 
AND pt.topping_id  IN ( SELECT CAST(UNNEST(REGEXP_SPLIT_TO_ARRAY(ra.extras,',')) AS INTEGER)) 
THEN COUNT(pt.topping_name) ELSE 0 END AS count_extra
FROM row_add as ra,
pizza_runner.pizza_toppings as pt,
pizza_runner.pizza_recipes as pr
JOIN pizza_runner.pizza_names as pn ON pr.pizza_id = pn.pizza_id
WHERE ra.pizza_id = pn.pizza_id
GROUP BY pn.pizza_name, ra.row, ra.order_id, ra.exclusions, ra.extras,pt.topping_id, pr.toppings,pt.topping_name
)
,final_ingredient  AS (
SELECT sub.row, sub.order_id, sub.pizza_name, 
CONCAT(CASE WHEN (SUM(sub.count_topping)+SUM(count_extra))>1 THEN (SUM(sub.count_topping)+SUM(count_extra))||'x' END,
	   topping_name) AS topping_name
FROM sub
WHERE count_topping>0 OR count_extra>0
GROUP BY sub.pizza_name, sub.row, sub.order_id, sub.topping_name
)
SELECT fn.order_id, 
CONCAT(fn.pizza_name,': ', STRING_AGG(fn.topping_name,', ' ORDER BY fn.topping_name)) AS all_ingredients
FROM final_ingredient as fn
GROUP BY fn.pizza_name, fn.row, fn.order_id
ORDER BY fn.row;
~~~~
### Output:
![Screenshot 2024-03-28 at 12 34 10 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/2cc5b3b3-0cf2-4257-97ab-577fe57361b1)

### 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
~~~~sql
WITH row_add AS (
SELECT c.*, ROW_NUMBER () OVER () as row
FROm customer_orders_temp c
JOIN runner_orders_temp r ON  c.order_id=r.order_id
WHERE distance !=0
)
, SUB AS (
SELECT row, ra.order_id, pn.pizza_name,pt.topping_name,
CASE WHEN ra.exclusions is not null 
	 AND pt.topping_id  IN ( SELECT CAST(UNNEST(REGEXP_SPLIT_TO_ARRAY(ra.exclusions,',')) AS INTEGER)) 
	 THEN 0 ELSE 
		CASE WHEN pt.topping_id  IN ( SELECT CAST(UNNEST(REGEXP_SPLIT_TO_ARRAY(pr.toppings,',')) AS INTEGER)) 
		THEN COUNT(pt.topping_name) ELSE 0 END 
END AS count_topping,
CASE WHEN ra.extras is not null 
AND pt.topping_id  IN ( SELECT CAST(UNNEST(REGEXP_SPLIT_TO_ARRAY(ra.extras,',')) AS INTEGER)) 
THEN COUNT(pt.topping_name) ELSE 0 END AS count_extra
FROM row_add as ra,
pizza_runner.pizza_toppings as pt,
pizza_runner.pizza_recipes as pr
JOIN pizza_runner.pizza_names as pn ON pr.pizza_id = pn.pizza_id
WHERE ra.pizza_id = pn.pizza_id
GROUP BY pn.pizza_name, ra.row, ra.order_id, ra.exclusions, ra.extras,pt.topping_id, pr.toppings,pt.topping_name
)
SELECT sub.topping_name,
(SUM(sub.count_topping)+SUM(count_extra)) as ingredient_amount
FROM sub
GROUP BY sub.topping_name
ORDER BY ingredient_amount DESC;
~~~~
### Output:
![Screenshot 2024-03-28 at 12 43 54 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/16104ae0-df88-4e68-a23d-977e7ac4a8cb)

## D. Pricing and Ratings
### 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
~~~~sql
WITH sub as (
SELECT r.runner_id, 
CASE WHEN pn.pizza_name = 'Meatlovers' THEN COUNT(r.order_id) * 12 ELSE COUNT(r.order_id) *10 END as total_income
FROM runner_orders_temp r
JOIN customer_orders_temp c ON r.order_id = c.order_id
JOIN pizza_runner.pizza_names pn ON c.pizza_id = pn.pizza_id
WHERE r.distance!=0
GROUP BY r.runner_id, pn.pizza_name
ORDER BY r.runner_id
)
,runner_income AS (
	-- Each Runner Income Table
SELECT sub.runner_id, sum(total_income) as total_income
FROM SUB
GROUP BY sub.runner_id
)
	-- Total Runner Income Table
SELECT SUM(total_income) as total_runner_income
FROM runner_income;
~~~~
### Output:
#### Each Runner Income Table
![Screenshot 2024-03-28 at 2 30 09 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/4ddb3049-b0ce-46a6-b0e1-250e9f580792)

#### Total Runner Income Table
![Screenshot 2024-03-28 at 2 31 19 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/83903791-8045-4c51-8f01-020b8520e712)

### 2. What if there was an additional $1 charge for any pizza extras? Add cheese is $1 extra
~~~~sql
WITH sub as (
SELECT r.runner_id, 
CASE WHEN pn.pizza_name = 'Meatlovers' THEN COUNT(r.order_id) * 12 ELSE COUNT(r.order_id) *10 END as total_income
FROM runner_orders_temp r
JOIN customer_orders_temp c ON r.order_id = c.order_id
JOIN pizza_runner.pizza_names pn ON c.pizza_id = pn.pizza_id
WHERE r.distance!=0
GROUP BY r.runner_id, pn.pizza_name
ORDER BY r.runner_id
)
,runner_income AS (
SELECT sub.runner_id, sum(total_income) as total_income
FROM SUB
GROUP BY sub.runner_id
)
,runner_extra AS (
SELECT e.runner_id, COUNT(e.order_id) as total_extras
FROM (
	SELECT r.*, CAST(UNNEST(REGEXP_SPLIT_TO_ARRAY(c.extras,',')) AS INTEGER)
	FROM customer_orders_temp c
	JOIN runner_orders_temp r ON r.order_id = c.order_id
	WHERE r.distance!=0
	AND c.extras IS NOT NULL
	) e
GROUP BY e.runner_id
)
, final_income AS (
	-- Total Income and Extra for each runner
SELECT ri.runner_id, ri.total_income, ra.total_extras,sum(ri.total_income) + sum(ra.total_extras *1) as total_income_extra
FROM runner_income ri
JOIN runner_extra ra ON ri.runner_id=ra.runner_id
GROUP BY ri.runner_id, ri.total_income, ra.total_extras
	)
	-- Total Income and Extra for all runners
SELECT sum(final_income.total_income) + sum(final_income.total_extras *1) as total_income_extra_all_runners
FROM final_income;
~~~~
### Output:
#### Total Income and Extra for each runner
![Screenshot 2024-03-28 at 2 49 40 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/5dcc30c8-8747-4904-9108-e61a79d3e403)

#### Total Income and Extra for all runners
![Screenshot 2024-03-28 at 2 49 56 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/5ef77fe5-6be3-4295-abf7-3313e4df32e6)

### 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
~~~~sql
SET
  search_path = pizza_runner;
DROP TABLE IF EXISTS runner_rating;
CREATE TABLE runner_rating (
    "id" SERIAL PRIMARY KEY,
    "order_id" INTEGER,
    "customer_id" INTEGER,
    "runner_id" INTEGER,
    "rating" INTEGER,
    "rating_time" TIMESTAMP
  );
INSERT INTO
  runner_rating (
    "order_id",
    "customer_id",
    "runner_id",
    "rating",
    "rating_time"
  )
VALUES
  ('1', '101', '1', '5', '2021-01-01 19:33:53'),
  ('2', '101', '1', '4', '2021-01-01 20:25:12'),
  ('3', '102', '1', '4', '2021-01-03 10:14:51'),
  ('4', '103', '2', '3', '2021-01-04 16:46:25'),
  ('5', '104', '3', '5', '2021-01-08 23:08:44'),
  ('7', '105', '2', '2', '2021-01-08 23:53:35'),
  ('8', '102', '2', '3', '2021-01-10 12:34:26'),
  ('10', '104', '1', '5', '2021-01-11 20:02:35');
~~~~

### 4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?

* customer_id
* order_id
* runner_id
* rating
* order_time
* pickup_time
* Time between order and pickup
* Delivery duration
* Average speed
* Total number of pizzas

~~~~sql
SELECT c.customer_id, c.order_id, r.runner_id, rr.rating, c.order_time, r.pickup_time, 
r.pickup_time-c.order_time as time_between_order_pickup, 
r.duration as delivery_duration, 
ROUND(AVG(r.distance/(r.duration/60)),2) as average_speed,
COUNT(c.pizza_id) as total_number_pizza
FROM runner_rating rr
JOIN runner_orders_temp r on rr.runner_id =r.runner_id
JOIN customer_orders_temp c ON c.order_id = r.order_id
WHERE r.duration !=0
GROUP BY c.customer_id, c.order_id, r.runner_id, rr.rating, c.order_time, r.pickup_time,r.duration 
ORDER BY c.customer_id
~~~~
### Output:
![Screenshot 2024-03-28 at 3 13 23 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/26cd7b8b-e8b2-4dad-bb55-941dd5cbb999)


### 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
~~~~sql
WITH sub as (
SELECT r.runner_id, 
CASE WHEN pn.pizza_name = 'Meatlovers' THEN COUNT(r.order_id) * 12 ELSE COUNT(r.order_id) *10 END as total_income
FROM runner_orders_temp r
JOIN customer_orders_temp c ON r.order_id = c.order_id
JOIN pizza_runner.pizza_names pn ON c.pizza_id = pn.pizza_id
WHERE r.distance!=0
GROUP BY r.runner_id, pn.pizza_name
ORDER BY r.runner_id
)
,runner_income AS (
SELECT sub.runner_id, sum(total_income) as total_income
FROM SUB
GROUP BY sub.runner_id
)
,runner_km_paid AS (
SELECT rp.runner_id,sum(rp.runner_km_paid) as total_runner_km_paid
FROM (
		SELECT r.*, r.distance*0.3 as runner_km_paid
		FROM customer_orders_temp c
		JOIN runner_orders_temp r ON r.order_id = c.order_id
		WHERE r.distance!=0
		
	) rp
GROUP BY rp.runner_id
)
,final_income AS (
	-- Total Income after km paid for each runner
SELECT ri.runner_id, ri.total_income, rkp.total_runner_km_paid,sum(ri.total_income) - sum(rkp.total_runner_km_paid) as total_income_after_km_paid
FROM runner_income ri
JOIN runner_km_paid rkp ON ri.runner_id=rkp.runner_id
GROUP BY ri.runner_id, ri.total_income, rkp.total_runner_km_paid
	)
	-- Total Income after km paid for all runners
SELECT sum(total_income_after_km_paid) as total_income_after_km_paid_all_runners
FROM final_income;
~~~~
### Output:
#### Total Income after km paid for each runner
![Screenshot 2024-03-28 at 3 20 49 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/df5844fe-0f99-44d6-ab79-4dc8fce7c149)

#### Total Income after km paid for all runners
![Screenshot 2024-03-28 at 3 21 21 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/0dcff748-cb55-4b1a-9b99-673f4e9a2db6)


## E. Bonus Questions	


~~~~sql

~~~~
### Output:




