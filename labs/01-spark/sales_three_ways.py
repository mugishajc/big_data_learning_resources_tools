"""Day 4 lab: one question answered with RDDs, DataFrames and Spark SQL.

Question: total revenue per region on 2024-03-15.
Then: revenue per category (broadcast join) and orphan sales (left anti join).

Run from this folder:
    python sales_three_ways.py          # prints results and query plans
    python sales_three_ways.py --pause  # keeps the Spark UI open at http://localhost:4040
"""
import os
import sys
from operator import add
from pathlib import Path

from pyspark.sql import SparkSession
from pyspark.sql import functions as F

DATA = Path(__file__).resolve().parent.parent / "data"
DAY = "2024-03-15"

# Python workers must use the same interpreter as the driver.
os.environ.setdefault("PYSPARK_PYTHON", sys.executable)

spark = (SparkSession.builder
         .appName("sales-three-ways")
         .master("local[*]")
         .config("spark.driver.bindAddress", "127.0.0.1")
         .config("spark.sql.shuffle.partitions", "4")   # default 200 is far too many for a laptop
         .getOrCreate())
spark.sparkContext.setLogLevel("WARN")

sales = spark.read.csv(str(DATA / "sales.csv"), header=True, inferSchema=True)
stores = spark.read.csv(str(DATA / "stores.csv"), header=True, inferSchema=True)
products = spark.read.csv(str(DATA / "products.csv"), header=True, inferSchema=True)

# --- 1. RDD: we parse text ourselves, Spark cannot see inside the records -------------
region_of = dict(stores.select("store_id", "region").collect())    # tiny table, keep on driver
lines = spark.sparkContext.textFile(str(DATA / "sales.csv"))
header = lines.first()
rdd_rows = (lines.filter(lambda l: l != header)
            .map(lambda l: l.split(","))                            # narrow
            .filter(lambda r: r[5] == DAY))                         # narrow
rdd_result = dict(rdd_rows.map(lambda r: (region_of[int(r[2])], float(r[4])))
                  .reduceByKey(add)                                 # wide: shuffle, with map-side combine
                  .collect())                                       # action: the job runs here

# --- 2. DataFrame: declarative, Catalyst plans it --------------------------------------
df_result = (sales.filter(F.col("dt") == DAY)
             .join(F.broadcast(stores), "store_id")
             .groupBy("region").agg(F.round(F.sum("amount"), 2).alias("revenue")))

# --- 3. SQL: same engine and optimizer, different language ----------------------------
sales.createOrReplaceTempView("sales")
stores.createOrReplaceTempView("stores")
sql_result = spark.sql(f"""
    SELECT st.region, ROUND(SUM(s.amount), 2) AS revenue
    FROM sales s JOIN stores st ON s.store_id = st.store_id
    WHERE s.dt = '{DAY}'
    GROUP BY st.region
""")

df_dict = {r["region"]: r["revenue"] for r in df_result.collect()}
sql_dict = {r["region"]: r["revenue"] for r in sql_result.collect()}
assert {k: round(v, 2) for k, v in rdd_result.items()} == df_dict == sql_dict
print(f"\nRevenue per region on {DAY} (RDD, DataFrame and SQL agree):")
for region, revenue in sorted(df_dict.items(), key=lambda kv: -kv[1]):
    print(f"  {region:<7} {revenue:>8.2f}")

print("\nPhysical plan of the DataFrame version. Look for BroadcastHashJoin and Exchange:")
df_result.explain()

# --- Revenue per category: broadcast the small products table -------------------------
print("Revenue per category for March 2024:")
(sales.join(F.broadcast(products), "product_id")
 .groupBy("category").agg(F.round(F.sum("amount"), 2).alias("revenue"))
 .orderBy(F.desc("revenue")).show())

# --- Data quality: sales whose product does not exist ---------------------------------
orphans = sales.join(products, "product_id", "left_anti")
print(f"Sales with an unknown product_id (left anti join): {orphans.count()}")
orphans.show(3)

if "--pause" in sys.argv:
    input("Spark UI: http://localhost:4040  (press Enter to stop)\n")
spark.stop()
