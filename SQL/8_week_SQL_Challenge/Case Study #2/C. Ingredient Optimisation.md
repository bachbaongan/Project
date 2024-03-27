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

#### Topping name for each pizza type

![cs2 cq1b](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/206e7f68-d257-49e7-a923-ebc722a9f829)

#### Standard recipes for each type of pizza

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
  
### 4. Generate an order item for each record in the customers_orders table in the format of one of the following:

* Meat Lovers
* Meat Lovers - Exclude Beef
* Meat Lovers - Extra Bacon
* Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
  
~~~~sql

~~~~
### Output:

### 5. Generate an alphabetically ordered comma-separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
~~~~sql

~~~~
### Output:

### 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
~~~~sql

~~~~
### Output:
