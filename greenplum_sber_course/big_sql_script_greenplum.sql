-- Table of contents: 
-- 1. Managing Roles and Privileges
-- 2. Resource groups
-- 3. Optimization and analyse
-- 4. Indexes in Greenplum
-- 5. Partition Management


----
-- Managing Roles and Privileges
----

-- Step 1: Create Schema (if it doesn't already exist)
CREATE SCHEMA IF NOT EXISTS sales;

-- Step 2: Create Table sales.orders

drop table sales.orders cascade;
CREATE TABLE sales.orders (
    order_id SERIAL PRIMARY KEY,         -- Auto-incrementing primary key
    customer_id INT NOT NULL,            -- Foreign key to customer table (not included in this script)
    order_date DATE NOT NULL,            -- Date when the order was placed
    status VARCHAR(50) NOT NULL,         -- Order status (e.g., 'Pending', 'Shipped', 'Delivered')
    total_amount NUMERIC(10, 2) NOT NULL -- Total order amount with two decimal places
	-- dwh_date timedate default now()   
);
-- distributed by (order_id); = order_id  PRIMARY KEY

SELECT * FROM sales.orders;
SELECT gp_segment_id, count() FROM sales.orders group by gp_segment_id;

--Посмотреть перекос
--select * from gp_toolkit.gp_skew_coefficients;


-- Step 1: Create a Role (User)
CREATE ROLE data_analyst LOGIN PASSWORD 'password123';

-- Step 2: Create Another Role (Administrator)
CREATE ROLE db_admin;

-- Step 3: Grant Privileges to Roles
GRANT USAGE ON SCHEMA sales TO data_analyst;
GRANT SELECT ON ALL TABLES IN SCHEMA sales TO data_analyst;

GRANT ALL PRIVILEGES ON SCHEMA sales TO db_admin;
--grant <select , update>, on table to rw;

-- Step 4: Assign Roles to Users
GRANT db_admin TO data_analyst;

-- Step 5: Create a Group Role
CREATE ROLE reporting_team;

GRANT reporting_team TO data_analyst;

-- Step 6: Revoke Privileges
REVOKE SELECT ON TABLE sales.orders FROM data_analyst;

-- Step 7: Managing Privileges for New Tables Automatically
ALTER DEFAULT PRIVILEGES IN SCHEMA sales GRANT SELECT ON TABLES TO data_analyst;

-- Step 8: Dropping Roles
DROP ROLE IF EXISTS db_admin;
DROP ROLE IF EXISTS data_analyst;




----
-- Resource groups
----

-- View active resource groups and their configuration
SELECT * FROM pg_resgroup;

-- View current resource group statistics
SELECT * FROM gp_toolkit.gp_resgroup_config;
SELECT * FROM gp_toolkit.gp_resgroup_status;
SELECT * FROM gp_toolkit.gp_resgroup_status_per_host;

SELECT rolname, rsgname 
FROM pg_roles, pg_resgroup
WHERE pg_roles.rolresgroup=pg_resgroup.oid;

-- Step 1: Create Resource Groups
-- Drop existing resource groups (if they exist) to start fresh
DROP RESOURCE GROUP low_priority_group;
DROP RESOURCE GROUP high_priority_group;
DROP RESOURCE GROUP admins_group;

-- Create a resource group for low-priority queries
CREATE RESOURCE GROUP low_priority_group WITH (
    concurrency=5,                 -- Limit of concurrent queries in this group
    cpu_rate_limit=2,              -- Limit CPU usage to 10%
    memory_limit=20                -- Limit memory usage to 20% of the system memory
);

-- Create a resource group for high-priority queries
CREATE RESOURCE GROUP high_priority_group WITH (
    concurrency=10,                -- Limit of concurrent queries in this group
    cpu_rate_limit=40,             -- Limit CPU usage to 80%
    memory_limit=50                -- Limit memory usage to 50% of the system memory
);

-- Create a resource group for administrative tasks
CREATE RESOURCE GROUP admins_group WITH (
    concurrency=3,                 -- Limit of concurrent administrative tasks
    cpu_rate_limit=5,              -- Limit CPU usage to 5%
    memory_limit=10                -- Limit memory usage to 10% of the system memory
);


-- Step 2: Assign Roles to Resource Groups

-- Assign the 'low_priority_group' to a role called 'data_analyst'
ALTER ROLE data_analyst RESOURCE GROUP low_priority_group;

-- Assign the 'high_priority_group' to a role called 'data_analyst'
ALTER ROLE data_analyst RESOURCE GROUP high_priority_group;

-- Assign the 'admin_group' to the administrator role
ALTER ROLE db_admin RESOURCE GROUP admin_group;


-- Step 3: Alter Resource Group Settings

-- Increase the concurrency for 'high_priority_group'
ALTER RESOURCE GROUP high_priority_group SET concurrency 15;

-- Decrease the memory limit for 'low_priority_group'
ALTER RESOURCE GROUP low_priority_group SET memory_limit 15;

-- Change CPU rate limit for the 'admin_group'
ALTER RESOURCE GROUP admin_group SET cpu_rate_limit 8;



----
-- Optimization and analyse
----

CREATE SCHEMA IF NOT EXISTS sales;

drop table sales.customers;
CREATE TABLE sales.customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    city VARCHAR(50),
    country VARCHAR(50)
);

drop table sales.products cascade;
CREATE TABLE sales.products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price NUMERIC(10, 2) NOT NULL
);

drop table sales.orders cascade;
CREATE TABLE sales.orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES sales.customers(customer_id),
    order_date DATE NOT NULL,
    total_amount NUMERIC(10, 2) NOT NULL,
    status VARCHAR(20)
);

drop table sales.order_items cascade;
CREATE TABLE sales.order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES sales.orders(order_id),
    product_id INT REFERENCES sales.products(product_id),
    quantity INT NOT NULL,
    unit_price NUMERIC(10, 2) NOT NULL
);


-- Insert 10,000 sample customers
INSERT INTO sales.customers (first_name, last_name, email, phone, city, country)
SELECT
    'FirstName_' || gs AS first_name,
    'LastName_' || gs AS last_name,
    'user' || gs || '@example.com' AS email,
    '555-' || LPAD((FLOOR(RANDOM() * 10000))::TEXT, 4, '0') AS phone,
    CASE
        WHEN gs % 5 = 0 THEN 'New York'
        WHEN gs % 5 = 1 THEN 'Los Angeles'
        WHEN gs % 5 = 2 THEN 'Chicago'
        WHEN gs % 5 = 3 THEN 'Houston'
        ELSE 'Phoenix'
    END AS city,
    'USA' AS country
FROM generate_series(1, 10000) AS gs;

-- Insert 10,000 sample products
INSERT INTO sales.products (product_name, category, price)
SELECT
    'Product_' || gs AS product_name,
    CASE
        WHEN gs % 4 = 0 THEN 'Electronics'
        WHEN gs % 4 = 1 THEN 'Accessories'
        WHEN gs % 4 = 2 THEN 'Clothing'
        ELSE 'Home Goods'
    END AS category,
    ROUND((50 + RANDOM() * 950)::numeric, 2) AS price -- Ensure price is numeric
FROM generate_series(1, 10000) AS gs;

-- Insert 10,000 sample orders
INSERT INTO sales.orders (customer_id, order_date, total_amount, status)
SELECT
    (1 + (RANDOM() * 9999)::INT) AS customer_id, -- Random customer_id between 1 and 10000
    CURRENT_DATE - (FLOOR(RANDOM() * 30)) * INTERVAL '1 day' AS order_date, -- Random date within the last 30 days
    ROUND((100 + RANDOM() * 900)::numeric, 2) AS total_amount, -- Total amount between 100.00 and 1000.00
    CASE
        WHEN RANDOM() < 0.5 THEN 'Shipped'
        WHEN RANDOM() < 0.75 THEN 'Pending'
        ELSE 'Delivered'
    END AS status
FROM generate_series(1, 10000) AS gs;

-- Insert 10,000 sample order items
INSERT INTO sales.order_items (order_id, product_id, quantity, unit_price)
SELECT
    (1 + (RANDOM() * 9999)::INT) AS order_id, -- Random order_id between 1 and 10000
    (1 + (RANDOM() * 9999)::INT) AS product_id, -- Random product_id between 1 and 10000
    (1 + (RANDOM() * 5)::INT) AS quantity, -- Random quantity between 1 and 5
    ROUND((50 + RANDOM() * 950)::numeric, 2) AS unit_price -- Unit price between 50.00 and 1000.00
FROM generate_series(1, 10000) AS gs;

set optimizer = on;
explain (analyse, verbose)
SELECT o.order_id, c.first_name, c.last_name, o.order_date, o.total_amount, o.status
FROM sales.orders o
JOIN sales.customers c ON o.customer_id = c.customer_id;

drop table if exists sales.orders_by_customer;
CREATE TABLE sales.orders_by_customer (
    order_id INT,
    customer_id INT,
    order_date DATE NOT NULL,
    total_amount NUMERIC(10, 2) NOT NULL,
    status VARCHAR(20)
)
distributed by (customer_id);

