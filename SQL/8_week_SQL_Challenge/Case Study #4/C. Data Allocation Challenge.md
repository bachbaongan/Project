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
