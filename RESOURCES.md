# Resources

Free material only. Every link was checked in November 2026. Repos marked **(fork)** also have a copy under [github.com/mugishajc](https://github.com/mugishajc?tab=repositories), so they stay available even if the original moves.

Start with the first two or three rows of each table. The rest are for going deeper.

## 1. Foundations (Day 1)

| Resource | Why it is worth your time |
|---|---|
| [MapReduce paper (Dean and Ghemawat, 2004)](https://research.google/pubs/mapreduce-simplified-data-processing-on-large-clusters/) | The paper the whole course builds on. 13 pages, read sections 1 to 3 at least. |
| [Google File System paper (2003)](https://research.google/pubs/the-google-file-system/) | The design HDFS copied: master with metadata, chunk servers with data, 3 replicas. |
| [donnemartin/system-design-primer](https://github.com/donnemartin/system-design-primer) | Clear pages on CAP, consistency patterns, replication and partitioning. |
| [Designing Data-Intensive Applications, chapter list](https://dataintensive.net/) | The best book on replication, partitioning and consistency. Chapters 5, 6 and 9. |
| [oxnr/awesome-bigdata](https://github.com/oxnr/awesome-bigdata) **(fork)** | A map of the whole ecosystem when you need to place a tool you have never heard of. |
| [mahmoudparsian/big-data-modeling](https://github.com/mahmoudparsian/big-data-modeling) **(fork)** | Sample CSV, text and graph datasets for MapReduce and Spark exercises (named in the Day 1 slides). |

## 2. Hadoop: HDFS, YARN, MapReduce (Day 2)

| Resource | Why |
|---|---|
| [HDFS Architecture guide](https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-hdfs/HdfsDesign.html) | Official, short, and the source of most exam questions on NameNode, DataNodes and replication. |
| [YARN architecture](https://hadoop.apache.org/docs/stable/hadoop-yarn/hadoop-yarn-site/YARN.html) | ResourceManager, NodeManager and ApplicationMaster on one page. |
| [MapReduce tutorial](https://hadoop.apache.org/docs/stable/hadoop-mapreduce-client/hadoop-mapreduce-client-core/MapReduceTutorial.html) | Word Count walked through with combiner and partitioner. |
| [Hadoop Streaming](https://hadoop.apache.org/docs/stable/hadoop-streaming/HadoopStreaming.html) | Write mappers and reducers in Python. See [labs/02-mapreduce-python](labs/02-mapreduce-python). |
| [big-data-europe/docker-hadoop](https://github.com/big-data-europe/docker-hadoop) **(fork)** | A real HDFS + YARN cluster on your laptop with `docker compose up`. |
| [mahmoudparsian/data-algorithms-book](https://github.com/mahmoudparsian/data-algorithms-book) | MapReduce and Spark solutions to common problems (top-N, joins, secondary sort). |

## 3. Hive and Pig (Day 3)

| Resource | Why |
|---|---|
| [Hive Language Manual](https://cwiki.apache.org/confluence/display/Hive/LanguageManual) | DDL, partitions, buckets, joins and built-in functions. Use the DDL and Select pages. |
| [big-data-europe/docker-hive](https://github.com/big-data-europe/docker-hive) **(fork)** | Hive with a metastore on Docker. Run the HiveQL in [labs/03-hive](labs/03-hive) here. |
| [Pig Latin basics](https://pig.apache.org/docs/latest/basic.html) | Every operator (LOAD, FILTER, GROUP, FOREACH, JOIN) with small examples. |
| [Pig Latin paper (SIGMOD 2008)](https://dl.acm.org/doi/10.1145/1376616.1376726) | Why a dataflow language, in the authors' words. |
| [Hive paper (VLDB 2009)](https://www.vldb.org/pvldb/vol2/vldb09-938.pdf) | Short. Explains the metastore and the compiler. |
| [Parquet docs, concepts](https://parquet.apache.org/docs/concepts/) | Row groups, column chunks, pages: what makes predicate pushdown work. |

## 4. Apache Spark (Day 4)

| Resource | Why |
|---|---|
| [databricks/LearningSparkV2](https://github.com/databricks/LearningSparkV2) **(fork)** | Code and notebooks for *Learning Spark, 2nd edition*. The best structured path from zero. |
| [spark-examples/pyspark-examples](https://github.com/spark-examples/pyspark-examples) **(fork)** | One small script per function: joins, window functions, UDFs, partitionBy. Good for quick lookups. |
| [mahmoudparsian/pyspark-tutorial](https://github.com/mahmoudparsian/pyspark-tutorial) **(fork)** | RDD and DataFrame examples with explanations, written for students. |
| [databricks/Spark-The-Definitive-Guide](https://github.com/databricks/Spark-The-Definitive-Guide) **(fork)** | Code and data for the book. Strong on structured APIs and the execution model. |
| [Spark SQL guide](https://spark.apache.org/docs/latest/sql-programming-guide.html) and [RDD guide](https://spark.apache.org/docs/latest/rdd-programming-guide.html) | Official. The RDD guide's "Shuffle operations" and "RDD Persistence" sections answer many exam questions. |
| [Spark tuning guide](https://spark.apache.org/docs/latest/tuning.html) and [SQL performance tuning](https://spark.apache.org/docs/latest/sql-performance-tuning.html) | Memory, serialization, broadcast joins, adaptive query execution. |
| [Monitoring and the Spark UI](https://spark.apache.org/docs/latest/web-ui.html) | What each tab shows. Pair it with [labs/01-spark](labs/01-spark). |
| [MLlib guide](https://spark.apache.org/docs/latest/ml-guide.html) and [GraphX guide](https://spark.apache.org/docs/latest/graphx-programming-guide.html) | Pipelines, estimators and transformers; Pregel and PageRank. |
| [graphframes/graphframes](https://github.com/graphframes/graphframes) | DataFrame-based graph library, the modern alternative to GraphX from Python. |
| [japila-books/apache-spark-internals](https://github.com/japila-books/apache-spark-internals) | How the scheduler, shuffle and memory manager work inside. For the curious, not for the exam. |
| [RDD paper (NSDI 2012)](https://www.usenix.org/conference/nsdi12/technical-sessions/presentation/zaharia) | Lineage and fault tolerance, explained by the people who built it. |
| [awesome-spark/awesome-spark](https://github.com/awesome-spark/awesome-spark) **(fork)** | Curated list of Spark packages, books and talks. |

## 5. Streaming (Day 5)

| Resource | Why |
|---|---|
| [Kafka introduction](https://kafka.apache.org/intro) | Topics, partitions, offsets, consumer groups. Read it before Day 5. |
| [Structured Streaming guide](https://spark.apache.org/docs/latest/structured-streaming-programming-guide.html) | Event time, watermarks, output modes, checkpointing. |
| [confluentinc/demo-scene](https://github.com/confluentinc/demo-scene) | Runnable Kafka demos with Docker Compose. |

## 6. NoSQL (Day 6)

| Resource | Why |
|---|---|
| [MongoDB University](https://learn.mongodb.com/) | Free courses; the data modeling one fits the course. |
| [HBase reference guide, data model](https://hbase.apache.org/book.html#datamodel) | Row key, column family, versions. |
| [Cassandra architecture overview](https://cassandra.apache.org/doc/latest/cassandra/architecture/overview.html) | Ring, partitioner, tunable consistency (the AP side of CAP). |

## 7. Orchestration and end-to-end pipelines

| Resource | Why |
|---|---|
| [DataTalksClub/data-engineering-zoomcamp](https://github.com/DataTalksClub/data-engineering-zoomcamp) **(fork)** | A free 9-week course: Docker, orchestration, warehouse, Spark, Kafka. The best single follow-up to this course. |
| [Airflow tutorial](https://airflow.apache.org/docs/apache-airflow/stable/tutorial/fundamentals.html) | Write a DAG that runs a Spark job on a schedule. |
| [DataExpert-io/data-engineer-handbook](https://github.com/DataExpert-io/data-engineer-handbook) | Curated books, courses, newsletters and interview prep for data engineering. |
| [andkret/Cookbook](https://github.com/andkret/Cookbook) | Data engineering cookbook with interview-style questions per topic. |

## 8. Run everything locally

| Option | Good for |
|---|---|
| `pip install pyspark` + Java 17 | Spark in local mode. Enough for every Day 4 exercise. See [labs/01-spark](labs/01-spark). |
| [jupyter/docker-stacks](https://github.com/jupyter/docker-stacks) (`pyspark-notebook` image) | Spark in a notebook with nothing to install except Docker. |
| [big-data-europe/docker-hadoop](https://github.com/big-data-europe/docker-hadoop) and [docker-hive](https://github.com/big-data-europe/docker-hive) | HDFS, YARN and Hive when you want to see the real daemons. Needs about 4 GB of free RAM. |
| [Databricks Free Edition](https://www.databricks.com/learn/free-edition) | Hosted Spark in the browser, no install. |

## 9. Datasets for practice

- [NYC Taxi trip records](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page): large Parquet files, ideal for partitioning and skew experiments.
- [MovieLens](https://grouplens.org/datasets/movielens/): ratings data for ALS recommendation in MLlib.
- [UCI Machine Learning Repository](https://archive.ics.uci.edu/): small classic datasets for MLlib pipelines.
- [Kaggle datasets](https://www.kaggle.com/datasets): pick any domain for the mini project.
