-- Day 3 lab: the same questions as the Hive lab, written as a Pig Latin dataflow.
-- Run in local mode from this folder:  pig -x local sales.pig
-- Each line names a new relation built from the one before.

sales = LOAD '../data/sales.csv' USING PigStorage(',')
        AS (sale_id:long, product_id:int, store_id:int, quantity:int, amount:double, dt:chararray);
stores = LOAD '../data/stores.csv' USING PigStorage(',')
        AS (store_id:int, name:chararray, region:chararray);
products = LOAD '../data/products.csv' USING PigStorage(',')
        AS (product_id:int, name:chararray, category:chararray, unit_price:double);

-- The header line casts to null for the int columns, so this drops it.
sales    = FILTER sales BY sale_id IS NOT NULL;
stores   = FILTER stores BY store_id IS NOT NULL;
products = FILTER products BY product_id IS NOT NULL;

-- 1. Revenue per region on one day.
day        = FILTER sales BY dt == '2024-03-15';
day_stores = JOIN day BY store_id, stores BY store_id USING 'replicated';  -- small table in memory
by_region  = GROUP day_stores BY stores::region;
region_rev = FOREACH by_region GENERATE group AS region, ROUND_TO(SUM(day_stores.day::amount), 2) AS revenue;
region_top = ORDER region_rev BY revenue DESC;
DUMP region_top;

-- 2. Revenue per category. GROUP produces (group, bag); SUM consumes the bag.
enriched = JOIN sales BY product_id, products BY product_id;
by_cat   = GROUP enriched BY products::category;
cat_rev  = FOREACH by_cat GENERATE group AS category,
           ROUND_TO(SUM(enriched.sales::amount), 2) AS revenue,
           COUNT(enriched) AS num_sales;
STORE cat_rev INTO 'out/category_revenue' USING PigStorage(',');

-- 3. Orphan sales: left outer join, keep rows with no matching product.
lj      = JOIN sales BY product_id LEFT OUTER, products BY product_id;
orphans = FILTER lj BY products::product_id IS NULL;
orphan_ids = FOREACH orphans GENERATE sales::sale_id, sales::product_id, sales::amount;
DUMP orphan_ids;

-- 4. SPLIT: one pass over the data, two outputs.
SPLIT sales INTO big IF amount >= 50.0, small OTHERWISE;
STORE big   INTO 'out/big_sales'   USING PigStorage(',');
STORE small INTO 'out/small_sales' USING PigStorage(',');

-- Show the logical, physical and execution plans for one relation.
EXPLAIN cat_rev;
