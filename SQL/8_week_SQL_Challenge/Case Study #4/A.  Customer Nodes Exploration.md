## A. Customer Nodes Exploration
### 1. How many unique nodes are there in the Data Bank system?
~~~~sql
SELECT COUNT(DISTINCT node_id) as number_node
FROM data_bank.customer_nodes;
~~~~
#### Output:
![Screenshot 2024-04-02 at 10 33 23 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/fd86ccab-5829-4693-a4a8-8a727c16a5d5)

* There are 5 unique nodes on the Data Bank system
### 2. What is the number of nodes per region?
~~~~sql
SELECT r.region_name, COUNT(DISTINCT cn.node_id) as number_node
FROM data_bank.customer_nodes cn
JOIN data_bank.regions as r ON cn.region_id = r.region_id
GROUP BY r.region_name
ORDER BY r.region_name;
~~~~
#### Output:
![Screenshot 2024-04-02 at 10 37 26 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/2a4956f6-db0b-4df0-98be-3f5782fb610f)

### 3. How many customers are allocated to each region?
~~~~sql
SELECT r.region_name, COUNT(cn.customer_id) as number_customer
FROM data_bank.customer_nodes cn
JOIN data_bank.regions as r ON cn.region_id = r.region_id
GROUP BY r.region_name
ORDER BY r.region_name;
~~~~
#### Output:
![Screenshot 2024-04-02 at 10 37 26 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/e5902be5-80ae-4074-bfb4-d92f88f54fc9)

### 4. How many days on average are customers reallocated to a different node?

~~~~sql
SELECT r.region_name, COUNT(cn.customer_id) as number_customer
FROM data_bank.customer_nodes cn
JOIN data_bank.regions as r ON cn.region_id = r.region_id
GROUP BY r.region_name
ORDER BY r.region_name;
~~~~
#### Output:
![Screenshot 2024-04-02 at 1 57 01 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/e602e991-7630-45d2-9b7d-b4ccc7efd6a0)

* On average, customers are reallocated to a different node every 15 days.
  
### 5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?
~~~~sql
WITH sub AS (
SELECT r.region_name, cn.end_date-cn.start_date as reallocation_days
FROM data_bank.customer_nodes cn
JOIN data_bank.regions as r ON cn.region_id = r.region_id
WHERE end_date !='9999-12-31'
)
SELECT sub.region_name, 
PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY sub.reallocation_days)  as median,
PERCENTILE_CONT(0.80) WITHIN GROUP(ORDER BY sub.reallocation_days)  as percentile_80,
PERCENTILE_CONT(0.95) WITHIN GROUP(ORDER BY sub.reallocation_days)  as percentile_95
FROM sub
GROUP BY sub.region_name;
~~~~
#### Output:
![Screenshot 2024-04-02 at 2 21 29 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/dd87fad8-d9b0-4201-bd86-5f20702baaad)
