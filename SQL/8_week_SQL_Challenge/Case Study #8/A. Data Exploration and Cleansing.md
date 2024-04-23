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
