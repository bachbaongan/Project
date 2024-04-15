# 🦀 Case Study #6 - Clique Bait
![6](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/3fca08d6-0a1b-4491-a44e-9964f95a2edb)

## 📖 Table of contents:

* [Business task](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%236/README.md#business-task)
* [Entity Relationship Diagram](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%236/README.md#entity-relationship-diagram)
* [Question and Solution](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%236/README.md#question-and-solution)

  * [A. Digital Analysis](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%236/README.md#a-digital-analysis)
  * [B. Product Funnel Analysis](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%236/README.md#b-product-funnel-analysis)
  * [C. Campaigns Analysis](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%236/README.md#c-campaigns-analysis)
     
## Business task: 
Clique Bait is an online seafood store.

In this case study - you are required to support Danny’s vision analyze his dataset and come up with creative solutions to calculate funnel fallout rates for the Clique Bait online store.

## Entity Relationship Diagram
![e6](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/1ef02b3f-4a93-450f-bbb3-15c00a3bc3ba)


## Question and Solution
## A. Digital Analysis
### 1. How many users are there?
~~~~sql
SELECT COUNT(DISTINCT user_id) AS number_user
FROM clique_bait.users;
~~~~
#### Output:
![Screenshot 2024-04-10 at 12 21 01 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/458695b2-6b8e-4c70-b554-573fa761d6a9)

### 2. How many cookies does each user have on average?
~~~~sql
WITH CTE AS (
SELECT user_id, COUNT(cookie_id) as number_cookie
FROM clique_bait.users
GROUP BY user_id
)
SELECT ROUND(avg(number_cookie),0) as avg_number_cookie
FROM CTE;
~~~~
#### Output:
![Screenshot 2024-04-10 at 12 25 30 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/d3691ff4-bda1-45c3-80bb-93c3d27d8513)


### 3. What is the unique number of visits by all users per month?
~~~~sql
SELECT EXTRACT(MONTH from event_time) as month, COUNT(DISTINCT visit_id) as unique_user
FROM clique_bait.events
GROUP BY EXTRACT(MONTH from event_time)
ORDER BY month;
~~~~
#### Output:
![Screenshot 2024-04-10 at 12 28 41 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/b33c941a-ba60-47b8-a12c-8944ed823c57)


### 4. What is the number of events for each event type?
~~~~sql
SELECT ei.event_name, COUNT(e.*) as number_event
FROM clique_bait.events as e
JOIN clique_bait.event_identifier as ei ON e.event_type = ei.event_type
GROUP BY ei.event_name
ORDER BY number_event;
~~~~
#### Output:
![Screenshot 2024-04-10 at 12 31 57 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/9234e5fa-c24a-4369-a043-28c3cab02e8e)


### 5. What is the percentage of visits which have a purchase event?
~~~~sql
SELECT ei.event_name, 
ROUND(100.00 *COUNT(DISTINCT e.visit_id)/(SELECT COUNT(DISTINCT visit_id) FROM clique_bait.events),2) as percentage_visit
FROM clique_bait.events as e
JOIN clique_bait.event_identifier as ei ON e.event_type = ei.event_type
WHERE ei.event_name = 'Purchase'
GROUP BY ei.event_name;
~~~~
#### Output:
![Screenshot 2024-04-10 at 12 36 17 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/590fe35b-6b32-4a18-9cf6-1dce03feee8c)


### 6. What is the percentage of visits which view the checkout page but do not have a purchase event?
~~~~sql
WITH view_checkout AS ( 
SELECT COUNT(DISTINCT e.visit_id) as cnt 
FROM clique_bait.events e
JOIN clique_bait.event_identifier as ei on e.event_type = ei.event_type
JOIN clique_bait.page_hierarchy as ph ON e.page_id = ph.page_id
WHERE ei.event_name = 'Page View'
AND ph.page_name ='Checkout'
)
SELECT ROUND(100.00-(100.00 * COUNT(DISTINCT e.visit_id) 
		/ (SELECT cnt FROM view_checkout)), 2) AS pct_view_checkout_not_purchase		
FROM clique_bait.events e
JOIN clique_bait.event_identifier as ei on e.event_type = ei.event_type
WHERE ei.event_name = 'Purchase';
~~~~
#### Output:
![Screenshot 2024-04-10 at 1 00 48 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/e90a52a0-2a78-432b-9ee7-309d111fbfe4)


### 7. What are the top 3 pages by number of views?
~~~~sql
SELECT ph.page_name, COUNT(e.page_id) as amount
FROM clique_bait.events e
JOIN clique_bait.event_identifier as ei on e.event_type = ei.event_type
JOIN clique_bait.page_hierarchy as ph ON e.page_id = ph.page_id
WHERE ei.event_name = 'Page View'
GROUP BY ph.page_name
ORDER BY amount DESC
LIMIT 3;
~~~~
#### Output:
![Screenshot 2024-04-10 at 1 05 11 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/50b6c8f6-af3a-4e5b-96c3-f55f484f0624)


### 8. What is the number of views and cart adds for each product category?
~~~~sql
SELECT ph.product_category, 
SUM(CASE WHEN ei.event_name = 'Page View' THEN 1 ELSE 0 END) AS view_amount,
SUM(CASE WHEN ei.event_name = 'Add to Cart' THEN 1 ELSE 0 END) AS cart_adds_amount
FROM clique_bait.events e
JOIN clique_bait.event_identifier as ei on e.event_type = ei.event_type
JOIN clique_bait.page_hierarchy as ph ON e.page_id = ph.page_id
WHERE ph.product_id>0
GROUP BY ph.product_category
ORDER BY ph.product_category;
~~~~
#### Output:
![Screenshot 2024-04-10 at 2 53 56 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/7bb3a9f2-0932-4175-8d12-1e7f0c475079)


### 9. What are the top 3 products by purchase?
~~~~sql
SELECT ph.page_name, ph.product_category, COUNT(*) as purchase_amount
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
GROUP BY ph.page_name, ph.product_category
ORDER BY purchase_amount DESC
LIMIT 3;
~~~~
#### Output:
![Screenshot 2024-04-10 at 3 37 33 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/050e5fa6-8a0b-43a1-bc59-cd35fdaa80ca)


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


## C. Campaigns Analysis
Generate a table that has 1 single row for every unique `visit_id` record and has the following columns:

* `user_id`
* `visit_id`
* `visit_start_time`: the earliest `event_time` for each visit
* `page_views`: count of page views for each visit
* `cart_adds`: count of product cart add events for each visit
* `purchase`: 1/0 flag if a purchase event exists for each visit
* `campaign_name`: map the visit to a campaign if the `visit_start_time` falls between the start_date and end_date
* `impression`: count of ad impressions for each visit
* `click`: count of ad clicks for each visit
* (Optional column)`cart_products`: a comma-separated text value with products added to the cart sorted by the order they were added to the cart (hint: use the `sequence_number`)

~~~~sql
SELECT u.user_id, e.visit_id, 
MIN(e.event_time) as visit_start_time,
SUM(CASE WHEN ei.event_name ='Page View' THEN 1 ELSE 0 END) AS page_views,
SUM(CASE WHEN ei.event_name ='Add to Cart' THEN 1 ELSE 0 END) AS cart_adds,
SUM(CASE WHEN ei.event_name ='Purchase' THEN 1 ELSE 0 END) AS purchase,
ci.campaign_name,
SUM(CASE WHEN ei.event_name ='Ad Impression' THEN 1 ELSE 0 END) AS impression,
SUM(CASE WHEN ei.event_name ='Ad Click' THEN 1 ELSE 0 END) AS click,
STRING_AGG(CASE WHEN ei.event_name = 'Add to Cart' THEN ph.page_name END, ', ' ORDER BY e.sequence_number ) 
 AS cart_products
INTO campaign_summary
FROM clique_bait.events e
JOIN clique_bait.users u ON e.cookie_id = u.cookie_id
JOIN clique_bait.event_identifier ei ON ei.event_type = e.event_type
JOIN clique_bait.page_hierarchy ph ON e.page_id = ph.page_id
LEFT JOIN clique_bait.campaign_identifier ci ON e.event_time BETWEEN ci.start_date AND ci.end_date
GROUP BY u.user_id, e.visit_id,ci.campaign_name
ORDER BY u.user_id, e.visit_id;
~~~~

* 3,564 rows in total. The first 10 rows:
![Screenshot 2024-04-12 at 3 16 35 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/f164bed8-7c7a-46cf-b769-2091400ee79c)

Some ideas you might want to investigate further include:

* Identifying users who have received impressions during each campaign period and comparing each metric with other users who did not have an impression event
* Does clicking on an impression lead to higher purchase rates?
* What is the uplift in purchase rate when comparing users who click on a campaign impression versus users who do not receive an impression? What if we compare them with users who just make an impression but do not click?
* What metrics can you use to quantify the success or failure of each campaign compared to each other?

### 1. Calculate the number of users for each group to define the portion of each group and find the performance of ads through impression rate and click-through rate by calculating the rate per user.
~~~~sql
--Number of users who received impressions during campaign periods
SELECT COUNT(DISTINCT user_id) AS received_impressions
FROM campaign_summary
WHERE impression > 0
AND campaign_name IS NOT NULL;
~~~~
![Screenshot 2024-04-15 at 9 11 26 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/d31a5051-5770-4b50-9353-738e69675ccc)

~~~~sql
--Number of users who received impressions but didn't click on the ad during campaign periods
SELECT COUNT(DISTINCT user_id) AS received_impressions_not_clicked
FROM campaign_summary
WHERE impression > 0
AND click = 0
AND campaign_name IS NOT NULL;
~~~~
![Screenshot 2024-04-15 at 9 11 53 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/078fcf21-05cb-4044-92c2-87d766f14b8a)

~~~~sql
--Number of users who didn't receive impressions during campaign periods
SELECT COUNT(DISTINCT user_id) AS received_impressions
FROM campaign_summary
WHERE campaign_name IS NOT NULL
AND user_id NOT IN (SELECT user_id
		    FROM campaign_summary
		    WHERE impression > 0);
~~~~
![Screenshot 2024-04-15 at 9 12 19 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/9e576a1e-4abb-4b2d-a393-59ef89408cf0)

We found out that: 

* 417 users received impressions during campaign periods
* 127 users received impressions but didn't click on the ad
* 56 users didn't receive impressions during campaign periods

Therefore, we can calculate:

* impression rate: 100*417/(417+56) =88.2%
* click-through rate: 100-(100*127/417)=69.5%

### 2. Calculate the average clicks, average views, average cart adds, and average purchases of each group 
~~~~sql
--For users who received impressions
SELECT 417 as received,
  CAST(1.0*SUM(page_views) / 417 AS decimal(10,1)) AS avg_view,
  CAST(1.0*SUM(cart_adds) / 417 AS decimal(10,1)) AS avg_cart_adds,
  CAST(1.0*SUM(purchase) / 417 AS decimal(10,1)) AS avg_purchase
FROM campaign_summary
WHERE impression > 0
AND campaign_name IS NOT NULL;
~~~~
![Screenshot 2024-04-15 at 9 57 17 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/bb26b324-4f0e-4e63-a93f-c039bb6ac305)

~~~~sql
--For users who received impressions but didn't click on the ad
SELECT 127 as received_not_clicked,
  CAST(1.0*SUM(page_views) / 127 AS decimal(10,1)) AS avg_view,
  CAST(1.0*SUM(cart_adds) / 127 AS decimal(10,1)) AS avg_cart_adds,
  CAST(1.0*SUM(purchase) / 127 AS decimal(10,1)) AS avg_purchase
FROM campaign_summary
WHERE impression > 0
AND click = 0
AND campaign_name IS NOT NULL;
~~~~
![Screenshot 2024-04-15 at 9 58 15 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/a2dbd22d-10c2-4345-8614-d54b9c2ebe52)

~~~~sql
--For users who didn't receive impressions 
SELECT 56 as not_received,
  CAST(1.0*SUM(page_views) / 56 AS decimal(10,1)) AS avg_view,
  CAST(1.0*SUM(cart_adds) / 56 AS decimal(10,1)) AS avg_cart_adds,
  CAST(1.0*SUM(purchase) / 56 AS decimal(10,1)) AS avg_purchase
FROM campaign_summary
WHERE campaign_name IS NOT NULL
AND user_id NOT IN (SELECT user_id
		    FROM campaign_summary
		    WHERE impression > 0);
~~~~
![Screenshot 2024-04-15 at 9 59 34 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/93ac30c6-03ad-47ba-b9b5-ccef83af26a3)

### 3. Compare the average views, average cart adds and average purchases of users who received impressions and not receive impressions
Combine results in part 2, we have the table:
|                             | avg_view | avg_cart_adds | avg_purchase  |
|-----------------------------|----------|---------------|---------------|
| Received impressions        | 15.3     | 9             | 1.5           |
| Not received impressions    | 19.4     | 5.8           | 1.2           |
| Increase by campaigns       |  No      | Yes           | Yes           |

* During campaign periods, there's a decrease in the average number of views per user, while there's an increase in the average number of products added to the cart per user and the average number of products purchased per user. This suggests that customers might be more focused, perhaps clicking on ads or directly navigating to specific product pages rather than browsing multiple pages. 
* Customers who received impressions were more inclined to add products to their carts rather than making purchases outright, as evidenced by the comparison of averages: (9-5.8) > (1.5-1.2).

### 4. Compare the average purchases of users who received impressions and received impressions but did not click on ads
Combine results above, we have the table:
|                                      | avg_purchase  |
|--------------------------------------|---------------|
| Received impressions                 | 1.5           |
| Received impressions but not clicked | 0.8           |
| Increase by clicking on the ads      | Yes           |

* Users who received impressions but didn't click on ads had lower average purchases compared to those who received impressions overall. This indicates that simply receiving impressions without clicking on ads doesn't necessarily result in higher purchase rates. 
* Clicking on ads did not lead to a higher purchase rate.
