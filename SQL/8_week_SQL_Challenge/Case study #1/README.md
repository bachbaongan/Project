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