insert into sales.orders_by_customer(order_id, customer_id, order_date, total_amount, status) 
select order_id, customer_id, order_date, total_amount, status from sales.orders;

analyse sales.orders_by_customer;

explain analyse
SELECT o.order_id, c.first_name, c.last_name, o.order_date, o.total_amount, o.status
FROM sales.orders_by_customer o
JOIN sales.customers c ON o.customer_id = c.customer_id;


SELECT oi.order_id, p.product_name, oi.quantity, oi.unit_price
FROM sales.order_items oi
JOIN sales.products p ON oi.product_id = p.product_id;

SELECT SUM(total_amount) AS total_revenue
FROM sales.orders;

set enable_seqscan=off;
show enable_seqscan;
show enable_indexscan;

explain (analyse, verbose, costs)
SELECT p.product_name, SUM(oi.quantity) AS total_quantity
FROM sales.order_items oi
JOIN sales.products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC;


-- EXPLAIN [ ( option [, ...] ) ] statement
--
-- where option can be one of:
--
--    ANALYZE [ boolean ]
--    VERBOSE [ boolean ]
--    COSTS [ boolean ]
--    SETTINGS [ boolean ]
--    GENERIC_PLAN [ boolean ]
--    BUFFERS [ boolean ]
--    SERIALIZE [ { NONE | TEXT | BINARY } ]
--    WAL [ boolean ]
--    TIMING [ boolean ]
--    SUMMARY [ boolean ]
--    MEMORY [ boolean ]
--    FORMAT { TEXT | XML | JSON | YAML }
--
-- https://www.postgresql.org/docs/current/sql-explain.html
-- https://explain.tensor.ru/

set enable_seqscan=on;
explain analyse SELECT * FROM sales.customers WHERE city = 'New York';
EXPLAIN verbose SELECT * FROM sales.customers WHERE city = 'New York';

EXPLAIN SELECT * FROM sales.products WHERE category = 'Electronics' AND price < 500;
EXPLAIN SELECT * FROM sales.orders WHERE customer_id = 12345 AND order_date >= '2024-01-01';
EXPLAIN SELECT * FROM sales.order_items WHERE order_id = 67890;

EXPLAIN ANALYZE SELECT * FROM sales.orders WHERE customer_id = 12345 AND order_date >= '2024-01-01';
EXPLAIN VERBOSE SELECT * FROM sales.products WHERE category = 'Electronics' AND price < 500;

EXPLAIN SELECT * FROM sales.customers WHERE city = 'New York' LIMIT 10;

select * 
from pg_stat_all_tables
order by schemaname desc;

select count() from sales.orders_by_customer;

select pg_size_pretty(pg_relation_size('sales.orders')); 

vacuum sales.customers;

----
-- Indexes in Greenplum
----

-- Summary of the Index Types
--    B-Tree: Default index type, suitable for most queries.
--    (Nope, only in 7th) Hash: Efficient for equality comparisons but limited in range queries.
--    GiST: Useful for complex data types and full-text search.
--    SP-GIST
--    GIN: Great for indexing array and JSONB data types.
--    BRIN: Efficient for large datasets with natural ordering.

--    Bitmap

-- B-Tree indexes are the default index type in PostgreSQL and Greenplum and are suitable for equality and range queries.

CREATE INDEX idx_customers_email ON sales.customers (email);
CREATE INDEX idx_products_category ON sales.products (category);
CREATE INDEX idx_orders_order_date ON sales.orders (order_date);
CREATE INDEX idx_order_items_order_id ON sales.order_items (order_id);

--  Bitmap indexes are best suited to data warehousing applications and decision support systems with large amounts of data,
--  many ad hoc queries, and few data modification (DML) transactions.

CREATE INDEX idx_customers_city ON sales.customers using bitmap (city);

REINDEX sales.customers;
DROP INDEX idx_customers_email;

select * 
from pg_stat_all_indexes
order by schemaname desc;

select relname as table_name,
   pg_size_pretty(pg_total_relation_size(relid)) As "Total Size",
   pg_size_pretty(pg_indexes_size(relid)) as "Index Size",
   pg_size_pretty(pg_relation_size(relid)) as "Actual Size"
   FROM pg_catalog.pg_statio_user_tables 
ORDER BY pg_total_relation_size(17306) DESC;

select * from gp_toolkit.gp_size_of_all_table_indexes gsoati; 

