# Labs

Four small labs on one dataset, so you can compare how each tool answers the same question.

| Lab | Tool | Needs | Time |
|---|---|---|---|
| [01-spark](01-spark) | PySpark: RDD vs DataFrame vs SQL, broadcast join, anti join | Python 3.9+, Java 17 or 21 | 15 min |
| [02-mapreduce-python](02-mapreduce-python) | MapReduce with Hadoop Streaming | Python only (Hadoop optional) | 10 min |
| [03-hive](03-hive) | External vs managed tables, partitions, buckets, views | Hive (Docker) | 30 min |
| [04-pig](04-pig) | The same questions as a Pig Latin dataflow | Pig in local mode | 20 min |

## The dataset

[`data/`](data) holds three CSV files shaped like the tables in the Day 3 and Day 4 slides:

```
sales(sale_id, product_id, store_id, quantity, amount, dt)    2,000 rows, March 2024
products(product_id, name, category, unit_price)             12 rows
stores(store_id, name, region)                               7 rows
```

Kigali stores sell more than the others (skew on purpose), and 8 sales point to a product id that does not exist (for the outer join exercise). `python data/make_data.py` rebuilds the files; the seed is fixed, so everyone gets the same numbers.

## 01-spark

```bash
pip install pyspark            # use a virtual environment
cd labs/01-spark
python sales_three_ways.py --pause
```

It prints revenue per region three ways (they must match), the physical plan, revenue per category and the orphan sales. With `--pause`, open http://localhost:4040 to see the jobs and stages.

If Spark fails at startup, check `java -version`: Spark 4 needs Java 17 or 21. On a Mac with several JDKs: `export JAVA_HOME=$(/usr/libexec/java_home -v 17)`.

For a bigger version (300,000 rows, ten lessons on caching, skew, salting and partitioned Parquet), see the [IECMS Spark lab](https://github.com/mugishajc/calibratorrr/tree/main/analytics).

## 02-mapreduce-python

Revenue per store. Simulate the whole MapReduce flow with a Unix pipe, where `sort` plays the shuffle:

```bash
cd labs/02-mapreduce-python
cat ../data/sales.csv | ./mapper.py | sort | ./reducer.py
```

On a real cluster (for example [docker-hadoop](https://github.com/big-data-europe/docker-hadoop)):

```bash
hdfs dfs -mkdir -p /data/retail/sales
hdfs dfs -put ../data/sales.csv /data/retail/sales/
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
  -files mapper.py,reducer.py \
  -mapper mapper.py -combiner reducer.py -reducer reducer.py \
  -input /data/retail/sales -output /out/store_revenue
hdfs dfs -cat /out/store_revenue/part-*
```

The reducer doubles as the combiner because a sum gives the same result however it is split. An average would not: try it and see why.

## 03-hive

Start Hive with [docker-hive](https://github.com/big-data-europe/docker-hive), copy the data in, then run the script:

```bash
docker cp ../data hive-server:/tmp/retail
docker exec -it hive-server bash
hdfs dfs -mkdir -p /data/retail/{sales,products,stores}
hdfs dfs -put /tmp/retail/sales.csv    /data/retail/sales/
hdfs dfs -put /tmp/retail/products.csv /data/retail/products/
hdfs dfs -put /tmp/retail/stores.csv   /data/retail/stores/
hive -f /path/to/sales.hql      # or paste it into beeline
```

Things to notice: `SHOW PARTITIONS` lists 31 days; the two `EXPLAIN DEPENDENCY` lines show one partition versus all of them; dropping `sales_raw` leaves the CSV files in place, while dropping `sales` deletes its Parquet files.

## 04-pig

```bash
cd labs/04-pig
pig -x local sales.pig
```

Compare each block with the matching query in `sales.hql`. The Pig version names every step, which makes the data shape after each operation visible (`DESCRIBE relation;` prints it).
