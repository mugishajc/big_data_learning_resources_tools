# Day 3 Assignment: Answers

Correct answers to the 15 Day Three assignment questions on Hive and Pig, each with a one-line reason.

### Q1. Schema-on-read means the data has no schema.

**False.** The schema exists in the metastore; Hive applies it when the data is read, not when it is loaded.

### Q2. Why are columnar formats like Parquet/ORC preferred for analytical queries?

**b. They enable column projection and better compression.** A query reads only the columns it needs, and values from one column compress well together.

### Q3. Partitioning and bucketing are the same thing.

**False.** Partitioning splits data into directories by value; bucketing hashes rows into a fixed number of files.

### Q4. Bucketing in Hive writes rows into a fixed number of files based on:

**c. Hash of a column.** The same value always lands in the same bucket file.

### Q5. Which UDF type produces many output rows per input row (e.g. splitting a string)?

**d. UDTF.** One row in, many rows out, as with `explode()`.

### Q6. Match each concept to its description.

| Concept | Description |
|---|---|
| Pig Latin | Dataflow scripting language |
| UDTF | Produces many output rows per input row |
| Metastore | Central catalog of table and partition definitions |
| Managed table | Hive owns and drops the underlying data files |

Managed versus external comes down to who owns the files.

### Q7. What is the role of a SerDe in Hive?

**d. Converts between byte streams and rows.** SerDe is short for serializer and deserializer.

### Q8. What does schema-on-read mean in Hive?

**c. Schema is applied when data is read.** Traditional databases check the schema on write instead.

### Q9. Which type of database is most commonly used as the backend for the Hive metastore?

**A relational database** (for example MySQL or PostgreSQL). The built-in Derby supports only one user at a time, so it is used for testing.

### Q10. Hive partitioning primarily enables:

**b. Partition pruning (skip unrelated directories).** It only helps when the query filters on the partition column.

### Q11. Which statement about Hive's execution engine is correct?

**a. Hive is a query layer that can use MapReduce, Tez, or Spark.** The engine is set with `hive.execution.engine` (Spark support was removed in Hive 4, so check your version).

### Q12. Which Pig complex type is an unordered collection of tuples?

**a. Bag.** A tuple is an ordered set of fields; a bag is an unordered group of tuples.

### Q13. Which statement best describes Pig Latin's programming style?

**d. Procedural, dataflow-oriented.** A Pig script lists the steps; SQL only states the result you want.

### Q14. What does the Hive metastore store?

**b. Table, column and partition metadata.** The data files themselves stay in HDFS.

### Q15. What happens when you DROP an external Hive table?

**c. Only metadata is removed; files stay.** Dropping a managed table would delete the files too.

## Quick recall

- Schema-on-read still has a schema; it is applied at query time.
- Columnar formats: read fewer columns, better compression.
- Partitioning uses directories by value; bucketing uses hash into a fixed number of files.
- UDTF: one input row, many output rows.
- SerDe: bytes to rows and rows to bytes.
- Metastore stores metadata in a relational database; Derby is for testing.
- Partition pruning only works when you filter on the partition column.
- Hive is a query layer on MapReduce, Tez or Spark.
- Pig bag: unordered collection of tuples.
- Pig Latin is procedural dataflow.
- DROP external table: metadata gone, files kept.
