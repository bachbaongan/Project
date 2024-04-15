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
