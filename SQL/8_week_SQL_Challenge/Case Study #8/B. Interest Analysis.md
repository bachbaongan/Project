## B. Interest Analysis
### 1. Which interests have been present in all `month_year` dates in our dataset?
~~~~sql
--Find how many unique month_year dates in our dataset
SELECT COUNT (DISTINCT month_year) as unique_month_year
FROM fresh_segments.interest_metrics;
~~~~
![Screenshot 2024-04-22 at 2 35 51 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/40ecbd22-5f86-4714-be2b-3e9e0b651d24)

There are 14 unique `month_year` in our dataset
~~~~sql
--Find all interest_id that have 14 month_year 
WITH interest_month_count AS (
SELECT interest_id, COUNT(month_year) AS cnt
FROM fresh_segments.interest_metrics
GROUP BY interest_id
HAVING COUNT(month_year) = 14
)
SELECT COUNT(*) as number_interest_all_month
FROM interest_month_count;
~~~~
![Screenshot 2024-04-22 at 2 51 49 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/44ca5eb7-f02e-4fdf-becf-3e14e3da160e)

There are 480 interests are present in all the `month_year` dates
### 2. Using this same `total_months` measure - calculate the cumulative percentage of all records starting at 14 months - which `total_months` value passes the 90% cumulative percentage value?
~~~~sql
WITH interest_month AS (
SELECT interest_id, COUNT(month_year) AS total_months
FROM fresh_segments.interest_metrics
GROUP BY interest_id
)
, interest_count AS (
SELECT total_months, COUNT(interest_id) as interests
FROM interest_month
GROUP BY total_months
ORDER BY total_months DESC
)
SELECT total_months,interests,
ROUND(100.00*SUM(interests) OVER(ORDER BY total_months DESC)/SUM(interests) OVER (),2) as cumulative_percentage
FROM interest_count;
~~~~
![Screenshot 2024-04-22 at 2 43 41 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/e95b03a9-adc9-4802-b605-2b2e80a538be)

Interests that have been active for a total of 6 months or more exhibit a cumulative percentage of 90% or higher. Conversely, interests with fewer than 6 months of activity warrant investigation to enhance their performance in terms of clicks and customer interactions.

### 3. If we were to remove all `interest_id` values which are lower than the `total_months` value we found in the previous question - how many total data points would we be removing?
~~~~sql
WITH interest_month AS (
SELECT interest_id, COUNT(DISTINCT month_year) AS total_months
FROM fresh_segments.interest_metrics
WHERE interest_id IS NOT NULL
GROUP BY interest_id
)
SELECT COUNT(interest_id) as interests,
COUNT(DISTINCT interest_id) as unique_interest
FROM fresh_segments.interest_metrics
WHERE interest_id IN ( SELECT interest_id 
					   FROM interest_month 
					   WHERE total_months<6);
~~~~
![Screenshot 2024-04-22 at 2 56 50 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/971b8c8f-b8b8-486c-a05b-5e484f45628c)

If we removed all 110 `interest_id` values that are below 6 months in the table interest_metrics, 400 data points would be removed.
### 4. Does this decision make sense to remove these data points from a business perspective? Use an example where there are all 14 months present to a removed `interest` example for your arguments - think about what it means to have fewer months present from a segment perspective.

When checking the timeline of our dataset, I realized that this business had just started 1 year and 1 month. The timeline was too short to confirm whether the customer who didn't contribute too much to the business outcome will go back to the business or not. Therefore, from a business perspective, we shouldn't remove these data points.

~~~~sql
SELECT 
  MIN(month_year) AS first_date,
  MAX(month_year) AS last_date
FROM fresh_segments.interest_metrics;
~~~~
![Screenshot 2024-04-22 at 2 59 33 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/49f0dad6-8e89-4ee2-acde-1f95530bcd32)
~~~~sql
--When total_months = 14
SELECT month_year, COUNT(DISTINCT interest_id) as interest_count,
MIN(ranking) as highest_ranking,
MAX(composition) as composition_max,
MAX(index_value) as index_max
FROM fresh_segments.interest_metrics
WHERE interest_id IN (SELECT interest_id 
					  FROM fresh_segments.interest_metrics 
					  WHERE interest_id IS NOT NULL 
					  GROUP BY interest_id 
					  HAVING COUNT(DISTINCT month_year) =14)
GROUP BY month_year
ORDER BY month_year, highest_ranking;
~~~~
![Screenshot 2024-04-22 at 3 20 58 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/dabd51e4-0ef7-4119-8fa8-ecd22442dc58)

~~~~sql
--When total_months = 1
SELECT month_year, COUNT(DISTINCT interest_id) as interest_count,
MIN(ranking) as highest_ranking,
MAX(composition) as composition_max,
MAX(index_value) as index_max
FROM fresh_segments.interest_metrics
WHERE interest_id IN (SELECT interest_id 
					  FROM fresh_segments.interest_metrics 
					  WHERE interest_id IS NOT NULL 
					  GROUP BY interest_id 
					  HAVING COUNT(DISTINCT month_year) =1)
GROUP BY month_year
ORDER BY month_year, highest_ranking;
~~~~
![Screenshot 2024-04-22 at 3 21 34 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/d0a68a99-17a2-4c23-9dcf-3d7b485ba2c8)

In case we want to find the average, maximum or minimum of ranking, composition or index_value for each interest in every month, interest that doesn't have 14 months would create an uneven distribution of observations because we don't have data on these months. Therefore, we should keep these data points in the segment analysis to have a correct view of the overall interest of customers.


### 5. After removing these interests - how many unique interests are there for each month?
As mentioned before, instead of deleting interests below 6 months, I will create a temporary table temp_interest_metrics excluded them for the segment analysis.

~~~~sql
SELECT *
INTO temp_interest_metrics
FROM fresh_segments.interest_metrics
WHERE interest_id NOT IN (SELECT interest_id 
						  FROM fresh_segments.interest_metrics 
						  WHERE interest_id IS NOT NULL 
						  GROUP BY interest_id 
						  HAVING COUNT(DISTINCT month_year) <6);
~~~~
~~~~sql
SELECT COUNT(interest_id) as all_interest,
COUNT(DISTINCT interest_id) as unique_interest
FROM temp_interest_metrics;
~~~~
![Screenshot 2024-04-22 at 3 27 45 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/7a36c0a1-5f89-4800-86bc-648f5e4a682f)

We can notice that the number of unique interests has dropped from 1202 (Question 4 part A) to 1092, which is 110 interests corresponding to 400 data points (Question 3 this part).

~~~~sql
--The number of unique interests for each month after removing:
SELECT month_year,COUNT(DISTINCT interest_id) AS unique_interests
FROM temp_interest_metrics
WHERE month_year IS NOT NULL
GROUP BY month_year
ORDER BY month_year;
~~~~
![Screenshot 2024-04-22 at 3 29 04 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/79ab3a85-bd0c-4322-b512-4598309e7079)
