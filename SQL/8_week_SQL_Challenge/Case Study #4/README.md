# 🏦 Case Study #4 - [Data Bank](https://8weeksqlchallenge.com/case-study-4/)
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

This [case study](https://8weeksqlchallenge.com/case-study-4/) revolves around computing metrics, assessing growth, and aiding business in intelligently analyzing their data to enhance forecasting and strategizing for future advancements!

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
-- Percentage modification in closing balance for each customer in each month
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

~~~~sql
SELECT customer_id, txn_date,txn_type, txn_amount,
SUM( CASE WHEN txn_type = 'deposit' THEN txn_amount
   		  WHEN txn_type = 'purchase' or txn_type = 'withdrawal' THEN -txn_amount 
		  ELSE 0 END) 
	OVER (PARTITION BY customer_id ORDER BY txn_date) as running_balance
FROM data_bank.customer_transactions;
~~~~

#### Output:
*Kindly note that this is not the entire output. The entire output is long and would take up space.*
![Screenshot 2024-04-03 at 5 35 01 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/f8aecd6b-1135-40f2-b48f-6fb2eec6ccb8)

* customer balance at the end of each month

~~~~sql
SELECT customer_id, EXTRACT(MONTH from txn_date) as month,
SUM(CASE WHEN txn_type = 'deposit' THEN txn_amount
   		  WHEN txn_type = 'purchase' or txn_type = 'withdrawal' THEN -txn_amount 
		  ELSE 0 END)  as closing_balance
FROM data_bank.customer_transactions
GROUP BY customer_id, EXTRACT(MONTH from txn_date)
ORDER BY customer_id, EXTRACT(MONTH from txn_date);
~~~~
#### Output:
*Kindly note that this is not the entire output. The entire output is long and would take up space.*
![Screenshot 2024-04-03 at 4 35 20 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/3237ba1e-00b1-4d31-8de6-56d6dd51587f)

* minimum, average and maximum values of the running balance for each customer
~~~~sql
WITH sub AS (
SELECT customer_id, txn_date,txn_type, txn_amount,
SUM( CASE WHEN txn_type = 'deposit' THEN txn_amount
   		  WHEN txn_type = 'purchase' or txn_type = 'withdrawal' THEN -txn_amount 
		  ELSE 0 END) 
	OVER (PARTITION BY customer_id ORDER BY txn_date) as running_balance
FROM data_bank.customer_transactions
)
SELECT customer_id,
min(running_balance) as min_running_balance,
max(running_balance) as max_running_balance,
ROUND(avg(running_balance),0) as avg_running_balance
FROM sub
GROUP BY customer_id;
~~~~
#### Output:
*Kindly note that this is not the entire output. The entire output is long and would take up space.*
![Screenshot 2024-04-03 at 4 37 56 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/7f4349c0-eae7-446e-9a9a-1d067a0d590c)

### Option 1: data is allocated based on the amount of money at the end of the previous month
~~~~sql
--Net transaction amount for each customer and for each transaction
WITH transaction_amt AS (
SELECT customer_id, txn_date, EXTRACT (MONTH FROM txn_date) as month,txn_type,
CASE WHEN txn_type ='deposit' THEN txn_amount ELSE -txn_amount END as net_transaction_amt
FROM data_bank.customer_transactions
ORDER BY customer_id, txn_date
)
-- Running customer balance of each customer each transaction
, running_balance AS (
SELECT customer_id,txn_date,month,net_transaction_amt,
SUM(net_transaction_amt) OVER (PARTITION BY customer_id, month ORDER BY txn_date
							   ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
							  ) as running_customer_balance
FROM transaction_amt
)
-- Month-end balance for each customer
, customer_end_balance AS(
SELECT customer_id, month, max(running_customer_balance) as month_end_balance
FROM running_balance 
GROUP BY customer_id, month
ORDER BY customer_id, month
)
-- Final data required per month
SELECT month, sum(month_end_balance)as data_require_per_month
FROM customer_end_balance
GROUP BY month
ORDER BY month;
~~~~
#### Output:
![Screenshot 2024-04-03 at 5 38 37 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/a9500baa-02a0-4c85-a26f-bcf860a521e2)

#### *Insight:*

* The distribution of monthly data allocation varies, with January having the highest at 362,688, followed by March (147,514) and February (130,592), while April requires the least (53,982).
* This indicates that the data needs of customers correlate with their transaction activities and end-of-month balances. Specifically, customers with higher balances tend to require more data.
* In summary, the observation suggests that data allocation should prioritize months with higher end-of-month balances, such as January and March, over months with lower balances like February and April. This understanding can aid in predicting customer behaviour, optimizing business strategies, and managing costs effectively.

### Option 2: data is allocated on the average amount of money kept in the account in the previous 30 days
~~~~sql
--Net transaction amount for each customer each month
WITH transaction_amt AS (
SELECT customer_id,  EXTRACT (MONTH FROM txn_date) as month,
SUM(CASE WHEN txn_type ='deposit' THEN txn_amount ELSE -txn_amount END) as net_transaction_amt
FROM data_bank.customer_transactions
GROUP BY customer_id, month
)
-- Running customer balance of each customer each month
, running_balance AS (
SELECT customer_id, month, net_transaction_amt,
SUM(net_transaction_amt) OVER (PARTITION BY customer_id  ORDER BY month
							   ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
							  ) as running_customer_balance
FROM transaction_amt
)
-- Average running balance for each customer across the month
,avg_running_balance AS (
SELECT customer_id, avg(running_customer_balance) as avg_running_customer_balance
FROM running_balance 
GROUP BY customer_id
)
SELECT running_balance.month,
ROUND(SUM(avg_running_customer_balance),0) as data_required_monhtly
FROM running_balance
JOIN avg_running_balance on running_balance.customer_id = avg_running_balance.customer_id
GROUP BY running_balance.month
ORDER BY running_balance.month;
~~~~
#### Output:
![Screenshot 2024-04-03 at 5 26 40 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/6806a3ef-5cd4-4648-beff-1a92681805ed)

#### *Insight:*

* According to our query results, the average running customer balance is consistently negative across all four months, indicating a trend where customers withdraw more money than they deposit on average.
* Interestingly, the data requirements for February and March exceed those for January and April. This suggests that allocating more data resources for these two months would be beneficial.
* Given the consistent negative running balances, there could be potential implications for the bank's overall financial health. Therefore, I propose that the bank focus on collecting more data for February and March. This would enable a deeper understanding 
of customer behaviour during these months, allowing for the identification of any significant trends or anomalies that could impact 
the bank's operations.

### Option 3: data is updated in real time
~~~~sql
--Net transaction amount for each customer each month
WITH transaction_amt AS (
SELECT customer_id, txn_date, EXTRACT (MONTH FROM txn_date) as month, txn_type, txn_amount,
CASE WHEN txn_type ='deposit' THEN txn_amount ELSE -txn_amount END as net_transaction_amt
FROM data_bank.customer_transactions
)
-- Running customer balance of each customer each month
, running_balance AS (
SELECT customer_id, month, 
SUM(net_transaction_amt) OVER (PARTITION BY customer_id  ORDER BY month) as running_customer_balance
FROM transaction_amt
)
-- Final estimated data required per month
SELECT month, SUM(running_customer_balance) as data_required_monthly
FROM running_balance
GROUP BY month
ORDER BY month;
~~~~
#### Output:
![Screenshot 2024-04-03 at 5 32 30 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/ee6360f5-2b8e-4ea6-b893-9e08e6a03ee9)

#### *Insight:*

* March stands out with a notably higher data requirement compared to other months, indicating a higher volume of transactions during March relative to the other months.
* Conversely, January's data requirement being positive suggests the presence of customers with relatively higher balances at the start of the year.
  
## D. Extra Challenge
Data Bank wants to try another option which is a bit more difficult to implement - they want to calculate data growth using an interest calculation, just like in a traditional savings account you might have with a bank.

If the annual interest rate is set at 6% and the Data Bank team wants to reward its customers by increasing their data allocation based on the interest calculated daily at the end of each day, how much data would be required for this option monthly?

Special notes:

* Data Bank wants an initial calculation which does not allow for compounding interest, however, they may also be interested in a daily compounding interest calculation so you can try to perform this calculation if you have the stamina!

~~~~sql
WITH day_interval AS (
SELECT customer_id, txn_date, txn_amount,
DATE_TRUNC('month', txn_date) AS month_start_date,
EXTRACT (DAY FROM (DATE_TRUNC('month', txn_date) + INTERVAL '1 MONTH' -INTERVAL '1 day')) as days_in_month,
EXTRACT (DAY FROM (DATE_TRUNC('month', txn_date) + INTERVAL '1 MONTH' -INTERVAL '1 day')) - EXTRACT(DAY FROM txn_date) as day_interval
FROM data_bank.customer_transactions
WHERE txn_type ='deposit'
GROUP BY customer_id, txn_Date, txn_amount
ORDER BY customer_id
)
,interest_daily AS (
SELECT customer_id, txn_date, txn_amount, 
ROUND(txn_amount*(0.06/365)* day_interval,2) as daily_interest
FROM day_interval
GROUP BY customer_id, txn_date, txn_amount, day_interval,txn_amount
ORDER BY customer_id
)
SELECT EXTRACT(MONTH FROM txn_date) as month,
SUM(daily_interest) as monthly_interest
FROM interest_daily
GROUP BY month
ORDER BY month;
~~~~
#### Output:
![Screenshot 2024-04-04 at 11 32 14 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/aa16c299-37a4-4ec2-b328-fee337aeefa1)

#### *Insight:*
Data allocation decreased from January (973.86) to February (845.68), followed by an increase from February (845.68) to March (982.47). However, there was a decrease in data allocation from March (982.47) to April (560.17)

## E. Extension Request
The Data Bank team wants you to use the outputs generated from the above sections to create a quick PowerPoint presentation which will be used as marketing materials for both external investors who might want to buy Data Bank shares and new prospective customers who might want to bank with Data Bank.

* Using the outputs generated from the customer node questions, generate a few headline insights that Data Bank might use to market its world-leading security features to potential investors and customers.
* With the transaction analysis - prepare a 1-page presentation slide which contains all the relevant information about the various options for the data provisioning so the Data Bank management team can make an informed decision.

In progess
