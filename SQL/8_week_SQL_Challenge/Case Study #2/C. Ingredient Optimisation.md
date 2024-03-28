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

### Another way faster to solve the question
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
	  CASE WHEN COUNT(sub.exclusions)>0 THEN ' - Exclude' ELSE '' END, STRING_AGG(sub.exclusions,', '),
	  CASE WHEN COUNT(sub.extras)>0 THEN ' - Extra' ELSE '' END, STRING_AGG(sub.extras,', ')
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

~~~~
### Output:

### 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
~~~~sql

~~~~
### Output:
