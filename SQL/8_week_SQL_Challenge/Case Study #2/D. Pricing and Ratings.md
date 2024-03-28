## D. Pricing and Ratings
### 1. If a Meat Lovers pizza costs $12 and a Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
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

~~~~
### Output:
