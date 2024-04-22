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

The `ranking` and `percentage_ranking` relate to the order of `index_value` records in each month and year.

### Interest Map
This mapping table links the `interest_id` with their relevant interest information. You will need to join this table onto the previous `interest_details` table to obtain the `interest_name` as well as any details about the summary information.
15 out of 1209 rows
![Screenshot 2024-04-16 at 12 25 18 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/a9d622d3-2c68-4491-9173-ccd7924482ad)


## Question and Solution
## A. Data Exploration and Cleansing
### 1. Update the `fresh_segments.interest_metrics` table by modifying the `month_year` column to be a date data type with the start of the month

### 2. What is the count of records in the `fresh_segments.interest_metrics` for each `month_year` value sorted in chronological order (earliest to latest) with the null values appearing first?
### 3. What do you think we should do with these null values in the `fresh_segments.interest_metrics`?
### 4. How many `interest_id` values exist in the `fresh_segments.interest_metrics` table but not in the fresh_segments.interest_map table? What about the other way around?
### 5. Summarise the id values in the `fresh_segments.interest_map` by its total record count in this table
### 6. What sort of table join should we perform for our analysis and why? Check your logic by checking the rows where `interest_id = 21246` in your joined output and include all columns from fresh_segments.interest_metrics and all columns from `fresh_segments.interest_map` except the `id` column.
### 7. Are there any records in your joined table where the month_year value is before the `created_at` value from the `fresh_segments.interest_map` table? Do you think these values are valid and why?

## B. Interest Analysis
### 1. Which interests have been present in all `month_year` dates in our dataset?
### 2. Using this same `total_months` measure - calculate the cumulative percentage of all records starting at 14 months - which `total_months` value passes the 90% cumulative percentage value?
### 3. If we were to remove all `interest_id` values which are lower than the `total_months` value we found in the previous question - how many total data points would we be removing?
### 4. Does this decision make sense to remove these data points from a business perspective? Use an example where there are all 14 months present to a removed `interest` example for your arguments - think about what it means to have fewer months present from a segment perspective.
### 5. After removing these interests - how many unique interests are there for each month?

## C. Segment Analysis
### 1. Using our filtered dataset by removing the interests with less than 6 months' worth of data, which are the top 10 and bottom 10 interests which have the largest composition values in any `month_year`? Only use the maximum composition value for each interest but you must keep the corresponding `month_year`
### 2. Which 5 interests had the lowest average `ranking` value?
### 3. Which 5 interests had the largest standard deviation in their `percentile_ranking` value?
### 4. For the 5 interests found in the previous question - what were the minimum and maximum `percentile_ranking` values for each interest and its corresponding `year_month` value? Can you describe what is happening for these 5 interests?
### 5. How would you describe our customers in this segment based on their composition and ranking values? What sort of products or services should we show to these customers and what should we avoid?

## D. Index Analysis
The `index_value` is a measure which can be used to reverse calculate the average composition for Fresh Segments’ clients.

Average composition can be calculated by dividing the `composition` column by the `index_value` column rounded to 2 decimal places.

### 1. What are the top 10 interests by the average composition for each month?
### 2. For all of these top 10 interests - which interest appears the most often?
### 3. What is the average of the average composition for the top 10 interests for each month?
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

### 5. Provide a possible reason why the max average composition might change from month to month. Could it signal something is not quite right with the overall business model for Fresh Segments?
