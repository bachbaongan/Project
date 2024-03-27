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
-- COMBINE topping name to hhave standard recipes for each type of pizza
SELECT cte.pizza_name, string_agg(topping_name,', ') as standard_topping
-- STRING_AGG(expression, delimiter): non-null input values concatenated into a string, separated by delimiter
FROM CTE
GROUP BY cte.pizza_name;
~~~~
### Output:
![cs2 cq1b](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/206e7f68-d257-49e7-a923-ebc722a9f829)
![cs2 cq1c](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/206b4fb1-aa7a-40f9-9fab-b457814c4550)



~~~~sql

~~~~
### Output:



~~~~sql

~~~~
### Output:



~~~~sql

~~~~
### Output:
