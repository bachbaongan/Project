CREATE DATABASE northwind;
USE northwind;

-- Create tables
CREATE TABLE categories (
    category_id int NOT NULL,
    category_name varchar(15) NOT NULL,
    description text
);

CREATE TABLE customer_customer_demo (
    customer_id varchar(20) NOT NULL,
    customer_type_id varchar(20) NOT NULL
);

CREATE TABLE customer_demographics (
    customer_type_id varchar(5) NOT NULL,
    customer_desc text
);

CREATE TABLE customers (
    customer_id varchar(5) NOT NULL,
    company_name varchar(40) NOT NULL,
    contact_name varchar(30),
    contact_title varchar(30),
    address varchar(60),
    city varchar(15),
    region varchar(15),
    postal_code varchar(10),
    country varchar(15),
    phone varchar(24),
    fax varchar(24)
);

CREATE TABLE employees (
    employee_id int NOT NULL,
    last_name varchar(20) NOT NULL,
    first_name varchar(10) NOT NULL,
    title varchar(30),
    title_of_courtesy varchar(25),
    birth_date date,
    hire_date date,
    address varchar(60),
    city varchar(15),
    region varchar(15),
    postal_code varchar(10),
    country varchar(15),
    home_phone varchar(24),
    extension varchar(4),
    notes text,
    reports_to int,
    photo_path varchar(255)
);

CREATE TABLE employee_territories (
    employee_id int NOT NULL,
    territory_id varchar(20) NOT NULL
);

CREATE TABLE order_details (
    order_id int NOT NULL,
    product_id int NOT NULL,
    unit_price real NOT NULL,
    quantity int NOT NULL,
    discount real NOT NULL
);

CREATE TABLE orders (
    order_id int NOT NULL,
    customer_id varchar(5),
    employee_id int,
    order_date date,
    required_date date,
    shipped_date date,
    ship_via int,
    freight real,
    ship_name varchar(40),
    ship_address varchar(60),
    ship_city varchar(15),
    ship_region varchar(15),
    ship_postal_code varchar(10),
    ship_country varchar(15)
);

CREATE TABLE products (
    product_id int NOT NULL,
    product_name varchar(40) NOT NULL,
    supplier_id int,
    category_id int,
    quantity_per_unit varchar(20),
    unit_price real,
    units_in_stock int,
    units_on_order int,
    reorder_level int,
    discontinued integer NOT NULL
);


CREATE TABLE region (
    region_id int NOT NULL,
    region_description varchar(60) NOT NULL
);

CREATE TABLE shippers (
    shipper_id int NOT NULL,
    company_name varchar(40) NOT NULL,
    phone varchar(24)
);

CREATE TABLE suppliers (
    supplier_id int NOT NULL,
    company_name varchar(40) NOT NULL,
    contact_name varchar(30),
    contact_title varchar(30),
    address varchar(60),
    city varchar(15),
    region varchar(15),
    postal_code varchar(10),
    country varchar(15),
    phone varchar(24),
    fax varchar(24),
    homepage text
);

CREATE TABLE territories (
    territory_id varchar(20) NOT NULL,
    territory_description varchar(60) NOT NULL,
    region_id int NOT NULL
);

CREATE TABLE us_states (
    state_id int NOT NULL,
    state_name varchar(100),
    state_abbr varchar(2),
    state_region varchar(50)
);

-- Create Primary key, Foreign key 
ALTER TABLE categories
	ADD CONSTRAINT pk_categories PRIMARY KEY (category_id);

ALTER TABLE customer_customer_demo
    ADD CONSTRAINT pk_customer_customer_demo PRIMARY KEY (customer_id, customer_type_id);
    
ALTER TABLE customer_demographics
    ADD CONSTRAINT pk_customer_demographics PRIMARY KEY (customer_type_id);

ALTER TABLE employees
    ADD CONSTRAINT pk_employees PRIMARY KEY (employee_id);
    
ALTER TABLE employee_territories
    ADD CONSTRAINT pk_employee_territories PRIMARY KEY (employee_id, territory_id);
    
ALTER TABLE order_details
    ADD CONSTRAINT pk_order_details PRIMARY KEY (order_id, product_id);

ALTER TABLE orders
    ADD CONSTRAINT pk_orders PRIMARY KEY (order_id);
    
ALTER TABLE products
    ADD CONSTRAINT pk_products PRIMARY KEY (product_id);
    
ALTER TABLE region
    ADD CONSTRAINT pk_region PRIMARY KEY (region_id);

ALTER TABLE shippers
    ADD CONSTRAINT pk_shippers PRIMARY KEY (shipper_id);
    
ALTER TABLE suppliers
    ADD CONSTRAINT pk_suppliers PRIMARY KEY (supplier_id);

ALTER TABLE territories
    ADD CONSTRAINT pk_territories PRIMARY KEY (territory_id);

ALTER TABLE us_states
    ADD CONSTRAINT pk_usstates PRIMARY KEY (state_id);

ALTER TABLE orders
    ADD CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

ALTER TABLE orders
    ADD CONSTRAINT fk_orders_employees FOREIGN KEY (employee_id) REFERENCES employees(employee_id);

ALTER TABLE orders
    ADD CONSTRAINT fk_orders_shippers FOREIGN KEY (ship_via) REFERENCES shippers(shipper_id);

ALTER TABLE order_details
    ADD CONSTRAINT fk_order_details_products FOREIGN KEY (product_id) REFERENCES products(product_id);

ALTER TABLE order_details
    ADD CONSTRAINT fk_order_details_orders FOREIGN KEY (order_id) REFERENCES orders(order_id);

ALTER TABLE products
    ADD CONSTRAINT fk_products_categories FOREIGN KEY (category_id) REFERENCES categories(category_id);

ALTER TABLE products
    ADD CONSTRAINT fk_products_suppliers FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id);

ALTER TABLE territories
    ADD CONSTRAINT fk_territories_region FOREIGN KEY (region_id) REFERENCES region(region_id);

ALTER TABLE employee_territories
    ADD CONSTRAINT fk_employee_territories_territories FOREIGN KEY (territory_id) REFERENCES territories(territory_id);

ALTER TABLE employee_territories
    ADD CONSTRAINT fk_employee_territories_employees FOREIGN KEY (employee_id) REFERENCES employees(employee_id);

ALTER TABLE customer_customer_demo
    ADD CONSTRAINT fk_customer_customer_demo_customer_demographics FOREIGN KEY (customer_type_id) REFERENCES customer_demographics(customer_type_id);

ALTER TABLE customer_customer_demo
    ADD CONSTRAINT fk_customer_customer_demo_customers FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

ALTER TABLE employees
    ADD CONSTRAINT fk_employees_employees FOREIGN KEY (reports_to) REFERENCES employees(reports_to);

