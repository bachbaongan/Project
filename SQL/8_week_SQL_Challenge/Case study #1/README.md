



~~~~sql
SELECT s.customer_id, sum(m.price) as total_sale
FROM dannys_diner.sales as s
JOIN dannys_diner.menu as m ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id
~~~~
