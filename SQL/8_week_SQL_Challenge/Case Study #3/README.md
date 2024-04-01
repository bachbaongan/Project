# 🥑 Case Study #3: Foodie-Fi
![3-2](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/95e36d65-d569-4395-982d-cd4f86df4f3a)

## 📖 Table of contents:

* [Business task](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%233/README.md#business-task)
* [Entity Relationship Diagram](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%233/README.md#entity-relationship-diagram)
* [Question and Solution](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%233/README.md#question-and-solution)

  * [A. Customer Journey](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%233/README.md#a-customer-journey) 
  * [B. Data Analysis Questions](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%233/README.md#b-data-analysis-questions)
  * [C. Challenge Payment Question](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%233/README.md#c-challenge-payment-question)
  * [D. Outside The Box Questions](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%233/README.md#d-outside-the-box-questions)
    
## Business task: 
Danny and his friends launched a new startup Foodie-Fi and started selling monthly and annual subscriptions, giving their customers unlimited on-demand access to exclusive food videos from around the world.

This case study focuses on using subscription-style digital data to answer important business questions on customer journey, payments, and business performances.

## Entity Relationship Diagram
![case-study-3-erd](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/4b72fbc2-4a43-4510-ac8d-38028b734fb9)

### Table 1: Plans
Customers can choose which plans to join Foodie-Fi when they first sign up.

* Basic plan customers have limited access and can only stream their videos and is only available monthly at $9.90
* Pro plan customers have no watch time limits and can download videos for offline viewing.
* Pro plans start at $19.90 monthly or $199 for an annual subscription.
  
Customers can sign up for an initial 7-day free trial and will automatically continue with the pro monthly subscription plan unless they cancel, downgrade to basic or upgrade to an annual pro plan at any point during the trial.

When customers cancel their Foodie-Fi service - they will have a churn plan record with a null price but their plan will continue until the end of the billing period.

<img width="315" alt="Screenshot 2024-03-28 at 4 33 31 PM" src="https://github.com/bachbaongan/Portfolio_Data/assets/144385168/9d60736d-7ae2-4e4d-8dda-99c1bdf047b5">

### Table 2: Subscriptions
Customer subscriptions show the **exact date** when their specific `plan_id` starts.

If customers downgrade from a pro plan or cancel their subscription - the higher plan will remain in place until the period is over - the `start_date` in the subscriptions table will reflect the date that the actual plan changes.

When customers upgrade their account from a basic plan to a pro or annual pro plan - the higher plan will take effect straight away.

When customers churn - they will keep their access until the end of their current billing period but the `start_date` will be technically the day they decide to cancel their service.

<img width="364" alt="Screenshot 2024-03-28 at 4 33 48 PM" src="https://github.com/bachbaongan/Portfolio_Data/assets/144385168/7953778a-e523-469f-a6ed-7277c6426a9e">

## Question and Solution
## A. Customer Journey
### Based on the 8 sample customers provided in the sample from the subscriptions table, write a brief description of each customer’s onboarding journey.

Try to keep it as short as possible - you may also want to run some join to make your explanations a bit easier!
![Screenshot 2024-03-28 at 4 40 33 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/89780832-7389-4a62-895d-5ec7421241d0)
~~~~sql
SELECT s.customer_id, s.plan_id, p.plan_name, s.start_date 
FROM foodie_fi.subscriptions s
JOIN foodie_fi.plans p ON s.plan_id = p.plan_id 
WHERE customer_id IN (1,2,11,13,15,16,18,19)
~~~~
![Screenshot 2024-04-01 at 10 26 06 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/4fab1001-cbd8-4029-9bc3-3cc4271284bd)

I choose 3 customers to show their onboarding journeys

~~~~sql
SELECT s.customer_id, s.plan_id, p.plan_name, s.start_date 
FROM foodie_fi.subscriptions s
JOIN foodie_fi.plans p ON s.plan_id = p.plan_id 
WHERE customer_id =1;
~~~~
![Screenshot 2024-04-01 at 10 27 05 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/fc450375-9ac6-4d47-adbb-308c3116ad9a)

Customer 1: This customer started the free trial on August 1, 2020, then subscribed to the basic monthly plan on August 8 after the trial period ended.

~~~~sql
SELECT s.customer_id, s.plan_id, p.plan_name, s.start_date 
FROM foodie_fi.subscriptions s
JOIN foodie_fi.plans p ON s.plan_id = p.plan_id 
WHERE customer_id =15;
~~~~
![Screenshot 2024-04-01 at 10 32 46 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/80cd5249-7189-48d3-af3b-cb395e7c91c6)

Customer 15: This customer started the free trial on 17 March 2020, and then upgraded to the pro monthly plan after the trial period ended on March 24, 2020. However, the customer decided to terminate their subscription  on April 29, 2020 and subsequently churned until the paid subscription ended. 

~~~~sql
SELECT s.customer_id, s.plan_id, p.plan_name, s.start_date 
FROM foodie_fi.subscriptions s
JOIN foodie_fi.plans p ON s.plan_id = p.plan_id 
WHERE customer_id =19;
~~~~
![Screenshot 2024-04-01 at 10 35 51 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/945b1944-492f-4c75-bbe7-d75c8b3ae564)

Customer 19: This customer started the free trial on June 06, 2020. Following the trial period, on June 29, 2020, they subscribed to the pro monthly plan then they upgraded to the pro annual plan on August 29, 2020.

## B. Data Analysis Questions
### 1. How many customers has Foodie-Fi ever had?
~~~~sql
SELECT COUNT(DISTINCT customer_id) as number_customer
FROM foodie_fi.subscriptions;
~~~~
#### Output:
![Screenshot 2024-04-01 at 10 43 01 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/d0802175-f101-488a-aba7-7481857a0054)

* Foodie-Fi has had 1000 unique customers

### 2. What is the monthly distribution of `trial` plan `start_date` values for our dataset - use the start of the month as the group by value
~~~~sql
SELECT EXTRACT(MONTH FROM s.start_date) as month,COUNT(distinct customer_id)
FROM foodie_fi.subscriptions s
WHERE s.plan_id = 0 --Trial plan has ID 0
GROUP BY EXTRACT(MONTH FROM s.start_date) 
ORDER BY month;
~~~~
#### Output:
![Screenshot 2024-04-01 at 11 32 30 AM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/08db08ed-03d1-4f39-98dc-bc5bb8d0e511)

* March boasts the highest count of trial plans among all months, whereas February records the lowest
### 3. What plan `start_date` values occur after the year 2020 for our dataset? Show the breakdown by a count of events for each `plan_name`
~~~~sql
SELECT p.plan_id, p.plan_name, COUNT(s.plan_id)as number_plan
FROM foodie_fi.subscriptions s
JOIN foodie_fi.plans p ON s.plan_id = p.plan_id
WHERE EXTRACT(YEAR FROm s.start_date) >=2021
GROUP BY p.plan_id, p.plan_name
ORDER BY p.plan_id;
~~~~
#### Output:
![Screenshot 2024-04-01 at 1 42 48 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/1d195c5a-0a2a-4964-87de-0a5962d800ce)

### 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
~~~~sql
SELECT COUNT(s.customer_id) as churn_customer,
ROUND(COUNT(s.customer_id)/CAST((SELECT COUNT(DISTINCT customer_id) 
								                         FROM foodie_fi.subscriptions) as Numeric)*100,1) as percentage_churn_customer
FROM foodie_fi.subscriptions s
JOIN foodie_fi.plans p ON s.plan_id = p.plan_id
WHERE p.plan_name ='churn'
~~~~
#### Output: 
![Screenshot 2024-04-01 at 1 49 55 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/77ab3832-4bd7-449a-9d52-077e2ee0b6a4)

* A total of 307 customers have churned from Foodie-Fi, representing a significant portion of approximately 30.7% of the overall customer count

### 5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
~~~~sql
WITH sub as (
SELECT *, 
LAG(plan_id) OVER (PARTITION BY customer_id) as previous_plan
FROM foodie_fi.subscriptions
) 
SELECT p.plan_name, COUNT(sub.customer_id) as churned_customer,
ROUND(COUNT(sub.customer_id)/ 
	  CAST((SELECT COUNT(DISTINCT customer_id) 
		    FROM foodie_fi.subscriptions) AS Numeric)*100,0) as percentage_trial_churn_customer
FROM sub 
JOIN foodie_fi.plans p ON p.plan_id = sub.plan_id
WHERE previous_plan =0 AND p.plan_name = 'churn'
GROUP BY p.plan_name;
~~~~
#### Output:
![Screenshot 2024-04-01 at 2 18 30 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/3ad33791-3ce9-4c19-92e4-504d112641e8)


* Following the initial free trial period, a total of 92 customers churned, which accounts for roughly 9% of the entire customer base.
### 6. What is the number and percentage of customer plans after their initial free trial?
~~~~sql
WITH sub as (
SELECT *, 
LAG(plan_id) OVER (PARTITION BY customer_id) as previous_plan
FROM foodie_fi.subscriptions
) 
SELECT sub.plan_id, p.plan_name, COUNT(sub.customer_id) as planned_customer,
ROUND(COUNT(sub.customer_id)/ CAST((SELECT COUNT(DISTINCT customer_id) 
		    FROM foodie_fi.subscriptions) AS Numeric)*100,1) as percentage_planned_customer
FROM sub  
JOIN foodie_fi.plans p ON p.plan_id = sub.plan_id
WHERE previous_plan =0 
GROUP BY sub.plan_id, p.plan_name;
~~~~
#### Output:
![Screenshot 2024-04-01 at 2 32 15 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/9286e061-a791-4912-9a6e-71982c40d7b4)


* Over 80% of Foodie-Fi's customer base is subscribed to paid plans, with the majority favouring Plans 1 and 2. However, there is notable room for enhancement in customer acquisition strategies for Plan 3, as it attracts only a minimal percentage of customers despite being a higher-priced option.
  
### 7. What is the customer count and percentage breakdown of all 5 `plan_name` values on `2020-12-31`?
~~~~sql
WITH sub AS (
SELECT *,
DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY start_Date DESC) As lastest
FROM foodie_fi.subscriptions
WHERE start_date <='2020-12-31'
)
SELECT sub.plan_id, p.plan_name, COUNT(customer_id) as number_customer,
ROUND(COUNT(sub.customer_id)/ CAST((SELECT COUNT(DISTINCT customer_id) 
		    FROM foodie_fi.subscriptions) AS Numeric)*100,1) as percentage_customer
FROM sub
JOIN foodie_fi.plans p ON p.plan_id = sub.plan_id
WHERE lastest = 1
GROUP BY sub.plan_id, p.plan_name;
~~~~
#### Output:
![Screenshot 2024-04-01 at 2 32 38 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/5d300b46-8d58-4fcc-b70c-1509b3ef8b73)

### 8. How many customers have upgraded to an annual plan in 2020?
~~~~sql
SELECT COUNT(customer_id) as number_annual_plan_customer
FROM foodie_fi.subscriptions
WHERE plan_id = 3 --Pro annual plan has ID 3
AND EXTRACT(YEAR from start_date) ='2020';
~~~~
#### Output: 
![Screenshot 2024-04-01 at 2 35 58 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/730deda7-5ce3-4803-840b-118373cc7869)

* There are 195 customers upgraded to the pro annual plan in 2020
  
### 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
~~~~sql
WITH sub as (
SELECT *,
MIN(start_date) OVER (PARTITION BY customer_id) as join_date
FROM foodie_fi.subscriptions s
)
SELECT ROUND(AVG(start_date - join_date),0) as average_days_to_upgrade
FROm sub
WHERE plan_id = 3;
~~~~
#### Output:
![Screenshot 2024-04-01 at 2 51 52 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/4772d329-04da-4502-99c7-ead627ef3dc5)

* On average, customers take approximately 105 days from the day they join Foodie-Fi to upgrade to the pro annual plan.
  
### 10. Can you further break this average value into 30-day periods (i.e. 0-30 days, 31-60 days etc)
~~~~sql
WITH sub as (
SELECT *,
MIN(start_date) OVER (PARTITION BY customer_id) as join_date
FROM foodie_fi.subscriptions s
)
, sub2 as (
SELECT start_date - join_date as days_to_upgrade, 
WIDTH_BUCKET(start_date - join_date, 0,365,12) as period_day
-- Put customers in 30-day-period buckets based on the average number of days taken to upgrade to the pro annual plan
FROM sub
WHERE plan_id = 3
)
SELECT CONCAT((period_day -1 )* 30,' - ', period_day*30, ' days') as "30_Day_Period",
COUNT(days_to_upgrade) number_customers
FROM sub2
GROUP BY period_day
ORDER BY period_day;
~~~~
#### Output:
![Screenshot 2024-04-01 at 3 20 00 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/3c2be3ed-f914-456a-97f3-75db4c7ee821)

### 11. How many customers were downgraded from a pro monthly to a basic monthly plan in 2020?
~~~~sql
WITH sub as (
SELECT *,
LAG(plan_id) OVER (PARTITION BY customer_id) as previous_plan
FROM foodie_fi.subscriptions s
WHERE Start_date <='2020-12-31'
)
SELECT COUNT(customer_id) as downgraded_customer
FROM sub
WHERE plan_id = 1 AND previous_plan =2;
~~~~
#### Output:
![Screenshot 2024-04-01 at 3 23 37 PM](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/4969abf4-9e79-4a49-8a63-b6fe604bf24e)

* In 2020, there were no instances customers downgraded from a pro monthly plan to a basis monthly plan
## C. Challenge Payment Question

### The Foodie-Fi team wants you to create a new `payments` table for the year 2020 that includes amounts paid by each customer in the `subscriptions` table with the following requirements:

* monthly payments always occur on the same day of the month as the original `start_date` of any monthly paid plan
* upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately
* upgrades from pro monthly to pro annual are paid at the end of the current billing period and also start at the end of the month period
* once a customer churns they will no longer make payments

### Example template:
customer_id|plan_id	|plan_name|	payment_date|	amount|	payment_order|
----|----|----|----|----|----
~~~~sql

~~~~
#### Output:

## D. Outside The Box Questions
### The following are open-ended questions which might be asked during a technical interview for this case study - there are no right or wrong answers, but answers that make sense from both a technical and a business perspective make an amazing impression!

### 1. How would you calculate the rate of growth for Foodie-Fi?
~~~~sql

~~~~
#### Output:

### 2. What key metrics would you recommend Foodie-Fi management to track over time to assess the performance of their overall business?
~~~~sql

~~~~
#### Output:

### 3. What are some key customer journeys or experiences that you would analyze further to improve customer retention?
~~~~sql

~~~~
#### Output:

### 4. If the Foodie-Fi team were to create an exit survey shown to customers who wish to cancel their subscription, what questions would you include in the survey?
~~~~sql

~~~~
#### Output:

#### 5. What business levers could the Foodie-Fi team use to reduce the customer churn rate? How would you validate the effectiveness of your ideas?
~~~~sql

~~~~
#### Output:

