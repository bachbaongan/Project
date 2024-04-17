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
