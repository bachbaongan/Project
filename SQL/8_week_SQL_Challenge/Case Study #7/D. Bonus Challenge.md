## D. Bonus Challenge
Use a single SQL query to transform the product_hierarchy and product_prices datasets to the product_details table.
~~~~sql
SELECT pp.product_id, pp.price,
CONCAT(ph1.level_text, ' ', ph2.level_text, ' - ', ph3.level_text) as product_name,
ph3.id as cateogory_id, 
ph2.id as segment_id, 
ph1.id as style_id, 
ph3.level_text as category_name,
ph2.level_text as segment_name,
ph1.level_text as stlye_name
FROM balanced_tree.product_hierarchy ph1
JOIN balanced_tree.product_hierarchy ph2 ON ph1.parent_id = ph2.id
JOIN balanced_tree.product_hierarchy ph3 ON ph2.parent_id = ph3.id
JOIN balanced_tree.product_prices pp ON ph1.id=pp.id;
~~~~
![Screenshot 2024-04-17 at 12 09 34 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/f6a6ef7b-9da4-4b49-a0e7-c3b53b7d6411)
