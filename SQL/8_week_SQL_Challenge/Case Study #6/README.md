# 🦀 Case Study #6 - Clique Bait
![6](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/3fca08d6-0a1b-4491-a44e-9964f95a2edb)

## 📖 Table of contents:

* [Business task](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%236/README.md#business-task)
* [Entity Relationship Diagram](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%236/README.md#entity-relationship-diagram)
* [Question and Solution](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%236/README.md#question-and-solution)

  * [A. Digital Analysis](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%234/README.md#a-digital-analysis)
  * [B. Product Funnel Analysis](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%234/README.md#b-product-funnel-analysis)
  * [C. Campaigns Analysis](https://github.com/bachbaongan/Portfolio_Data/blob/main/SQL/8_week_SQL_Challenge/Case%20Study%20%234/README.md#c-campaigns-analysis)
     
## Business task: 
Clique Bait is an online seafood store.

In this case study - you are required to support Danny’s vision analyze his dataset and come up with creative solutions to calculate funnel fallout rates for the Clique Bait online store.

## Entity Relationship Diagram
![e6](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/1ef02b3f-4a93-450f-bbb3-15c00a3bc3ba)


## Question and Solution
## A. Digital Analysis
### 1. How many users are there?
~~~~sql

~~~~
#### Output:

### 2. How many cookies does each user have on average?
~~~~sql

~~~~
#### Output:


### 3. What is the unique number of visits by all users per month?
~~~~sql

~~~~
#### Output:


### 4. What is the number of events for each event type?
~~~~sql

~~~~
#### Output:


### 5. What is the percentage of visits which have a purchase event?
~~~~sql

~~~~
#### Output:


### 6. What is the percentage of visits which view the checkout page but do not have a purchase event?
~~~~sql

~~~~
#### Output:


### 7. What are the top 3 pages by number of views?
~~~~sql

~~~~
#### Output:


### 8. What is the number of views and cart adds for each product category?
~~~~sql

~~~~
#### Output:


### 9. What are the top 3 products by purchase?
~~~~sql

~~~~
#### Output:


## B. Product Funnel Analysis
Using a single SQL query - create a new output table which has the following details:

* How many times was each product viewed?
* How many times was each product added to the cart?
* How many times was each product added to a cart but not purchased (abandoned)?
* How many times was each product purchased?

~~~~sql

~~~~

Additionally, create another table which further aggregates the data for the above points but this time for each product category instead of individual products.

~~~~sql

~~~~

Use your 2 new output tables - answer the following questions:

### 1. Which product had the most views, cart adds and purchases?
~~~~sql

~~~~
#### Output:


### 2. Which product was most likely to be abandoned?
~~~~sql

~~~~
#### Output:


### 3. Which product had the highest view to purchase percentage?
~~~~sql

~~~~
#### Output:


### 4. What is the average conversion rate from view to cart add?
~~~~sql

~~~~
#### Output:


### 5. What is the average conversion rate from cart add to purchase?
~~~~sql

~~~~
#### Output:


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

Use the subsequent dataset to generate at least 5 insights for the Clique Bait team - bonus: prepare a single A4 infographic that the team can use for their management reporting sessions, be sure to emphasise the most important points from your findings.

Some ideas you might want to investigate further include:

* Identifying users who have received impressions during each campaign period and comparing each metric with other users who did not have an impression event
* Does clicking on an impression lead to higher purchase rates?
* What is the uplift in purchase rate when comparing users who click on a campaign impression versus users who do not receive an impression? What if we compare them with users who just an impression but do not click?
* What metrics can you use to quantify the success or failure of each campaign compared to eachother?
