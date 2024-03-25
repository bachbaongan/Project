# 🍕Case Study #2 - Pizza Runner
![2](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/2a76e725-e079-44ed-9790-678ef0651712)
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


![cs2 aq1](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/171a5c9a-94fa-476c-9e08-9e4d2f9c57a0)

![cs2 aq2](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/fd5a6faf-6fe7-4618-92c1-bdc7d89de1ab)

![cs2 aq3](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/16ac1dcd-f049-4909-b30f-119e0a294fac)


![cs2 aq4](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/6a07d428-48e8-47b9-b7e5-9319c49ffd40)

![cs2 aq5](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/8ed2e41a-6e8f-401c-b2fb-bf5635ebc5d1)

![cs2 aq6](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/b3d65af2-3647-4b5b-8d1e-b82fb20f99e1)
![cs2 aq7](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/8ab29a19-6c4a-4df6-8398-6d3708de7a1f)
![cs2 aq8](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/adcb641e-9d91-4d93-b2e0-f1a6f78be0e2)
![cs2 aq9](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/79dc52d9-947c-4c69-b854-7e608994a4f1)
![cs2 aq10](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/db2e0845-6471-4c1f-a425-524f1a7e64ea)
