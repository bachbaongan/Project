# Project: Customers and Products Analysis Using SQL
Welcome to my project where I will be conducting data analysis on a scale model car database to extract KPI's in order to make smarter decisions.

During this project, there are THREE questions we want to ask ourselves.
 
Question 1: Which products should we order more of or less of?
Question 2: How should we tailor marketing and communication strategies to customer behaviors?
Question 3: How much can we spend on acquiring new customers?


Within the clase model care database, we will be working with 8 tables.

The tables are as follows:

1. productslines table - this table contains product category data. The product line is the primary key. 
This table has a relationship with the product table on the product line column which is a one-to-many relationship.

2. products table - this table contains product data. The productCode is the primary key and productLine the foreign key. 
This table has a relationship with the productlines table on the productLine column which is a many-to-one relationship and 
the orderdetails table on the productCode column which is a one-to-one relationship.

3. orderdetails table - this table contains order details data. The orderNumber & productCode are the composite key. 
This table has a relationship with the products table productCode colum which is a one-to-one relationship and 
the order table on the orderNumber column which is a one-to-one relationship.

4. orders table - this table contains orders recieved data. The orderNumber is the primary key and the customerNumber is the foreign key. 
This table has a relationship with the orderdetails table on the orderNumber table which is a one-to-one relationship and 
the customer table on the customerNumber column which is a many-to-one relationship.

5. customers table - this table contains customer data. The customerNumber is the primary key and salesRepEmployeeNumber is the foreign key. 
This table has a relationship with the orders table on the customerNumber column which is a one-to-many relationship, 
the payments table on the customerNumber column which is a one-to-one relationship and 
the employees table on the employeeNumber column which is a many-to-one relationship.

6. payments table - this table contains payment data. The customerNumber & checkNumber are both the composite key. 
This table has a relationship with the customers table on the customerNumber column which is a one-to-one relationship.

7. employees table - this table contains employee data. The employeeNumber is the primary key and officeCode is the foreign key. 
This table has a self-referencing relationship between the employeeNumber and reportsTo columns which is a one-to-many relationship, 
 the customers table on the salesRepEmployeeNumber column which is a one-to- many relationship and 
 the offices table on teh officeCode column which is a many-to-one relationship.

8. offices table - this table contains office data. The officeCode is the primary Key. 
This table has a relationship with the employees table on the officeCode table which is a one-to-many relationship.