select * from pg_catalog.pg_stats where tablename = 'sales.products';


--Размер таблиц вместе с индексами
SELECT
    TABLE_NAME,
    pg_size_pretty(table_size) AS table_size,
    pg_size_pretty(indexes_size) AS indexes_size,
    pg_size_pretty(total_size) AS total_size
FROM (
    SELECT
        TABLE_NAME,
        pg_table_size(TABLE_NAME) AS table_size,
        pg_indexes_size(TABLE_NAME) AS indexes_size,
        pg_total_relation_size(TABLE_NAME) AS total_size
    FROM (
        SELECT ('"' || table_schema || '"."' || TABLE_NAME || '"') AS TABLE_NAME
        FROM information_schema.tables
    ) AS all_tables
    ORDER BY total_size DESC

    ) AS pretty_sizes;

---see defenition index
SELECT
    tablename,
    indexname,
    indexdef
FROM
    pg_indexes
WHERE
    schemaname = 'sales'
ORDER BY
    tablename,
    indexname;

--Неиспользуемые индексы
SELECT s.schemaname,
       s.relname AS tablename,
       s.indexrelname AS indexname,
       pg_size_pretty(pg_relation_size(s.indexrelid)) AS index_size,
       s.idx_scan
FROM pg_catalog.pg_stat_user_indexes s
   JOIN pg_catalog.pg_index i ON s.indexrelid = i.indexrelid
WHERE s.idx_scan < 10      -- has never been scanned
  AND 0 <> ALL (i.indkey)  -- no index column is an expression
  AND NOT i.indisunique   -- is not a UNIQUE index
  AND NOT EXISTS          -- does not enforce a constraint
         (SELECT 1 FROM pg_catalog.pg_constraint c
          WHERE c.conindid = s.indexrelid)
ORDER BY pg_relation_size(s.indexrelid) DESC;

----
-- Partition Management 
----
-- (GP7 only)

CREATE TABLE sales.customers (
    customer_id SERIAL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    city VARCHAR(50),
    country VARCHAR(50)
)
PARTITION BY LIST (city);

CREATE TABLE sales.customers_ny PARTITION OF sales.customers FOR VALUES IN ('New York');
CREATE TABLE sales.customers_la PARTITION OF sales.customers FOR VALUES IN ('Los Angeles');
CREATE TABLE sales.customers_chi PARTITION OF sales.customers FOR VALUES IN ('Chicago');


CREATE TABLE sales.products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price NUMERIC(10, 2),
    dwh_date timestamp default now()
)
PARTITION BY LIST (category);

CREATE TABLE sales.products_electronics PARTITION OF sales.products FOR VALUES IN ('Electronics');
CREATE TABLE sales.products_accessories PARTITION OF sales.products FOR VALUES IN ('Accessories');
CREATE TABLE sales.products_clothing PARTITION OF sales.products FOR VALUES IN ('Clothing');
-- Add other categories as needed


CREATE TABLE sales.orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES sales.customers(customer_id),
    order_date DATE,
    total_amount NUMERIC(10, 2),
    status VARCHAR(20)
)
PARTITION BY RANGE (order_date);

CREATE TABLE sales.orders_2023 PARTITION OF sales.orders FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');
CREATE TABLE sales.orders_2024 PARTITION OF sales.orders FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');
-- Add other ranges as needed


CREATE TABLE sales.order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES sales.orders(order_id),
    product_id INT REFERENCES sales.products(product_id),
    quantity INT,
    unit_price NUMERIC(10, 2)
)
PARTITION BY LIST (order_id);

CREATE TABLE sales.order_items_order_1_to_1000 PARTITION OF sales.order_items FOR VALUES IN (1, 2, 3, ..., 1000);
CREATE TABLE sales.order_items_order_1001_to_2000 PARTITION OF sales.order_items FOR VALUES IN (1001, 1002, ..., 2000);
-- Add other ranges as needed


-- Manipulating Partitions

CREATE TABLE sales.customers_sf PARTITION OF sales.customers FOR VALUES IN ('San Francisco');
DROP TABLE sales.customers_la; -- This will remove the Los Angeles partition
ALTER TABLE sales.customers ATTACH PARTITION sales.customers_ny FOR VALUES IN ('New York');

EXPLAIN SELECT * FROM sales.customers WHERE city = 'New York';
EXPLAIN SELECT * FROM sales.products WHERE category = 'Electronics';
EXPLAIN SELECT * FROM sales.orders WHERE order_date >= '2024-01-01';
EXPLAIN SELECT * FROM sales.order_items WHERE order_id = 67890;