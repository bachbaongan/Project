## B. Transaction Analysis
### 1. How many unique transactions were there?
~~~~sql
SELECT COUNT(DISTINCT txn_id) as number_unique_transaction
FROM balanced_tree.sales;
~~~~
![Screenshot 2024-04-16 at 12 54 35 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/e4d0a441-c966-48b6-9e87-0506101b55fc)


### 2. What is the average unique product purchased in each transaction?
~~~~sql
SELECT ROUND(AVG(product_count),0) as average_unique_product
FROM (SELECT txn_id, COUNT(prod_id) as product_count
	  FROM balanced_tree.sales
	  GROUP BY txn_id) as sub;
~~~~
![Screenshot 2024-04-16 at 12 59 38 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/b96b45f3-fda0-4385-bbbb-d0b3e13807ba)


### 3. What are the 25th, 50th and 75th percentile values for the revenue per transaction?
~~~~sql
WITH transaction_revenue AS (
SELECT txn_id, SUM(qty*price) as revenue
FROM balanced_tree.sales
GROUP BY txn_id
)
SELECT 
percentile_cont(0.25) WITHIN GROUP (ORDER BY revenue) as percentile_25th,
percentile_cont(0.50) WITHIN GROUP (ORDER BY revenue) as percentile_50th,
percentile_cont(0.75) WITHIN GROUP (ORDER BY revenue) as percentile_75th
FROM transaction_revenue;
~~~~
![Screenshot 2024-04-16 at 1 07 30 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/81c0bff0-6be4-40bc-ae40-8833e9db311e)


### 4. What is the average discount value per transaction?
~~~~sql
WITH transaction_discount AS (
SELECT txn_id, SUM(qty*price*discount/100.0) as discount
FROM balanced_tree.sales
GROUP BY txn_id)
SELECT ROUND(AVG(discount),1) as avgerage_discount
FROM transaction_discount;
~~~~
![Screenshot 2024-04-16 at 2 22 30 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/69c8d950-7c8a-4a20-bbf6-17ca82fbe9a3)


### 5. What is the percentage split of all transactions for members vs non-members?
~~~~sql
SELECT 
ROUND(100.0*COUNT(DISTINCT CASE WHEN member='true' THEN txn_id END)/COUNT(DISTINCT txn_id),1) as percentage_member,
ROUND(100.0*COUNT(DISTINCT CASE WHEN member='false' THEN txn_id END)/COUNT(DISTINCT txn_id),1) as percentage_non_member
FROM balanced_tree.sales;
~~~~
![Screenshot 2024-04-16 at 2 27 53 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/a08ff44c-4799-41b9-8335-767a8e1259f3)


### 6. What is the average revenue for member transactions and non-member transactions?
~~~~sql
WITH member_revenue AS (
SELECT member, txn_id, SUM(qty*price) as revenue
FROM balanced_tree.sales
GROUP BY member, txn_id
)
SELECT member, ROUND(AVG(revenue),2) as average_revenue
FROM member_revenue
GROUP BY member;
~~~~
![Screenshot 2024-04-16 at 2 31 07 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/455b1748-c1bd-41f0-afae-0092c00b238b)
