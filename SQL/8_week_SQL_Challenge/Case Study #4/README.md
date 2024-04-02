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

~~~~
#### Output:

### 2. What is the average total historical deposit counts and amounts for all customers?
~~~~sql

~~~~
#### Output:

### 3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?
~~~~sql

~~~~
#### Output:

### 4. What is the closing balance for each customer at the end of the month?
~~~~sql

~~~~
#### Output:

### 5. What is the percentage of customers who increase their closing balance by more than 5%?
~~~~sql

~~~~
#### Output:

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
