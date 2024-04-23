## D. Index Analysis
The `index_value` is a measure which can be used to reverse calculate the average composition for Fresh Segments’ clients.

Average composition can be calculated by dividing the `composition` column by the `index_value` column rounded to 2 decimal places.

### 1. What are the top 10 interests by the average composition for each month?
~~~~sql
WITH avg_composition AS (
SELECT me.interest_id, ma.interest_name,me.month_year,
ROUND(CAST(me.composition/me.index_value AS numeric),2) as avg_composition,
DENSE_RANK() OVER(PARTITION BY me.month_year ORDER BY me.composition / me.index_value DESC) AS rank
FROM fresh_segments.interest_metrics me
JOIN fresh_segments.interest_map ma ON me.interest_id = ma.id
WHERE me.month_year IS NOT NULL
)
SELECT *
FROM avg_composition
WHERE rank<=10;
~~~~

140 rows for 14 months in total. The first 10 rows:
![Screenshot 2024-04-23 at 11 29 15 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/4e144acc-4b5e-4761-b985-0a88af72eeb4)

### 2. For all of these top 10 interests - which interest appears the most often?
~~~~sql
WITH avg_composition AS (
SELECT me.interest_id, ma.interest_name,me.month_year,
ROUND(CAST(me.composition/me.index_value AS numeric),2) as avg_composition,
DENSE_RANK() OVER(PARTITION BY me.month_year ORDER BY me.composition / me.index_value DESC) AS rank
FROM fresh_segments.interest_metrics me
JOIN fresh_segments.interest_map ma ON me.interest_id = ma.id
WHERE me.month_year IS NOT NULL
)
,freq_interest AS (
SELECT interest_id, interest_name, COUNT(*) as freq
FROM avg_composition
WHERE rank <=10
GROUP BY interest_id, interest_name
)
SELECT *
FROM freq_interest
WHERE freq IN (SELECT MAX(freq) FROM freq_interest);
~~~~
![Screenshot 2024-04-23 at 11 31 58 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/b9024126-3afc-49cb-a498-bc85aa233432)

### 3. What is the average of the average composition for the top 10 interests for each month?
~~~~sql
WITH avg_composition AS (
SELECT me.interest_id, ma.interest_name,me.month_year,
ROUND(CAST(me.composition/me.index_value AS numeric),2) as avg_composition,
DENSE_RANK() OVER(PARTITION BY me.month_year ORDER BY me.composition / me.index_value DESC) AS rank
FROM fresh_segments.interest_metrics me
JOIN fresh_segments.interest_map ma ON me.interest_id = ma.id
WHERE me.month_year IS NOT NULL
)
SELECT month_year, 
ROUND(AVG(avg_composition),2) as avg_of_avg_composition
FROM avg_composition
WHERE rank<=10
GROUP BY month_year;
~~~~
![Screenshot 2024-04-23 at 11 33 21 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/e03bb4a6-25e6-48e0-853f-ea60ed639be5)

### 4. What is the 3-month rolling average of the max average composition value from September 2018 to August 2019 and include the previous top-ranking interests in the same output shown below?

month_year	|interest_name	|max_index_composition	|3_month_moving_avg	|1_month_ago	|2_months_ago
--- |--- |--- |---|---|---
2018-09-01	|Work Comes First Travelers	|8.26	|7.61	|Las Vegas Trip Planners: 7.21	|Las Vegas Trip Planners: 7.36
2018-10-01	|Work Comes First Travelers	|9.14	|8.20	|Work Comes First Travelers: 8.26	|Las Vegas Trip Planners: 7.21
2018-11-01	|Work Comes First Travelers	|8.28	|8.56	|Work Comes First Travelers: 9.14	|Work Comes First Travelers: 8.26
2018-12-01	|Work Comes First Travelers	|8.31	|8.58	|Work Comes First Travelers: 8.28	|Work Comes First Travelers: 9.14
2019-01-01	|Work Comes First Travelers	|7.66	|8.08	|Work Comes First Travelers: 8.31	|Work Comes First Travelers: 8.28
2019-02-01	|Work Comes First Travelers	|7.66	|7.88	|Work Comes First Travelers: 7.66	|Work Comes First Travelers: 8.31
2019-03-01	|Alabama Trip Planners	|6.54	|7.29	|Work Comes First Travelers: 7.66	|Work Comes First Travelers: 7.66
2019-04-01	|Solar Energy Researchers	|6.28	|6.83	|Alabama Trip Planners: 6.54	|Work Comes First Travelers: 7.66
2019-05-01	|Readers of Honduran Content	|4.41	|5.74	|Solar Energy Researchers: 6.28	|Alabama Trip Planners: 6.54
2019-06-01	|Las Vegas Trip Planners	|2.77	|4.49	|Readers of Honduran Content: 4.41	|Solar Energy Researchers: 6.28
2019-07-01	|Las Vegas Trip Planners	|2.82	|3.33	|Las Vegas Trip Planners: 2.77	|Readers of Honduran Content: 4.41
2019-08-01	|Cosmetics and Beauty Shoppers	|2.73	|2.77	|Las Vegas Trip Planners: 2.82	|Las Vegas Trip Planners: 2.77

~~~~sql
WITH avg_composition as (
SELECT month_year,interest_id,
ROUND(CAST(composition / index_value AS numeric), 2) AS avg_comp,
ROUND(MAX(CAST(composition / index_value AS numeric)) OVER(PARTITION BY month_year), 2) AS max_avg_comp
FROM fresh_segments.interest_metrics
WHERE month_year IS NOT NULL
)
,max_avg_comp AS (
SELECT *
FROM avg_composition
WHERE avg_comp=max_avg_comp
)
,moving_avg_composition AS (
SELECT mac.month_year, ma.interest_name, mac.max_avg_comp AS max_index_composition,
ROUND(AVG(mac.max_avg_comp) OVER (ORDER BY mac.month_year 
								  ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) as "3_month_moving_avg",
CONCAT(LAG(ma.interest_name) OVER (ORDER BY mac.month_year), ': ', 
	   CAST(LAG(mac.max_avg_comp) OVER (ORDER BY mac.month_year) AS VARCHAR(10))) as "1_month_ago",
CONCAT(LAG(ma.interest_name,2) OVER (ORDER BY mac.month_year), ': ',
	   CAST(LAG(mac.max_avg_comp,2) OVER (ORDER BY mac.month_year)AS VARCHAR(10))) as "2_month_ago"
FROM max_avg_comp as mac
JOIN fresh_segments.interest_map ma ON mac.interest_id = ma.id
)
SELECT *
FROM moving_avg_composition
WHERE month_year BETWEEN '2018-09-01' AND '2019-08-01';
~~~~
![Screenshot 2024-04-23 at 11 44 55 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/a1175b92-b1db-49c6-8b0c-b4cc15db0ed4)



