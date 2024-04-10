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
