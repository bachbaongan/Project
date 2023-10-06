# Project: Customers and Products Analysis Using SQL

In this project, I will be conducting data analysis on a scale model car database to extract key performance indicators (KPIs) to make smarter decisions, by answering **THREE questions**:

  * Question 1: Which products should we order more of or less of?
  * Question 2: How should we tailor marketing and communication strategies to customer behaviours?
  * Question 3: How much can we spend on acquiring new customers?

## The scale model cars database schema

Within the class model care database, we will be working with 8 tables.
![Scale model cars database](https://github.com/bachbaongan/Portfolio_Data/assets/144385168/2e0ebeb6-f6a8-4e26-82c4-5da3596b8e4e)

  * Customers: customer data
  * Employees: all employee information
  * Offices: sales office information
  * Orders: customers' sales orders
  * OrderDetails: sales order line for each sales order
  * Payments: customers' payment records
  * Products: a list of scale model cars
  * ProductLines: a list of product line categories


## Database summary
<img width="330" alt="Summary database" src="https://github.com/bachbaongan/Portfolio_Data/assets/144385168/b9e81e19-588a-4a98-8185-880268924b84">

## Question 1 output:
<img width="522" alt="Question 1" src="https://github.com/bachbaongan/Portfolio_Data/assets/144385168/6db3e27b-4c62-48f9-b3f8-7c33c920e65e">

Analyzing the query results of comparing low stock with product performance we can see that, 6 out of 10 cars belong to the 'Classic Cars' product line, 
which we sell frequently with high product performance. Therefore, we should restock "Classic Cars" properly.

## Question 2 output:
**Top 5 VIP customers**

 <img width="392" alt="Question 2 top 5 VIP" src="https://github.com/bachbaongan/Portfolio_Data/assets/144385168/ee285176-b94b-4de4-a0c0-5d1f8717b2bf">

**Top 5 least-engaged customers**

<img width="385" alt="Question 2 top 5 worst" src="https://github.com/bachbaongan/Portfolio_Data/assets/144385168/3f162cb3-343c-4748-8be0-0d04613cdb97">

Analyzing the query results of top and bottom customers in terms of profit generation, we need to offer loyalty rewards and priority services for our top customers to retain them. Also for bottom customers, we need to solicit feedback to better understand their preferences, expected pricing, discounts and offers.

## Question 3 output: 
<img width="104" alt="Question 3" src="https://github.com/bachbaongan/Portfolio_Data/assets/144385168/39a2a286-315d-4868-b8c2-84108ac79082">

The average customer lifetime value of our store is $ 39,040. This means for every new customer we make a profit of 39,040 dollars. We can use this to predict how much we can spend on new customer acquisition, and at the same time maintain or increase our profit levels.
