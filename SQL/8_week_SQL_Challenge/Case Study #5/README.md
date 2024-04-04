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

~~~~
#### Output:

## B. Data Exploration
### 1. What day of the week is used for each `week_date` value?
~~~~sql

~~~~
#### Output:

### 2. What range of week numbers are missing from the dataset?
~~~~sql

~~~~
#### Output:

### 3. How many total transactions were there for each year in the dataset?
~~~~sql

~~~~
#### Output:

### 4. What is the total sales for each region for each month?
~~~~sql

~~~~
#### Output:

### 5. What is the total count of transactions for each platform?
~~~~sql

~~~~
#### Output:

### 6. What is the percentage of sales for Retail vs Shopify for each month?
~~~~sql

~~~~
#### Output:

### 7. What is the percentage of sales by demographic for each year in the dataset?
~~~~sql

~~~~
#### Output:

### 8. Which `age_band` and `demographic` values contribute the most to Retail sales?
~~~~sql

~~~~
#### Output:

### 9. Can we use the `avg_transaction` column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?
~~~~sql

~~~~
#### Output:

## C. Before & After Analysis
This technique is usually used when we inspect an important event and want to inspect the impact before and after a certain point in time.

Taking the `week_date` value of `2020-06-15` as the baseline week where the Data Mart sustainable packaging changes came into effect.

We would include all `week_date` values for `2020-06-15` as the start of the period after the change and the previous `week_date` values would be before

Using this analysis approach - answer the following questions:

### 1. What are the total sales for the 4 weeks before and after 2020-06-15? What is the growth or reduction rate in actual values and percentage of sales?
~~~~sql

~~~~
#### Output:

### 2. What about the entire 12 weeks before and after?
~~~~sql

~~~~
#### Output:

### 3. How do the sales metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?
~~~~sql

~~~~
#### Output:

## D. Bonus Question
Which areas of the business have the highest negative impact in sales metrics performance in 2020 for the 12-week before and after period?

* region
* platform
* age_band
* demographic
* customer_type

Do you have any further recommendations for Danny’s team at Data Mart or any interesting insights based off this analysis? 
~~~~sql

~~~~
#### Output:
