# 🍊 Case Study #8 - [Fresh Segments](https://8weeksqlchallenge.com/case-study-8/)
![8](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/1745984a-2d51-41c8-9d59-a7920e12fffb)

## 📖 Table of contents:

* [Business task](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%238/README.md#business-task)
* [Entity Relationship Diagram](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%238/README.md#entity-relationship-diagram)
* [Question and Solution](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%238/README.md#question-and-solution)

  * [A. Data Exploration and Cleaning](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%238/README.md#a-data-exploration-and-cleaning)
  * [B. Interest Analysis](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%238/README.md#b-interest-analysis)
  * [C. Segment Analysis](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%238/README.md#c-segment-analysis)
  * [D. Index Analysis](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%238/README.md#d-index-analysis)
  
     
## Business task: 
Danny created Fresh Segments, a digital marketing agency that helps other businesses analyze trends in online ad click behaviour for their unique customer base.

Clients share their customer lists with the Fresh Segments team who then aggregate interest metrics and generate a single dataset worth of metrics for further analysis.

In particular - the composition and rankings for different interests are provided for each client showing the proportion of their customer list who interacted with online assets related to each interest for each month.

Danny has asked for your assistance to analyze aggregated metrics for an example client and provide some high-level insights about the customer list and their interests.

## Entity Relationship Diagram
![e8-updated](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/9966c396-13c8-4a27-ab8c-0808c71229bb)


### Interest Metrics
This table contains information about aggregated interest metrics for a specific major client of Fresh Segments which makes up a large proportion of their customer base.

Each record in this table represents the performance of a specific `interest_id` based on the client’s customer base interest measured through clicks and interactions with specifically targeted advertising content.

15 out of 14273 rows
![Screenshot 2024-04-16 at 12 26 13 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/a68f8749-4ca2-46fc-88c6-dc69eccd906a)


##### For example - the first row of the `interest_metrics` table" 
In July 2018, the `composition` metric was 11.89, meaning that 11.89% of the client’s customer list interacted with the interest `interest_id` = 32486 - we can link `interest_id` to a separate mapping table to find the segment name called “Vacation Rental Accommodation Researchers”

The `index_value` is 6.19, which means that the composition value is 6.19x the average `composition` value for all Fresh Segments clients’ customers for this particular interest in July 2018.

The `ranking` and `percentage_ranking` relate to the order of `index_value` records each month and year.

### Interest Map
This mapping table links the `interest_id` with their relevant interest information. You will need to join this table onto the previous `interest_details` table to obtain the `interest_name` and any details about the summary information.

15 out of 1209 rows
![Screenshot 2024-04-16 at 12 25 18 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/a9d622d3-2c68-4491-9173-ccd7924482ad)


## Question and Solution
## A. Data Exploration and Cleansing
### 1. Update the `fresh_segments.interest_metrics` table by modifying the `month_year` column to be a date data type with the start of the month
~~~~sql
--Modify the length of column `month_year` so it can store 15 characters
ALTER TABLE fresh_segments.interest_metrics ALTER COLUMN month_year TYPE VARCHAR(15);

--Update values in month_year column and add start date of month
UPDATE fresh_segments.interest_metrics
SET month_year =  TO_DATE(CONCAT('01-',month_year), 'DD-MM-YYYY');

--Convert month_year to DATE
ALTER TABLE fresh_segments.interest_metrics
ALTER COLUMN month_year TYPE DATE USING month_year::date;

SELECT * FROM fresh_segments.interest_metrics;
~~~~
![Screenshot 2024-04-22 at 1 41 49 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/693d15ca-8cce-4a7d-b4c9-738a5ff7dd21)

### 2. What is the count of records in the `fresh_segments.interest_metrics` for each `month_year` value sorted in chronological order (earliest to latest) with the null values appearing first?
~~~~sql
SELECT month_year, COUNT(*)
FROM fresh_segments.interest_metrics
GROUP BY month_year
ORDER BY month_year NULLS first;
~~~~
![Screenshot 2024-04-22 at 1 42 02 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/e7df0d61-8e8a-4046-a389-a3ff456041a3)

### 3. What do you think we should do with these null values in the `fresh_segments.interest_metrics`?
~~~~sql
SELECT *
FROM fresh_segments.interest_metrics
WHERE month_year IS NULL
ORDER BY interest_id;
~~~~
![Screenshot 2024-04-22 at 1 45 46 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/15970617-78f9-437f-b9ec-26db1778d080)

Since the values in fields like composition, index_value, ranking, and percentile_ranking lack significance 
without the specific interest_id, I will remove any rows where interest_id is null.

~~~~sql
DELETE FROM fresh_segments.interest_metrics
WHERE interest_id IS NULL;
~~~~

### 4. How many `interest_id` values exist in the `fresh_segments.interest_metrics` table but not in the fresh_segments.interest_map table? What about the other way around?
~~~~sql
SELECT COUNT(DISTINCT me.interest_id) as metric_id_count,
COUNT(DISTINCT ma.id) as map_id_count,
SUM(CASE WHEN me.interest_id IS NULL THEN 1 END) as not_in_metric,
SUM(CASE WHEN ma.id IS NULL THEN 1 END) as not_in_map
FROM fresh_segments.interest_metrics me
FULL JOIN fresh_segments.interest_map ma ON me.interest_id = ma.id;
~~~~
![Screenshot 2024-04-22 at 2 05 29 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/5a639369-0b6c-4a0d-bec1-487702ca5d09)

* There are 1209 `id` in table `interest_map`.
* There are 1202 `interest_id` in table `interest_metrics`.
* There are 7 `id` appearing in table `interest_map` but not appearing in `interest_id` of table `interest_metrics` .
* No `interest_id` values appear in table `interest_metrics` but don't appear in `id` of table interest_map.
  
### 5. Summarise the id values in the `fresh_segments.interest_map` by its total record count in this table
~~~~sql
SELECT COUNT(DISTINCT id) as count_id
FROM fresh_segments.interest_map;
~~~~
![Screenshot 2024-04-22 at 2 06 47 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/12cd4c95-82a2-4600-a267-f1d938685f5f)

### 6. What sort of table join should we perform for our analysis and why? Check your logic by checking the rows where `interest_id = 21246` in your joined output and include all columns from fresh_segments.interest_metrics and all columns from `fresh_segments.interest_map` except the `id` column.
~~~~sql
--We should be using INNER JOIN to perform our analysis.
SELECT * 
FROM fresh_segments.interest_metrics me
JOIN fresh_segments.interest_map ma ON me.interest_id = ma.id
WHERE me.interest_id = 21246;
~~~~
![Screenshot 2024-04-22 at 2 12 19 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/3bfdda08-7bb5-47dc-bbc1-8f20269684f6)

### 7. Are there any records in your joined table where the month_year value is before the `created_at` value from the `fresh_segments.interest_map` table? Do you think these values are valid and why?
~~~~sql
SELECT COUNT(*)  as cnt
FROM fresh_segments.interest_metrics me
JOIN fresh_segments.interest_map ma ON me.interest_id = ma.id
WHERE me.month_year < ma.created_at;
~~~~
![Screenshot 2024-04-22 at 2 14 09 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/684a5705-ad2f-496a-b989-5e17e2d1c962)

There are 188 `month_year` values that are before `created_at` values. However, it may be the case that those 188 created_at values were created at the same month as `month_year` values. The reason is that `month_year` values were set on the first date of the month by default in Question 1.

To check that, we turn the `create_at` to the first date of the month:
~~~~sql
SELECT COUNT(*)  as cnt
FROM fresh_segments.interest_metrics me
JOIN fresh_segments.interest_map ma ON me.interest_id = ma.id
WHERE me.month_year < CAST(CONCAT('01-', EXTRACT(MONTH FROM ma.created_at),'-',EXTRACT(YEAR FROM ma.created_at) ) AS DATE);
~~~~
![Screenshot 2024-04-22 at 2 18 40 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/9abe0208-714c-46b6-a35c-3f39ed662969)

Since all month_year and created_at were at the same month, these values are valid.

## B. Interest Analysis
### 1. Which interests have been present in all `month_year` dates in our dataset?
~~~~sql

~~~~

### 2. Using this same `total_months` measure - calculate the cumulative percentage of all records starting at 14 months - which `total_months` value passes the 90% cumulative percentage value?
~~~~sql

~~~~

### 3. If we were to remove all `interest_id` values which are lower than the `total_months` value we found in the previous question - how many total data points would we be removing?
~~~~sql

~~~~

### 4. Does this decision make sense to remove these data points from a business perspective? Use an example where there are all 14 months present to a removed `interest` example for your arguments - think about what it means to have fewer months present from a segment perspective.
~~~~sql

~~~~

### 5. After removing these interests - how many unique interests are there for each month?
~~~~sql

~~~~


## C. Segment Analysis
### 1. Using our filtered dataset by removing the interests with less than 6 months' worth of data, which are the top 10 and bottom 10 interests which have the largest composition values in any `month_year`? Only use the maximum composition value for each interest but you must keep the corresponding `month_year`
~~~~sql

~~~~

### 2. Which 5 interests had the lowest average `ranking` value?
~~~~sql

~~~~

### 3. Which 5 interests had the largest standard deviation in their `percentile_ranking` value?
~~~~sql

~~~~

### 4. For the 5 interests found in the previous question - what were the minimum and maximum `percentile_ranking` values for each interest and its corresponding `year_month` value? Can you describe what is happening for these 5 interests?
~~~~sql

~~~~

### 5. How would you describe our customers in this segment based on their composition and ranking values? What sort of products or services should we show to these customers and what should we avoid?
~~~~sql

~~~~

## D. Index Analysis
The `index_value` is a measure which can be used to reverse calculate the average composition for Fresh Segments’ clients.

Average composition can be calculated by dividing the `composition` column by the `index_value` column rounded to 2 decimal places.

### 1. What are the top 10 interests by the average composition for each month?
~~~~sql

~~~~

### 2. For all of these top 10 interests - which interest appears the most often?
~~~~sql

~~~~

### 3. What is the average of the average composition for the top 10 interests for each month?
~~~~sql

~~~~

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

~~~~

### 5. Provide a possible reason why the max average composition might change from month to month. Could it signal something is not quite right with the overall business model for Fresh Segments?
~~~~sql

~~~~

