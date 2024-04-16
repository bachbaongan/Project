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

* Product Details
balanced_tree.product_details includes all information about the range that Balanced Clothing sells in their store.
![Screenshot 2024-04-16 at 11 58 47 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/79b49bb8-aeab-4892-9846-09bde1f0299e)

* Product Sales
balanced_tree.sales contains product level information for all the transactions made for Balanced Tree including quantity, price, a percentage discount, member status, a transaction ID and also the transaction timestamp.
15 rows out of 15095 rows
![Screenshot 2024-04-16 at 12 00 20 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/c315eb8b-5092-424c-bc0c-a984b33bff9b)

* Product Hierarchy & Product Price
These tables are used only for the bonus question where we will use them to recreate the balanced_tree.product_details table.
balanced_tree.product_hierarchy
![Screenshot 2024-04-16 at 11 59 19 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/7549cfd6-2df9-4372-8373-1392b5d3fcf8)

balanced_tree.product_prices
![Screenshot 2024-04-16 at 11 59 38 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/bb8267c5-f4be-435e-bdf2-ae6549c4f905)


## Question and Solution
## A. High Level Sales Analysis
### 1. What was the total quantity sold for all products?
~~~~sql

~~~~

### 2. What is the total generated revenue for all products before discounts?
~~~~sql

~~~~

### 3. What was the total discount amount for all products?
~~~~sql

~~~~

## B. Transaction Analysis
### 1. How many unique transactions were there?
~~~~sql

~~~~


### 2. What is the average unique product purchased in each transaction?
~~~~sql

~~~~


### 3. What are the 25th, 50th and 75th percentile values for the revenue per transaction?
~~~~sql

~~~~


### 4. What is the average discount value per transaction?
~~~~sql

~~~~


### 5. What is the percentage split of all transactions for members vs non-members?
~~~~sql

~~~~


### 6. What is the average revenue for member transactions and non-member transactions?
~~~~sql

~~~~

## C. Product Analysis
### 1. What are the top 3 products by total revenue before discount?
~~~~sql

~~~~


### 2. What is the total quantity, revenue and discount for each segment?
~~~~sql

~~~~


### 3. What is the top-selling product for each segment?
~~~~sql

~~~~


### 4. What is the total quantity, revenue and discount for each category?
~~~~sql

~~~~


### 5. What is the top-selling product for each category?
~~~~sql

~~~~


### 6. What is the percentage split of revenue by product for each segment?
~~~~sql

~~~~


### 7. What is the percentage split of revenue by segment for each category?
~~~~sql

~~~~


### 8. What is the percentage split of total revenue by category?
~~~~sql

~~~~


### 9. What is the total transaction “penetration” for each product? (hint: penetration = number of transactions where at least 1 quantity of a product was purchased divided by total number of transactions
~~~~sql

~~~~


### 10. What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?
~~~~sql

~~~~



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

