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
