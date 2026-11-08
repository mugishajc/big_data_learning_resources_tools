-- Day 3 lab: Hive tables, partitions, buckets and queries on the sample sales data.
-- Before running, put the CSV files in HDFS (see README.md in this folder).

CREATE DATABASE IF NOT EXISTS retail;
USE retail;

-- 1. External tables over the raw CSV files. Schema-on-read: the files are not changed,
--    Hive only records how to read them. DROP TABLE on these keeps the files.
CREATE EXTERNAL TABLE IF NOT EXISTS sales_raw (
  sale_id BIGINT, product_id INT, store_id INT, quantity INT, amount DOUBLE, dt STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/data/retail/sales'
TBLPROPERTIES ('skip.header.line.count' = '1');

CREATE EXTERNAL TABLE IF NOT EXISTS products (
  product_id INT, name STRING, category STRING, unit_price DOUBLE)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
LOCATION '/data/retail/products'
TBLPROPERTIES ('skip.header.line.count' = '1');

CREATE EXTERNAL TABLE IF NOT EXISTS stores (
  store_id INT, name STRING, region STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
LOCATION '/data/retail/stores'
TBLPROPERTIES ('skip.header.line.count' = '1');

-- 2. Managed table, partitioned by day, stored as Parquet. Hive owns these files:
--    DROP TABLE deletes them. The partition column is not repeated in the column list.
CREATE TABLE IF NOT EXISTS sales (
  sale_id BIGINT, product_id INT, store_id INT, quantity INT, amount DOUBLE)
PARTITIONED BY (dt STRING)
STORED AS PARQUET;

-- Dynamic partitioning: one directory per distinct dt, e.g. .../sales/dt=2024-03-15/
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode = nonstrict;
INSERT OVERWRITE TABLE sales PARTITION (dt)
SELECT sale_id, product_id, store_id, quantity, amount, dt FROM sales_raw;

SHOW PARTITIONS sales;

-- 3. Bucketed copy: rows hashed on product_id into 4 files. Useful for bucket map joins
--    and TABLESAMPLE.
CREATE TABLE IF NOT EXISTS sales_bucketed (
  sale_id BIGINT, product_id INT, store_id INT, quantity INT, amount DOUBLE, dt STRING)
CLUSTERED BY (product_id) INTO 4 BUCKETS
STORED AS ORC;
INSERT OVERWRITE TABLE sales_bucketed SELECT * FROM sales_raw;

-- 4. Partition pruning: only the dt=2024-03-15 directory is read.
SELECT st.region, ROUND(SUM(s.amount), 2) AS revenue
FROM sales s JOIN stores st ON s.store_id = st.store_id
WHERE s.dt = '2024-03-15'
GROUP BY st.region
ORDER BY revenue DESC;

-- Compare the plans. The first lists one partition, the second all of them.
EXPLAIN DEPENDENCY SELECT COUNT(*) FROM sales WHERE dt = '2024-03-15';
EXPLAIN DEPENDENCY SELECT COUNT(*) FROM sales WHERE amount > 50;

-- 5. Revenue per category, keeping only categories above 5,000 (HAVING filters groups).
SELECT p.category, ROUND(SUM(s.amount), 2) AS revenue, COUNT(*) AS num_sales
FROM sales s JOIN products p ON s.product_id = p.product_id
GROUP BY p.category
HAVING SUM(s.amount) > 5000
ORDER BY revenue DESC;

-- 6. Data quality: sales whose product does not exist (LEFT JOIN + IS NULL).
SELECT s.sale_id, s.product_id, s.amount
FROM sales s LEFT JOIN products p ON s.product_id = p.product_id
WHERE p.product_id IS NULL;

-- 7. A view: a saved query, no data copied. Reading it re-runs the query.
CREATE VIEW IF NOT EXISTS daily_region_revenue AS
SELECT s.dt, st.region, SUM(s.amount) AS revenue
FROM sales s JOIN stores st ON s.store_id = st.store_id
GROUP BY s.dt, st.region;

SELECT * FROM daily_region_revenue WHERE region = 'Kigali' ORDER BY dt LIMIT 5;

-- 8. Sampling one bucket out of four.
SELECT COUNT(*) FROM sales_bucketed TABLESAMPLE(BUCKET 1 OUT OF 4 ON product_id);
