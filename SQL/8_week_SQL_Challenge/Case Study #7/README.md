# 👕 Case Study #7 - Balanced Tree Clothing Co.
![7](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/1f66127a-0dd1-4203-96aa-47b5eb24c024)

## 📖 Table of contents:

* [Business task](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%237/README.md#business-task)
* [Entity Relationship Diagram](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%237/README.md#entity-relationship-diagram)
* [Question and Solution](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%237/README.md#question-and-solution)

  * [A. High Level Sales Analysis](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%237/README.md#a-high-level-sale-analysis)
  * [B. Transaction Analysis](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%237/README.md#b-transaction-analysis)
  * [C. Product Analysis](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%237/README.md#c-product-analysis)
  * [D. Reporting Challenge](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%237/README.md#d-reporting-challenge)
  * [E. Bonus Challenge](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%237/README.md#e-bonus-challenge)
     
## Business task: 
Balanced Tree Clothing Company prides itself on providing an optimized range of clothing and lifestyle wear for the modern adventurer!

Danny, the CEO of this trendy fashion company has asked you to assist the team’s merchandising teams analyze their sales performance and generating a basic financial report to share with the wider business.

## Entity Relationship Diagram
![e7 1](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/45f71095-c9af-4237-890a-87d61a7b5844)
![e7 2](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/0e12f98b-8f2d-44ab-9aa8-d4983fcf0112)

For this case study, there is a total of 4 datasets. However you will only need to utilize 2 main tables to solve all of the regular questions, and the additional 2 tables are used only for the bonus challenge question!

### Product Details
`balanced_tree.product_details` includes all information about the range that Balanced Clothing sells in their store.

![Screenshot 2024-04-16 at 11 58 47 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/79b49bb8-aeab-4892-9846-09bde1f0299e)

### Product Sales
`balanced_tree.sales` contains product level information for all the transactions made for Balanced Tree including quantity, price, a percentage discount, member status, a transaction ID and also the transaction timestamp.

15 rows out of 15095 rows
![Screenshot 2024-04-16 at 12 00 20 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/c315eb8b-5092-424c-bc0c-a984b33bff9b)

### Product Hierarchy & Product Price
These tables are used only for the bonus question where we will use them to recreate the balanced_tree.product_details table.
`balanced_tree.product_hierarchy`

![Screenshot 2024-04-16 at 11 59 19 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/7549cfd6-2df9-4372-8373-1392b5d3fcf8)

`balanced_tree.product_prices`

![Screenshot 2024-04-16 at 11 59 38 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/bb8267c5-f4be-435e-bdf2-ae6549c4f905)


## Question and Solution
## A. High Level Sales Analysis
### 1. What was the total quantity sold for all products?
~~~~sql
SELECT SUM(qty) as total_quantity
FROM balanced_tree.sales;
~~~~
![Screenshot 2024-04-16 at 12 43 25 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/425fedb6-d6a3-4b8a-b960-a015202fdbc2)

### 2. What is the total generated revenue for all products before discounts?
~~~~sql
SELECT SUM(qty*price) as total_revenue_before_discount
FROM balanced_tree.sales;
~~~~
![Screenshot 2024-04-16 at 12 49 06 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/496c9ac1-14fa-4604-8c6c-8ce24dcc0a81)

### 3. What was the total discount amount for all products?
~~~~sql
SELECT CAST(SUM(qty*price*discount/100.0) AS FLOAT) as total_discount
FROM balanced_tree.sales;
~~~~
![Screenshot 2024-04-16 at 12 52 58 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/9e9ca79e-f582-48da-83f4-a463e5fb09e6)

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

## C. Product Analysis
### 1. What are the top 3 products by total revenue before discount?
~~~~sql
SELECT pd.product_name, SUM(s.qty*s.price) as total_revenue_before_discount
FROM balanced_tree.sales s 
JOIN balanced_tree.product_details pd ON s.prod_id=pd.product_id
GROUP BY pd.product_name
ORDER BY SUM(s.qty*s.price) DESC
LIMIT 3;
~~~~
![Screenshot 2024-04-17 at 10 28 26 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/87ef1cfd-2010-4517-806e-79acf113294c)


### 2. What is the total quantity, revenue and discount for each segment?
~~~~sql
SELECT pd.segment_name, SUM(s.qty) as total_quantity,
SUM(s.qty*s.price) as total_revenue, 
ROUND(SUM(s.qty*s.price*s.discount/100.0),2) as total_discount
FROM balanced_tree.sales s 
JOIN balanced_tree.product_details pd ON s.prod_id=pd.product_id
GROUP BY pd.segment_name;
~~~~
![Screenshot 2024-04-17 at 10 50 20 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/95ab9bf0-ab84-41a3-8dc5-981a37ed6346)


### 3. What is the top-selling product for each segment?
~~~~sql
WITH segment_revenue AS (
SELECT pd.segment_name, pd.product_name,
SUM(s.qty*s.price) as total_revenue,
DENSE_RANK() OVER (PARTITION BY pd.segment_name ORDER BY SUM(s.qty*s.price) DESC ) as rank
FROM balanced_tree.sales s 
JOIN balanced_tree.product_details pd ON s.prod_id=pd.product_id
GROUP BY pd.segment_name, pd.product_name
)
SELECT segment_name, product_name, total_revenue
FROM segment_revenue
WHERE rank =1;
~~~~
![Screenshot 2024-04-17 at 10 56 12 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/5f83d0bb-375c-4cd9-820a-bf709d0da9b5)



### 4. What is the total quantity, revenue and discount for each category?
~~~~sql
SELECT pd.category_name, SUM(s.qty) as total_quantity,
SUM(s.qty*s.price) as total_revenue, 
ROUND(SUM(s.qty*s.price*s.discount/100.0),2) as total_discount
FROM balanced_tree.sales s 
JOIN balanced_tree.product_details pd ON s.prod_id=pd.product_id
GROUP BY pd.category_name;
~~~~
![Screenshot 2024-04-17 at 10 57 00 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/8009e48a-a7c2-4e49-b3f8-c724eee0f6cc)



### 5. What is the top-selling product for each category?
~~~~sql
WITH category_product AS (
SELECT pd.category_name, pd.product_name,
SUM(s.qty*s.price) as total_revenue,
DENSE_RANK() OVER (PARTITION BY pd.category_name ORDER BY SUM(s.qty*s.price) DESC ) as rank
FROM balanced_tree.sales s 
JOIN balanced_tree.product_details pd ON s.prod_id=pd.product_id
GROUP BY pd.category_name, pd.product_name
)
SELECT category_name, product_name, total_revenue
FROM category_product
WHERE rank =1;
~~~~
![Screenshot 2024-04-17 at 10 57 47 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/7a707879-cd65-420d-ba1f-a93c7eb03070)


### 6. What is the percentage split of revenue by product for each segment?
~~~~sql
WITH segment_revenue AS (
SELECT pd.segment_name, pd.product_name,
SUM(s.qty*s.price) as total_revenue
FROM balanced_tree.sales s 
JOIN balanced_tree.product_details pd ON s.prod_id=pd.product_id
GROUP BY pd.segment_name, pd.product_name
)
SELECT segment_name, product_name, 
ROUND(100.00*total_revenue/SUM(total_revenue) OVER (PARTITION BY segment_name),2) as pct_segment_product
FROM segment_revenue
ORDER BY segment_name, product_name,pct_segment_product DESC;
~~~~
![Screenshot 2024-04-17 at 11 02 11 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/03080749-c577-4e62-82e9-a729437e361f)


### 7. What is the percentage split of revenue by segment for each category?
~~~~sql
WITH category_segment  AS (
SELECT pd.category_name, pd.segment_name,
SUM(s.qty*s.price) as total_revenue
FROM balanced_tree.sales s 
JOIN balanced_tree.product_details pd ON s.prod_id=pd.product_id
GROUP BY pd.category_name, pd.segment_name
)
SELECT category_name, segment_name,
ROUND(100.00*total_revenue/SUM(total_revenue) OVER (PARTITION BY category_name),2) as pct_category_segment
FROM category_segment
ORDER BY category_name, segment_name,pct_category_segment DESC;
~~~~
![Screenshot 2024-04-17 at 11 05 02 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/99cc6293-0fd2-4ad0-8828-8216fdbdb561)


### 8. What is the percentage split of total revenue by category?
~~~~sql
WITH category_revenue AS (
SELECT pd.category_name,
SUM(s.qty*s.price) as total_revenue
FROM balanced_tree.sales s 
JOIN balanced_tree.product_details pd ON s.prod_id=pd.product_id
GROUP BY pd.category_name
)
SELECT category_name, total_revenue, 
ROUND(100.00*total_revenue/SUM(total_revenue) OVER (),2) as pct_category
FROM category_revenue;
~~~~
![Screenshot 2024-04-17 at 11 07 52 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/b8a68426-62aa-4173-8455-09f06e331e7e)


### 9. What is the total transaction “penetration” for each product? 
hint: penetration = number of transactions where at least 1 quantity of a product was purchased divided by the total number of transactions
~~~~sql
WITH penetration AS (
SELECT DISTINCT pd.product_id, pd.product_name,
COUNT(DISTINCT s.txn_id) as product_txn,
(SELECT COUNT(DISTINCT txn_id) FROM balanced_tree.sales) as total_txn
FROM balanced_tree.sales s 
JOIN balanced_tree.product_details pd ON s.prod_id=pd.product_id 
GROUP BY pd.product_id, pd.product_name
)
SELECT *, 
ROUND(100.00*product_txn/total_txn,2) as pct_penetration
FROM penetration;
~~~~
![Screenshot 2024-04-17 at 11 14 22 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/7008d187-052e-4239-ab8a-94b82a5d27e1)


### 10. What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?
~~~~sql
WITH product_per_txn AS (
SELECT s.txn_id, pd.product_id, pd.product_name, s.qty,
COUNT(pd.product_id) OVEr (PARTITION BY s.txn_id) as cnt
FROM balanced_tree.sales s 
JOIN balanced_tree.product_details pd ON s.prod_id=pd.product_id 
)
,combination as (
SELECT 
STRING_AGG(product_id, ', ' ORDER BY product_id) as product_ids,
STRING_AGG(product_name, ', ' ORDER BY product_id) as product_names
FROM product_per_txn
WHERE cnt =3
GROUP BY txn_id
)
,combo_count AS (
SELECT *, COUNT(*) as combo_count
FROM combination
GROUP BY product_ids, product_names
ORDER BY combo_count DESC
)
SELECT product_ids, product_names
FROM combo_count
WHERE combo_count = (SELECT MAX(combo_count) FROM combo_count);
~~~~
![Screenshot 2024-04-17 at 11 35 13 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/5d74e5a1-93c1-46a3-a765-ee831feecf74)



## D. Reporting Challenge
Write a single SQL script that combines all of the previous questions into a scheduled report that the Balanced Tree team can run at the beginning of each month to calculate the previous month’s values.

Imagine that the Chief Financial Officer (who is also Danny) has asked for all of these questions at the end of every month.

He first wants you to generate the data for January only - but then he also wants you to demonstrate that you can easily run the samne analysis for February without many changes (if at all).

Feel free to split up your final outputs into as many tables as you need - but be sure to explicitly reference which table outputs relate to which question for full marks :)
~~~~sql

~~~~


## E. Bonus Challenge
Use a single SQL query to transform the product_hierarchy and product_prices datasets to the product_details table.
~~~~sql

~~~~

