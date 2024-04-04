# 🛒 Case Study #5 - Data Mart
![5](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/c4e43105-9fb0-4994-abe3-07eb03cbf101)

## 📖 Table of contents:

* [Business task](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%235/README.md#business-task)
* [Entity Relationship Diagram](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%235/README.md#entity-relationship-diagram)
* [Question and Solution](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%235/README.md#question-and-solution)

  * [A. Data Cleansing Steps](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%235/README.md#a-data-cleansing-steps)
  * [B. Data Exploration](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%235/README.md#b-data-exploration)
  * [C. Before & After Analysis](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%235/README.md#c-before--after-analysis)
  * [D. Bonus Question](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%235/README.md#d-bonus-question)
    
## Business task: 
Data Mart is Danny’s latest venture and after running international operations for his online supermarket that specializes in fresh produce - Danny is asking for your support to analyze his sales performance.

In June 2020 - large-scale supply changes were made at Data Mart. All Data Mart products now use sustainable packaging methods in every single step from the farm to the customer.

Danny needs your help to quantify the impact of this change on the sales performance of Data Mart and its separate business areas.

The key business questions he wants you to help him answer are the following:

* What was the quantifiable impact of the changes introduced in June 2020?
* Which platform, region, segment and customer types were impacted most by this change?
* What can we do about the future introduction of similar sustainability updates to the business to minimize the impact on sales?

## Entity Relationship Diagram
![case-study-5-erd](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/b9b87431-a62d-4118-a5ba-f07f70732cb0)

## Column Dictionary

The columns are pretty self-explanatory based on the column names but here are some further details about the dataset:

* Data Mart has international operations using a multi-`region` strategy
* Data Mart has both, a retail and online `platform` in the form of a Shopify storefront to serve their customers
* Customer `segment` and `customer_type` data relates to personal age and demographic information that is shared with Data Mart
* `transactions` is the count of unique purchases made through Data Mart and `sales` is the actual dollar amount of purchases

Each record in the dataset is related to a specific aggregated slice of the underlying sales data rolled up into a `week_date` value which represents the start of the sales week.

10 random rows are shown in the table output below from `data_mart.weekly_sales`:
![Screenshot 2024-04-04 at 12 36 34 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/baf4afac-9b7d-4d4a-baec-015b8fc3fa10)

## Question and Solution
## A. Data Cleansing Steps
In a single query, perform the following operations and generate a new table in the `data_mart` schema named `clean_weekly_sales`:

* Convert the week_date to a DATE format
* Add a `week_number` as the second column for each `week_date` value, for example, any value from the 1st of January to the 7th of January will be 1, the 8th to 14th will be 2 etc
* Add a `month_number` with the calendar month for each `week_date` value as the 3rd column
* Add a `calendar_year` column as the 4th column containing either 2018, 2019 or 2020 values
* Add a new column called `age_band` after the original segment column using the following mapping on the number inside the `segment` value

segment	| age_band
---|---
1|Young Adults
2|Middle Aged
3 or 4|Retirees

* Add a new `demographic` column using the following mapping for the first letter in the segment values:
  
segment	| demographic
---|---
C |	Couples
F	| Families

* Ensure all `null` string values with an "unknown" string value in the original `segment` column as well as the new `age_band` and `demographic` columns
* Generate a new `avg_transaction` column as the sales value divided by `transactions` rounded to 2 decimal places for each record
~~~~sql
DROP TABLE IF EXISTS clean_weekly_sales;
CREATE TEMP TABLE clean_weekly_sales AS (
SELECT 
TO_DATE(week_date,'DD/MM/YY') as week_date,
EXTRACT(WEEK FROM TO_DATE(week_date,'DD/MM/YY')) as week_number,
EXTRACT(MONTH FROM TO_DATE(week_date,'DD/MM/YY')) as month_number,
EXTRACT(YEAR FROM TO_DATE(week_date,'DD/MM/YY')) as calendar_year,
region,platform,segment,
CASE WHEN RIGHT(segment,1) ='1' THEN 'Young Adults'
	 WHEN RIGHT(segment,1) ='2' THEN 'Middle Aged'
	 WHEN RIGHT(segment,1) IN ('3','4') THEN 'Retirees' 
	 ELSE 'unknown' END as age_band,
CASE WHEN LEFT(segment,1) ='C' THEN 'Couples'
	 WHEN LEFT(segment,1) ='F' THEN 'Families' 
	 ELSE 'unknown' END as demographic,
customer_type,transactions,sales,
ROUND(CAST(sales AS numeric)/transactions,2) as avg_transaction
FROM data_mart.weekly_sales
);
~~~~
#### Output:
* 12 rows of output*
![Screenshot 2024-04-04 at 1 21 03 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/ec022414-c407-4289-91b7-6629ef87893b)


## B. Data Exploration
### 1. What day of the week is used for each `week_date` value?
~~~~sql
SELECT DISTINCT TO_CHAR(week_date,'day') as week_day
FROM clean_weekly_sales;
~~~~
#### Output:
![Screenshot 2024-04-04 at 1 20 34 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/31fbbfbc-5701-421a-b982-1f354e349d1c)

### 2. What range of week numbers are missing from the dataset?
~~~~sql
With week_number_generate AS (
SELECT generate_series(1,52) as week_number
)
SELECT DISTINCT week_number_generate.week_number
FROM week_number_generate
LEFT JOIN clean_weekly_sales ON clean_weekly_sales.week_number = week_number_generate.week_number
WHERE clean_weekly_sales.week_number IS NULL; 
~~~~
#### Output:
![Screenshot 2024-04-04 at 1 32 19 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/b13bd30a-17d5-43b8-8e1b-ec6f06eb6a7e)

* The dataset is missing a total of 28 week_number records
* 
### 3. How many total transactions were there for each year in the dataset?
~~~~sql
SELECT calendar_year, SUM(transactions) as total_transactions
FROM clean_weekly_sales
GROUP BY calendar_year
ORDER BY calendar_year;
~~~~
#### Output:
![Screenshot 2024-04-04 at 3 05 56 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/7c5d8317-c4de-4059-b747-225baa47dd8a)

### 4. What is the total sales for each region for each month?
~~~~sql
SELECT region, SUM(sales) as total_sales
FROM clean_weekly_sales
GROUP BY region
ORDER BY region;
~~~~
#### Output:
![Screenshot 2024-04-04 at 3 06 49 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/01558b2f-76e1-4e57-b331-9fb937ac5f32)

### 5. What is the total count of transactions for each platform?
~~~~sql
SELECT platform, SUM(transactions) as total_transactions
FROM clean_weekly_sales
GROUP BY platform
ORDER BY platform;
~~~~
#### Output:
![Screenshot 2024-04-04 at 3 08 12 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/fbbffc0c-84e6-46ab-b756-354648b8b91b)

### 6. What is the percentage of sales for Retail vs Shopify for each month?
~~~~sql
WITH platform_sales AS (
SELECT calendar_year, month_number, platform,
SUM(sales) as monthly_sales
FROM clean_weekly_sales
GROUP BY calendar_year, month_number, platform
ORDER BY calendar_year, month_number, platform
)
SELECT calendar_year, month_number, 
ROUND(100.0*MAX(CASE WHEN platform ='Retail' THEN monthly_sales ELSE 0 END)
/SUM(monthly_sales),2) as retail_percentage,
ROUND(100.0*MAX(CASE WHEN platform ='Shopify' THEN monthly_sales ELSE 0 END)
/SUM(monthly_sales),2) as shopify_percentage
FROM platform_sales
GROUP BY calendar_year, month_number
ORDER BY calendar_year, month_number;
~~~~
#### Output:
![Screenshot 2024-04-04 at 3 14 32 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/42d42567-d9ae-460f-81a6-bbd444016bc9)

### 7. What is the percentage of sales by demographic for each year in the dataset?
~~~~sql
WITH demographic_sales AS (
SELECT calendar_year,  demographic,
SUM(sales) as yearly_sales
FROM clean_weekly_sales
GROUP BY calendar_year, demographic
ORDER BY calendar_year, demographic
)
SELECT calendar_year, 
ROUND(100.0*MAX(CASE WHEN demographic ='Couples' THEN yearly_sales ELSE 0 END)
/SUM(yearly_sales),2) as couples_percentage,
ROUND(100.0*MAX(CASE WHEN demographic ='Families' THEN yearly_sales ELSE 0 END)
/SUM(yearly_sales),2) as families_percentage,
ROUND(100.0*MAX(CASE WHEN demographic ='unknown' THEN yearly_sales ELSE 0 END)
/SUM(yearly_sales),2) as unknown_percentage
FROM demographic_sales
GROUP BY calendar_year
ORDER BY calendar_year;
~~~~
#### Output:
![Screenshot 2024-04-04 at 3 17 59 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/01665358-4ee2-4af7-8d05-90ed83f758e4)

### 8. Which `age_band` and `demographic` values contribute the most to Retail sales?
~~~~sql
WITH demographic_sales AS (
SELECT calendar_year,  demographic,
SUM(sales) as yearly_sales
FROM clean_weekly_sales
GROUP BY calendar_year, demographic
ORDER BY calendar_year, demographic
)
SELECT calendar_year, 
ROUND(100.0*MAX(CASE WHEN demographic ='Couples' THEN yearly_sales ELSE 0 END)
/SUM(yearly_sales),2) as couples_percentage,
ROUND(100.0*MAX(CASE WHEN demographic ='Families' THEN yearly_sales ELSE 0 END)
/SUM(yearly_sales),2) as families_percentage,
ROUND(100.0*MAX(CASE WHEN demographic ='unknown' THEN yearly_sales ELSE 0 END)
/SUM(yearly_sales),2) as unknown_percentage
FROM demographic_sales
GROUP BY calendar_year
ORDER BY calendar_year;
~~~~
#### Output:
![Screenshot 2024-04-04 at 5 19 31 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/ba25da71-8994-4131-a637-5f1430e0fd49)

The bulk of retail sales, amounting to 40.52%, is attributed to an unidentified age group and demographic. Subsequently, retired families contribute 16.73% to overall retail sales, followed closely by retired couples, who account for 16.07% of the total sales.

### 9. Can we use the `avg_transaction` column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?
~~~~sql
SELECT calendar_year, platform, 
ROUND(AVG(avg_transaction),0) as Avg_transaction_row,
ROUND(SUM(sales)/SUM(transactions),0) as avg_transaction_group
FROM clean_weekly_sales
GROUP BY calendar_year, platform;
~~~~
#### Output:
![Screenshot 2024-04-04 at 5 20 39 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/cb659f87-d819-4d70-bd86-69bfad7c0737)

The distinction between avg_transaction_row and avg_transaction_group lies in their calculation methods.

* avg_transaction_row calculates the average transaction size by dividing the sales of each row by the number of transactions in that row
* avg_transaction_group calculates the average transaction size by dividing the total sales for the entire dataset by the total number of transactions

For precise determination of the average transaction size for each year by platform, it is advisable to utilize avg_transaction_group

## C. Before & After Analysis
This technique is usually used when we inspect an important event and want to inspect the impact before and after a certain point in time.

Taking the `week_date` value of `2020-06-15` as the baseline week where the Data Mart sustainable packaging changes came into effect.

We would include all `week_date` values for `2020-06-15` as the start of the period after the change and the previous `week_date` values would be before

Using this analysis approach - answer the following questions:

### 1. What are the total sales for the 4 weeks before and after 2020-06-15? What is the growth or reduction rate in actual values and percentage of sales?
First, we need to determine which week_number corresponds to '2020-06-15' to use for further analysis
~~~~sql
SELECT DISTINCT week_number
FROM clean_weekly_sales
WHERE week_date ='2020-06-15';
~~~~
![Screenshot 2024-04-04 at 4 47 18 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/9ccdd36e-579b-482c-bbca-5cca1fd23b44)

* The week_number correspoding to '2020-06-15' is 25

~~~~sql
WITH SUB AS (
SELECT 
SUM(CASE WHEN week_number BETWEEN 21 AND 24 THEN sales ELSE 0 END) as before_baseline,
SUM(CASE WHEN week_number BETWEEN 25 AND 28 THEN sales ELSE 0 END) as after_baseline
FROM clean_weekly_sales
WHERE calendar_year= 2020
)
SELECT after_baseline - before_baseline as sales_variance,
ROUND(100.0*(after_baseline-before_baseline)/before_baseline,2) as variance_percentage
FROM sub;
~~~~
![4 w 2020](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/dfbdbbba-bd3b-4c6f-bd0c-dfda21d3e2bc)

Since the introduction of the new sustainable packaging, there has been a decrease in sales, amounting to $26,884,188, indicating a negative change of 1.15%. It's important to note that implementing new packaging doesn't always guarantee positive outcomes, as customers may not immediately recognize the product on shelves due to the packaging change.

### 2. What about the entire 12 weeks before and after?
~~~~sql
WITH SUB AS (
SELECT 
SUM(CASE WHEN week_number BETWEEN 13 AND 24 THEN sales ELSE 0 END) as before_baseline,
SUM(CASE WHEN week_number BETWEEN 25 AND 37 THEN sales ELSE 0 END) as after_baseline
FROM clean_weekly_sales
WHERE calendar_year= 2020
)
SELECT after_baseline - before_baseline as sales_variance,
ROUND(100.0*(after_baseline-before_baseline)/before_baseline,2) as variance_percentage
FROM sub;
~~~~
#### Output:
![12 w 2020](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/bc63fdfd-1582-4c15-a190-3ccc4f737e1b)


### 3. How do the sales metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?
**4 weeks before baseline**
~~~~sql
WITH SUB AS (
SELECT calendar_year, 
SUM(CASE WHEN week_number BETWEEN 21 AND 24 THEN sales ELSE 0 END) as before_baseline,
SUM(CASE WHEN week_number BETWEEN 25 AND 28 THEN sales ELSE 0 END) as after_baseline
FROM clean_weekly_sales
GROUP BY calendar_year
)
SELECT calendar_year, after_baseline - before_baseline as sales_variance,
ROUND(100.0*(after_baseline-before_baseline)/before_baseline,2) as variance_percentage
FROM sub;
~~~~
#### Output:
![4 w 3 ye](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/224866c3-000b-4213-991f-fb18e4b421f6)

**12 weeks before baseline**
~~~~sql
WITH SUB AS (
SELECT calendar_year, 
SUM(CASE WHEN week_number BETWEEN 13 AND 24 THEN sales ELSE 0 END) as before_baseline,
SUM(CASE WHEN week_number BETWEEN 25 AND 37 THEN sales ELSE 0 END) as after_baseline
FROM clean_weekly_sales
GROUP BY calendar_year
)
SELECT calendar_year, after_baseline - before_baseline as sales_variance,
ROUND(100.0*(after_baseline-before_baseline)/before_baseline,2) as variance_percentage
FROM sub;
~~~~
#### Output:
![12 w 3 year](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/7aea6992-4d76-4a8d-bca2-2d8ea0e17911)

## D. Bonus Question
Which areas of the business have the highest negative impact in sales metrics performance in 2020 for the 12-week before and after period?

* region
~~~~sql
WITH SUB AS (
SELECT region, 
SUM(CASE WHEN week_number BETWEEN 13 AND 24 THEN sales ELSE 0 END) as before_baseline,
SUM(CASE WHEN week_number BETWEEN 25 AND 37 THEN sales ELSE 0 END) as after_baseline
FROM clean_weekly_sales
GROUP BY region
)
SELECT region, after_baseline - before_baseline as sales_variance,
ROUND(100.0*(after_baseline-before_baseline)/before_baseline,2) as variance_percentage
FROM sub
ORDER BY variance_percentage;
~~~~
#### Output:
![Screenshot 2024-04-04 at 5 40 55 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/ff8ab95f-6034-45c2-be67-824a5dd6c52e)

**Insights and recommendations:**
After switching to new packaging, sales declined in most countries. The most pronounced drop occurred in Asia, with a decrease of 1.33%. To mitigate this, Danny should consider reducing the number of products featuring sustainable packaging in this region. Conversely, Europe experienced a noteworthy increase of 4.96%, while Africa saw a modest rise of 1.1%. These regions present opportunities for Danny to allocate more resources and investment.
  
* platform
~~~~sql
WITH SUB AS (
SELECT platform, 
SUM(CASE WHEN week_number BETWEEN 13 AND 24 THEN sales ELSE 0 END) as before_baseline,
SUM(CASE WHEN week_number BETWEEN 25 AND 37 THEN sales ELSE 0 END) as after_baseline
FROM clean_weekly_sales
GROUP BY platform
)
SELECT platform, after_baseline - before_baseline as sales_variance,
ROUND(100.0*(after_baseline-before_baseline)/before_baseline,2) as variance_percentage
FROM sub
ORDER BY variance_percentage;
~~~~
#### Output:
![Screenshot 2024-04-04 at 5 41 07 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/17dbf017-24af-4957-9df6-1a1cbcee9a7d)

**Insights and recommendations:**
Sales for Shopify stores surged by 9.35%, whereas retail stores experienced a slight decline of 0.59%. Danny should consider prioritizing the placement of products with sustainable packaging in Shopify stores to capitalize on this trend.
  
* age_band
~~~~sql
WITH SUB AS (
SELECT age_band, 
SUM(CASE WHEN week_number BETWEEN 13 AND 24 THEN sales ELSE 0 END) as before_baseline,
SUM(CASE WHEN week_number BETWEEN 25 AND 37 THEN sales ELSE 0 END) as after_baseline
FROM clean_weekly_sales
GROUP BY age_band
)
SELECT age_band, after_baseline - before_baseline as sales_variance,
ROUND(100.0*(after_baseline-before_baseline)/before_baseline,2) as variance_percentage
FROM sub
ORDER BY variance_percentage;
~~~~
#### Output:
![Screenshot 2024-04-04 at 5 41 39 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/567e7f7e-cb6d-42c6-a53a-b1a1a648535e)

**Insights and recommendations:**
Sales across all age groups experienced a slight decrease. However, the Middle-Aged and Young Adult segments were more adversely affected than Retirees. It's advisable not to target these age groups with new packaging initiatives.
  
* demographic
~~~~sql
WITH SUB AS (
SELECT demographic, 
SUM(CASE WHEN week_number BETWEEN 13 AND 24 THEN sales ELSE 0 END) as before_baseline,
SUM(CASE WHEN week_number BETWEEN 25 AND 37 THEN sales ELSE 0 END) as after_baseline
FROM clean_weekly_sales
GROUP BY demographic
)
SELECT demographic, after_baseline - before_baseline as sales_variance,
ROUND(100.0*(after_baseline-before_baseline)/before_baseline,2) as variance_percentage
FROM sub
ORDER BY variance_percentage;
~~~~
#### Output:
![Screenshot 2024-04-04 at 5 42 01 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/91fa2222-50e5-41cb-a3dd-12f35553aecd)

**Insights and recommendations:**
There was a slight decrease in sales across all demographic groups. Couples experienced a more pronounced negative impact on sales compared to Families. It would be prudent not to target these groups with new packaging strategies. 

* customer_type
~~~~sql
WITH SUB AS (
SELECT customer_type, 
SUM(CASE WHEN week_number BETWEEN 13 AND 24 THEN sales ELSE 0 END) as before_baseline,
SUM(CASE WHEN week_number BETWEEN 25 AND 37 THEN sales ELSE 0 END) as after_baseline
FROM clean_weekly_sales
GROUP BY customer_type
)
SELECT customer_type, after_baseline - before_baseline as sales_variance,
ROUND(100.0*(after_baseline-before_baseline)/before_baseline,2) as variance_percentage
FROM sub
ORDER BY variance_percentage;
~~~~
#### Output:
![Screenshot 2024-04-04 at 5 42 27 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/c15d8907-a9b6-4329-9946-8ff6d2ba2ab1)

**Insights and recommendations:**
Sales declined for both Guests and Existing customers, but there was an increase in sales for New customers. I would need additional analysis to figure out why New customers showed interest in sustainable packages.
