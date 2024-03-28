# 🥑 Case Study #3: Foodie-Fi
![3-2](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/95e36d65-d569-4395-982d-cd4f86df4f3a)

## 📖 Table of contents:

* [Business task](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%233/README.md#business-task)
* [Entity Relationship Diagram](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%233/README.md#entity-relationship-diagram)
* [Question and Solution](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%233/README.md#question-and-solution)

  * [A. Customer Journey](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%233/README.md#a-customer-journey) 
  * [B. Data Analysis Questions](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%233/README.md#b-data-analysis-questions)
  * [C. Challenge Payment Question]()
  * [D. Outside The Box Questions]()
    
## Business task: 
Danny is expanding his new Pizza Empire and at the same time, he wants to Uberize it, so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

## Entity Relationship Diagram
![case-study-3-erd](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/4b72fbc2-4a43-4510-ac8d-38028b734fb9)

## Question and Solution
## A. Customer Journey
### Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.

Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!
~~~~sql

~~~~
#### Output:

## B. Data Analysis Questions
### 1. How many customers has Foodie-Fi ever had?
~~~~sql

~~~~
#### Output:

### 2. What is the monthly distribution of `trial` plan `start_date` values for our dataset - use the start of the month as the group by value
~~~~sql

~~~~
#### Output:

### 3. What plan `start_date` values occur after the year 2020 for our dataset? Show the breakdown by count of events for each `plan_name`
~~~~sql

~~~~
#### Output:

### 4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
~~~~sql

~~~~
#### Output: 

### 5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
~~~~sql

~~~~
#### Output:

### 6. What is the number and percentage of customer plans after their initial free trial?
~~~~sql

~~~~
#### Output:

### 7. What is the customer count and percentage breakdown of all 5 `plan_name` values on `2020-12-31`?
~~~~sql

~~~~
#### Output:

### 8. How many customers have upgraded to an annual plan in 2020?
~~~~sql

~~~~
#### Output: 

### 9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
~~~~sql

~~~~
#### Output:

### 10. Can you further breakdown this average value into 30-day periods (i.e. 0-30 days, 31-60 days etc)
~~~~sql

~~~~
#### Output:

### 11. How many customers were downgraded from a pro monthly to a basic monthly plan in 2020?
~~~~sql

~~~~
#### Output:


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

