## B. Product Funnel Analysis
Using a single SQL query - create a new output table which has the following details:

* How many times was each product viewed?
* How many times was each product added to the cart?
* How many times was each product added to a cart but not purchased (abandoned)?
* How many times was each product purchased?

~~~~sql
WITH product_view_add AS (
SELECT ph.product_id, ph.page_name as product_name, ph.product_category,
SUM(CASE WHEN ei.event_name = 'Page View' THEN 1 ELSE 0 END) as views,
SUM(CASE WHEN ei.event_name ='Add to Cart' THEN 1 ELSE 0 END) as cart_adds
FROM clique_bait.events e
JOIN clique_bait.event_identifier ei ON e.event_type = ei.event_type
JOIN clique_bait.page_hierarchy ph ON e.page_id= ph.page_id
WHERE ph.product_id >0
GROUP BY ph.product_id, ph.page_name, ph.product_category
ORDER BY ph.product_id
)
, product_abandoned AS (
SELECT ph.product_id, ph.page_name as product_name, ph.product_category, COUNT(*) as abandoned
FROM clique_bait.events e
JOIN clique_bait.event_identifier as ei on e.event_type = ei.event_type
JOIN clique_bait.page_hierarchy as ph ON e.page_id = ph.page_id
--1st layer: products are added to cart
WHERE ei.event_name = 'Add to Cart'
--2nd layer: add-to-cart products are NOT purchased
AND e.visit_id NOT IN (SELECT e.visit_id 
					FROM clique_bait.events e
				    JOIN clique_bait.event_identifier ei ON e.event_type = ei.event_type
				    WHERE ei.event_name = 'Purchase')
GROUP BY ph.product_id, ph.page_name, ph.product_category
ORDER BY ph.product_id
)
,product_purchased AS (
SELECT ph.product_id, ph.page_name as product_name, ph.product_category, COUNT(*) as purchases
FROM clique_bait.events e
JOIN clique_bait.event_identifier as ei on e.event_type = ei.event_type
JOIN clique_bait.page_hierarchy as ph ON e.page_id = ph.page_id
--1st layer: products are added to cart
WHERE ei.event_name = 'Add to Cart'
--2nd layer: add-to-cart products are purchased
AND e.visit_id IN (SELECT e.visit_id 
					FROM clique_bait.events e
				    JOIN clique_bait.event_identifier ei ON e.event_type = ei.event_type
				    WHERE ei.event_name = 'Purchase')
GROUP BY ph.product_id, ph.page_name, ph.product_category
ORDER BY ph.product_id
)
SELECT pv.*, pa.abandoned, pp.purchases
INTO product_info_sum
FROM product_view_add pv
JOIN product_abandoned pa ON pv.product_id = pa.product_id
JOIN product_purchased pp ON pv.product_id = pp.product_id
ORDER BY pv.product_id;
~~~~
![Screenshot 2024-04-10 at 4 51 58 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/279626d8-0b36-4b63-8ca8-b93b816894be)

Additionally, create another table which further aggregates the data for the above points but this time for each product category instead of individual products.

~~~~sql
WITH product_view_add AS (
SELECT ph.product_category,
SUM(CASE WHEN ei.event_name = 'Page View' THEN 1 ELSE 0 END) as views,
SUM(CASE WHEN ei.event_name ='Add to Cart' THEN 1 ELSE 0 END) as cart_adds
FROM clique_bait.events e
JOIN clique_bait.event_identifier ei ON e.event_type = ei.event_type
JOIN clique_bait.page_hierarchy ph ON e.page_id= ph.page_id
WHERE ph.product_id >0
GROUP BY ph.product_category
)
, product_abandoned AS (
SELECT ph.product_category, COUNT(*) as abandoned
FROM clique_bait.events e
JOIN clique_bait.event_identifier as ei on e.event_type = ei.event_type
JOIN clique_bait.page_hierarchy as ph ON e.page_id = ph.page_id
--1st layer: products are added to cart
WHERE ei.event_name = 'Add to Cart'
--2nd layer: add-to-cart products are NOT purchased
AND e.visit_id NOT IN (SELECT e.visit_id 
					FROM clique_bait.events e
				    JOIN clique_bait.event_identifier ei ON e.event_type = ei.event_type
				    WHERE ei.event_name = 'Purchase')
GROUP BY ph.product_category
)
,product_purchased AS (
SELECT ph.product_category, COUNT(*) as purchases
FROM clique_bait.events e
JOIN clique_bait.event_identifier as ei on e.event_type = ei.event_type
JOIN clique_bait.page_hierarchy as ph ON e.page_id = ph.page_id
--1st layer: products are added to cart
WHERE ei.event_name = 'Add to Cart'
--2nd layer: add-to-cart products are purchased
AND e.visit_id IN (SELECT e.visit_id 
					FROM clique_bait.events e
				    JOIN clique_bait.event_identifier ei ON e.event_type = ei.event_type
				    WHERE ei.event_name = 'Purchase')
GROUP BY ph.product_category
)
SELECT pv.*, pa.abandoned, pp.purchases
FROM product_view_add pv
JOIN product_abandoned pa ON pv.product_category = pa.product_category
JOIN product_purchased pp ON pv.product_category = pp.product_category
ORDER BY pv.product_category;

~~~~
![Screenshot 2024-04-10 at 4 56 44 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/10b74cea-33f2-47f3-95e5-0b84d16a84a9)

Use your 2 new output tables - answer the following questions:

### 1.Which product had the most views?
~~~~sql
SELECT *
FROM product_info_sum
ORDER BY views DESC
LIMIT 1;
~~~~
#### Output:
![Screenshot 2024-04-10 at 5 03 49 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/420ccf29-598b-495f-83de-dd403b4b9994)

### 2. Which product had the most cart adds?
~~~~sql
SELECT *
FROM product_info_sum
ORDER BY cart_adds DESC
LIMIT 1;
~~~~
#### Output:
![Screenshot 2024-04-10 at 5 03 49 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/156b52f1-de59-4a79-82cd-b15896036c27)

### 3.Which product had the most purchases?
~~~~sql
SELECT *
FROM product_info_sum
ORDER BY purchases DESC
LIMIT 1;
~~~~
#### Output:
![Screenshot 2024-04-10 at 5 03 49 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/c1fc6ce5-fd55-4e6d-8e77-91919b2622b5)

### 4. Which product was most likely to be abandoned?
~~~~sql
SELECT *
FROM product_info_sum
ORDER BY abandoned DESC
LIMIT 1;
~~~~
#### Output:
![Screenshot 2024-04-10 at 5 06 14 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/4118a73d-777d-4c11-9b7e-b514afd2dbe4)



### 5. Which product had the highest view to purchase percentage?
~~~~sql
SELECT product_name,product_category,
ROUND(100.0 * purchases / views , 2) AS "purchase_per_view %"
FROM product_info_sum
ORDER BY "purchase_per_view %" DESC
LIMIT 1;
~~~~
#### Output:
![Screenshot 2024-04-10 at 5 10 33 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/732ca3e8-1740-4524-b32b-0007fb85b2fa)


### 6. What is the average conversion rate from view to cart add?
~~~~sql
SELECT 
ROUND(AVG(100.0*cart_adds/ views) , 2) AS avg_view_to_cart
FROM product_info_sum
ORDER BY avg_view_to_cart DESC;
~~~~
#### Output:
![Screenshot 2024-04-10 at 5 13 59 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/f86a58d2-2f5b-4a98-9521-3ab630159e66)


### 7. What is the average conversion rate from cart add to purchase?
~~~~sql
SELECT 
ROUND(AVG(100.0*purchases/cart_adds) , 2) AS avg_cart_add_to_purchase
FROM product_info_sum
ORDER BY avg_cart_add_to_purchase DESC;
~~~~
#### Output:
![Screenshot 2024-04-10 at 5 14 59 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/dc6c5bdc-0b59-4fd9-a893-3777b4e2e46c)
