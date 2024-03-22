# 🍜 Case Study #1: Danny's Diner

## Business task: 
Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite.

## Entity Relationship Diagram

## Question and Solution
### 1. What is the total amount each customer spent at the restaurant?
~~~~sql
SELECT s.customer_id, sum(m.price) as total_sale
FROM dannys_diner.sales as s
JOIN dannys_diner.menu as m ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id
~~~~
### Output:
![CS1 Q1](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/a48c1832-c101-4bdc-9594-57deb7368a04)

* Customer A spent $76.
* Customer B spent $74.
* Customer C spent $36.
