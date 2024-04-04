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
