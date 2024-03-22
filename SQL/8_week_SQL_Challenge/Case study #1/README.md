# 🍜 Case Study #1: Danny's Diner

## Business task: 
Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite.

## Entity Relationship Diagram
![Danny's Diner](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/8542fabe-c847-40fb-a702-77227a815d13)

## Question and Solution
### 1. What is the total amount each customer spent at the restaurant?
~~~~sql
SELECT s.customer_id, sum(m.price) as total_sale
FROM dannys_diner.sales as s
JOIN dannys_diner.menu as m ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;
~~~~
### Output:
![CS1 Q1](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/a48c1832-c101-4bdc-9594-57deb7368a04)

* Customer A spent $76.
* Customer B spent $74.
* Customer C spent $36.

### 2. How many days has each customer visited the restaurant?
~~~~sql
SELECT customer_id, COUNT(DISTINCT order_date) as num_day
FROM dannys_diner.sales
GROUP BY customer_id
ORDER BY customer_id;
~~~~

### Output:
![CS1 Q2](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/3e3185f4-3843-4763-bd5d-3cebb6707c2d)

* Customer A visited 4 times
* Customer B visited 6 times
* Customer C visited 2 times

### 3. What was the first item from the menu purchased by each customer?
~~~~sql
SELECT s.customer_id, m.product_name
FROM dannys_diner.sales as s
JOIN dannys_diner.menu as m ON s.product_id=m.product_id
WHERE (customer_id,order_date) IN (SELECT distinct customer_id, Min(order_date)
								   FROM dannys_diner.sales
								   GROUP BY customer_id)
GROUP BY s.customer_id, m.product_name -- Customer C ordered a product twice on the first day
ORDER BY s.customer_id;
~~~~
### Output:
![CS1 Q3](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/5da404b4-167f-4f1d-8ac8-ed6b384ea3e5)

* Customer A's first order is both curry and sushi
* Customer B's first order is curry
* Customer C's first order is ramen
  
### 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
~~~~sql
SELECT m.product_name, COUNT(s.product_id) as most_purchased_item
FROM dannys_diner.sales as s
JOIN dannys_diner.menu as m ON s.product_id=m.product_id
GROUP BY m.product_name
ORDER BY most_purchased_item DESC
LIMIT 1;
~~~~
### Output:
![CS1 Q4](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/d4f5411f-fc95-4dca-af37-bfa0326f6e86)

* Ramen is the most purchased item on the menu which is 8 times
  
### 5. Which item was the most popular for each customer?
~~~~sql
WITH sub AS (
SELECT s.customer_id, m.product_name,  
COUNT(s.product_id) AS order_count, 
RANK() OVER (PARTITION BY s.customer_id ORDER BY COUNT(s.product_id) DESC) as rank_num
FROM dannys_diner.sales as s
JOIN dannys_diner.menu as m ON s.product_id=m.product_id
GROUP BY s.customer_id,m.product_name
)
SELECT customer_id, product_name , order_count
FROM sub
WHERE rank_num =1;
~~~~
### Output:
![CS1 Q5](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/d9ee021c-396d-43de-8341-bc8e04576af9)

* Customer A and C's favourite item is ramen
* Customer B likes all items on the menu
  
### 6. Which item was purchased first by the customer after they became a member?
~~~~sql
WITH sub AS (
SELECT s.customer_id, m.product_name, s.order_date, mem.join_date, --information purchase after being a member
RANK() OVER (PARTITION BY s.customer_id ORDER BY order_date) as rank_num
FROM dannys_diner.sales as s
JOIN dannys_diner.menu as m ON s.product_id=m.product_id
JOIN dannys_diner.members as mem ON s.customer_id = mem.customer_id
WHERE order_date >=join_date
)
SELECT customer_id, product_name 
FROM sub
WHERE rank_num=1
ORDER BY customer_id;
~~~~
### Output:
![CS1 Q6](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/9b2929d3-0acc-4758-89b6-ee91d6a4f38f)

* Customer A's first order after being a member is ramen
* Customer B's first order after being a member is sushi

### 7. Which item was purchased just before the customer became a member?
~~~~sql
WITH sub AS (
SELECT s.customer_id, m.product_name, s.order_date, mem.join_date, --information purchase before being a member
rank() OVER (PARTITION BY s.customer_id ORDER BY order_date DESC) as rank_nu
FROM dannys_diner.sales as s
JOIN dannys_diner.menu as m ON s.product_id=m.product_id
JOIN dannys_diner.members as mem ON s.customer_id = mem.customer_id
WHERE order_date <join_date
)
SELECT customer_id, product_name 
FROM sub
WHERE rank_nu=1
ORDER BY customer_id;
~~~~
### Output:
![CS1 q7](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/5b6b4a3d-b39f-499a-8b4a-d19feb44ce1d)

* Customer A's last order before being a member is sushi
* Customer B's last order before being a member are sushi and ramen
  
### 8. What is the total items and amount spent for each member before they became a member?
~~~~sql
SELECT s.customer_id, COUNT(m.product_name) as total_items, 
SUM(m.price) as total_sales
FROM dannys_diner.sales as s
JOIN dannys_diner.menu as m ON s.product_id=m.product_id
JOIN dannys_diner.members as mem ON s.customer_id = mem.customer_id
WHERE s.order_date <mem.join_date
GROUP BY s.customer_id
ORDER BY s.customer_id;
~~~~
### Output:
![CS1 q8](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/7482defb-41a5-431e-84d9-e660a4e0701d)
Before becoming members,

* Customer A spent $25 on 2 items
* Customer B spent $40 on 3 items

### 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
~~~~sql
SELECT s.customer_id,
SUM(CASE WHEN m.product_name ='sushi' THEN 2*price*10 ELSE price*10 END) as total_point
FROM dannys_diner.sales as s
JOIN dannys_diner.menu as m ON s.product_id=m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;
~~~~
### Output:
![CS1 q9](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/92a42230-adf7-4b70-85da-584ad06475ce)

* Customer A has 860 total points
* Customer B has 940total points
* Customer C has 360 total points

### 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customers A and B have at the end of January?
~~~~sql
SELECT s.customer_id,
SUM(CASE WHEN m.product_name ='sushi' THEN 2*m.price*10 
WHEN s.order_date IN (SELECT s.order_date --first_week after join member program
					  FROM dannys_diner.sales as s
					  JOIN dannys_diner.members as mem ON s.customer_id = mem.customer_id
					  WHERE order_date-join_date between 0 and 6) 
THEN 2*m.price*10 
ELSE m.price*10 END) as point
FROM dannys_diner.sales as s 
JOIN dannys_diner.menu as m ON s.product_id=m.product_id
JOIN dannys_diner.members as mem ON s.customer_id = mem.customer_id
WHERE s.order_date<'2021-02-01'
AND s.order_date >=mem.join_date --Count from the date join member program to the end of January
GROUP BY s.customer_id
ORDER BY s.customer_id;
~~~~
### Output:
![cs1 q10](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/7759bc3d-1d1c-45bc-a237-999295e2155c)
* Customer A has 1020 total points
* Customer B has 320 total points
  
## Bonus question: 
### Join All The Things: 
#### Recreate the table with output: customer_id, order_date, product_name, price, member (Y/N)
~~~~sql
SELECT s.customer_id, s.order_date, m.product_name, m.price,
CASE WHEN mem.customer_id IS NULL or s.order_date <mem.join_date THEN 'N' ELSE 'Y' END as member
FROM dannys_diner.sales as s 
JOIN dannys_diner.menu as m ON s.product_id=m.product_id
LEFT JOIN dannys_diner.members as mem ON s.customer_id = mem.customer_id
ORDER BY s.customer_id, s.order_date, m.product_name;
~~~~

![CS1 Bonus 1](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/14be8686-d5cb-48e5-aa7e-a6ffc0455fdf)

### Rank All The Things
#### Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.
~~~~sql
WITH CTE AS (
SELECT s.customer_id, s.order_date, m.product_name, m.price,
CASE WHEN mem.customer_id IS NULL or s.order_date <mem.join_date THEN 'N' ELSE 'Y' END as member_status
FROM dannys_diner.sales as s 
JOIN dannys_diner.menu as m ON s.product_id=m.product_id
LEFT JOIN dannys_diner.members as mem ON s.customer_id = mem.customer_id
ORDER BY s.customer_id, s.order_date, m.product_name
)
SELECT *,
CASE WHEN member_status ='N' THEN NULL 
ELSE RANK() OVER(PARTITION BY customer_id, member_status ORDER BY order_date) END AS ranking
FROM CTE;
~~~~

![cs1 bonus 2](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/59af7e2f-fd21-45b1-99cc-c8e0f7abee69)
