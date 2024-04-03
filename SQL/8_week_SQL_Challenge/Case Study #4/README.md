# 🏦 Case Study #4 - Data Bank
![4](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/60d41653-653f-4f6f-926a-a7ef127e8c5c)

## 📖 Table of contents:

* [Business task](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%234/README.md#business-task)
* [Entity Relationship Diagram](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%234/README.md#entity-relationship-diagram)
* [Question and Solution](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%234/README.md#question-and-solution)

  * [A. Customer Nodes Exploration](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%234/README.md#a-customer-nodes-exploration)
  * [B. Customer Transactions](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%234/README.md#b-customer-transactions)
  * [C. Data Allocation Challenge](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%234/README.md#c-data-allocation-challenge)
  * [D. Extra Challenge](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%234/README.md#d-extra-challenge)
  * [E.Extension Request](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%234/README.md#eextension-request)
    
## Business task: 
Danny has introduced Data Bank, a novel endeavour that not only conducts banking operations but also serves as the globe's most impregnable distributed data storage solution.

Customers receive cloud data storage quotas that correlate directly with their account balances.

The Data Bank management team aims to expand their overall customer count while requiring assistance in monitoring the precise data storage requirements of its clientele.

This case study revolves around computing metrics, assessing growth, and aiding business in intelligently analyzing their data to enhance forecasting and strategizing for future advancements!

## Entity Relationship Diagram
![case-study-4-erd](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/c96c2bf2-d562-47c9-9d88-dad5a65b1ada)

## Question and Solution
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

## B. Customer Transactions
### 1. What is the unique count and total amount for each transaction type?
~~~~sql
SELECT txn_type, COUNT(*) as transaction_count,
SUM(txn_amount) as total_amount
FROM data_bank.customer_transactions
GROUP BY txn_type
ORDER BY txn_type;
~~~~
#### Output:
![Screenshot 2024-04-02 at 2 27 30 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/49a273de-c13b-40a8-ba8d-4b3412169fb2)

### 2. What is the average total historical deposit counts and amounts for all customers?
~~~~sql
WITH sub AS (
SELECT customer_id,txn_type, COUNT(*) as transaction_count,
SUM(txn_amount) as total_amount
FROM data_bank.customer_transactions
GROUP BY customer_id,txn_type
)
SELECT sub.txn_type, 
ROUND(AVG(sub.transaction_count),1) as average_deposit_count,
ROUND(AVG(sub.total_amount),2) as average_deposit_amount
FROM sub
WHERE sub.txn_type ='deposit'
GROUP BY sub.txn_type;
~~~~
#### Output:
![Screenshot 2024-04-02 at 2 38 21 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/9703fcce-42d7-426b-9d61-21cfdbd25e50)

### 3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?
~~~~sql
WITH SUB AS (
SELECT customer_id, EXTRACT(MONTH FROM txn_date) AS Month, 
SUM(CASE WHEN txn_type ='deposit' THEN 1 ELSE 0 END) as deposit_count,
SUM(CASE WHEN txn_type ='purchase' THEN 1 ELSE 0 END) as purchase_count,
SUM(CASE WHEN txn_type ='withdrawal' THEN 1 ELSE 0 END) as withdrawal_count
FROM data_bank.customer_transactions
GROUP BY EXTRACT(MONTH FROM txn_date), customer_id
ORDER BY month
)
SELECT sub.month, COUNT(DISTINCT sub.customer_id) as customer_count
FROM sub
WHERE deposit_count>1
AND (purchase_count >=1 OR withdrawal_count >=1)
GROUP BY sub.month;
~~~~
#### Output:
![Screenshot 2024-04-02 at 3 11 49 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/28d28430-eb7c-4184-99c3-da70e2d6ea8f)

### 4. What is the closing balance for each customer at the end of the month?
~~~~sql
--Transaction amount change as an inflow (+) or outflow (-)
WITH month_balances AS (
SELECT customer_id, (DATE_TRUNC('month', txn_date) + INTERVAL '1 MONTH - 1 DAY') AS close_of_month,
SUM(CASE WHEN txn_type ='deposit' THEN txn_amount ELSE -txn_amount END) as transaction_change_balance
FROM data_bank.customer_transactions
GROUP BY customer_id, txn_date
)
--Generate as a series of last day of the month for each customer.
, month_end_series as (
SELECT DISTINCT customer_id,
('2020-01-31'::DATE + GENERATE_SERIES(0,3) * INTERVAL '1 MONTH') AS end_of_month
FROM data_bank.customer_transactions
)
--Total monthly change for each month
, monthly_change AS (
SELECT month_end_series.customer_id,month_end_series.end_of_month,
SUM(month_balances.transaction_change_balance) as total_monthly_change
FROM month_end_series 
LEFT JOIN month_balances on month_balances.customer_id = month_end_series.customer_id
AND month_balances.close_of_month = month_end_series.end_of_month
GROUP BY month_end_series.customer_id,month_end_series.end_of_month 
ORDER BY month_end_series.customer_id,month_end_series.end_of_month 
)
--Final monthly statement with the closing balances
SELECT *, 
SUM(total_monthly_change) OVER (PARTITION BY customer_id
							    ORDER BY end_of_month
							    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
							   ) as total_closing_balance
FROM monthly_change;
~~~~
#### Output:
![Screenshot 2024-04-03 at 11 56 12 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/55b2db0f-0069-4b2f-aeb8-f86d8b7158f9)

### 5. What is the percentage of customers who increase their closing balance by more than 5%?
~~~~sql
--Transaction amount change as an inflow (+) or outflow (-)
WITH month_balances AS (
SELECT customer_id, (DATE_TRUNC('month', txn_date) + INTERVAL '1 MONTH - 1 DAY') AS close_of_month,
SUM(CASE WHEN txn_type ='deposit' THEN txn_amount ELSE -txn_amount END) as transaction_change_balance
FROM data_bank.customer_transactions
GROUP BY customer_id, (DATE_TRUNC('month', txn_date) + INTERVAL '1 MONTH - 1 DAY')
ORDER BY customer_id,close_of_month 
)
-- Monthly statement with the closing balances
, closing_balance AS (
SELECT customer_id, close_of_month,
SUM(transaction_change_balance) OVER (PARTITION BY customer_id
							    ORDER BY close_of_month
							    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
							   ) as total_closing_balance
FROM month_balances
)
-- Percentage modify in closing balance for each customer in each month
, percentage_growth AS (
SELECT *, 
100.0*(total_closing_balance -LAG(total_closing_balance) OVER (PARTITION BY customer_id ORDER BY close_of_month))
/NULLIF((LAG(total_closing_balance) OVER (PARTITION BY customer_id ORDER BY close_of_month)),0)
AS percentage
FROM closing_balance
)
-- Final percentage of customers who increase their closing balance by more than 5%
SELECT ROUND(100.0*COUNT(DISTINCT customer_id)/(SELECT COUNT(DISTINCT customer_id) FROM data_bank.customer_transactions),1)
 AS percentage_customer
FROM percentage_growth
WHERE percentage >5;
~~~~
#### Output:
![Screenshot 2024-04-03 at 12 31 27 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/512ef000-b781-4c0e-a684-47e0e49c343f)

## C. Data Allocation Challenge
To test out a few different hypotheses - the Data Bank team wants to run an experiment where different groups of customers would be allocated data using 3 different options:

* Option 1: data is allocated based on the amount of money at the end of the previous month
* Option 2: data is allocated on the average amount of money kept in the account in the previous 30 days
* Option 3: data is updated in real-time
For this multi-part challenge question - you have been requested to generate the following data elements to help the Data Bank team estimate how much data will need to be provisioned for each option:

* running customer balance column that includes the impact of each transaction
* customer balance at the end of each month
* minimum, average and maximum values of the running balance for each customer
Using all of the data available - how much data would have been required for each option monthly?
~~~~sql

~~~~
#### Output:

## D. Extra Challenge
Data Bank wants to try another option which is a bit more difficult to implement - they want to calculate data growth using an interest calculation, just like in a traditional savings account you might have with a bank.

If the annual interest rate is set at 6% and the Data Bank team wants to reward its customers by increasing their data allocation based on the interest calculated daily at the end of each day, how much data would be required for this option monthly?

Special notes:

* Data Bank wants an initial calculation which does not allow for compounding interest, however, they may also be interested in a daily compounding interest calculation so you can try to perform this calculation if you have the stamina!
~~~~sql

~~~~
#### Output:
## E. Extension Request
The Data Bank team wants you to use the outputs generated from the above sections to create a quick PowerPoint presentation which will be used as marketing materials for both external investors who might want to buy Data Bank shares and new prospective customers who might want to bank with Data Bank.

* Using the outputs generated from the customer node questions, generate a few headline insights that Data Bank might use to market its world-leading security features to potential investors and customers.
* With the transaction analysis - prepare a 1-page presentation slide which contains all the relevant information about the various options for the data provisioning so the Data Bank management team can make an informed decision.

~~~~sql

~~~~
#### Output:
