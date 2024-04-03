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
