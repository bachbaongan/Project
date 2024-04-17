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
