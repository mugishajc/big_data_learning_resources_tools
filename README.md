# Big Data Learning Resources and Tools

Revision material, past-paper answers and hands-on labs for **MIT 91205 Big Data Analytics** (Hadoop, Hive, Pig, Spark), plus a short list of the best free resources for learning these tools properly.

Shared by students, for students. Corrections and additions are welcome.

## Pick your path

**Revising for a CAT or exam (1 to 3 days left)**
1. Read the [cheat sheet](cheatsheet/big-data-cheatsheet.pdf) (3 pages, all four days).
2. Work through the [past papers and answers PDF](past-papers/past-papers-and-answers.pdf), or the same answers per day in [`answers/`](answers).
3. Finish with [the 40 most-asked questions](answers/most-asked-questions.md), and cover the answer before you read it.

**Learning the course properly (a week or more)**
1. One day at a time: slides first, then the matching answers file, then the lab.
2. Run the [labs](labs): the same dataset in Spark, MapReduce, Hive and Pig, so you can see how each tool works.
3. Read the first two rows of each table in [RESOURCES.md](RESOURCES.md).

**Learning the tools for work**
Go straight to [RESOURCES.md](RESOURCES.md) and [labs/01-spark](labs/01-spark). The best follow-up course is the free [Data Engineering Zoomcamp](https://github.com/DataTalksClub/data-engineering-zoomcamp).

## What is in here

```
answers/                       Answers in Markdown, readable on GitHub
  day1-foundations.md          5 V's, CAP, ACID vs BASE, partitioning, Lambda vs Kappa (16 Q)
  day2-hadoop-mapreduce.md     HDFS, YARN, MapReduce review questions (15 Q)
  day3-hive-pig.md             Hive and Pig review questions (15 Q)
  day3-assignment.md           Day 3 assignment, answers with reasons (15 Q)
  day4-spark.md                Spark review questions, explain() guide (15 Q)
  most-asked-questions.md      40 frequent CAT and exam questions, jobs/stages exercises
past-papers/
  past-papers-and-answers.pdf  Everything in answers/ as one printable PDF
  day3-assignment-answers.pdf  Day 3 assignment answer sheet
  by-topic/                    The same answers, one PDF per day (print only what you need)
cheatsheet/
  big-data-cheatsheet.pdf      3-page summary of Days 1 to 4
  cheatsheet.html              Source of the PDF
labs/                          Runnable exercises on one sample dataset
  data/                        sales, products, stores CSVs (+ generator)
  01-spark/                    RDD vs DataFrame vs SQL, broadcast and anti joins
  02-mapreduce-python/         Hadoop Streaming mapper and reducer in Python
  03-hive/                     External/managed tables, partitions, buckets, views
  04-pig/                      The same questions as a Pig Latin dataflow
RESOURCES.md                   Curated free resources by topic, all links checked
scripts/build_pdfs.sh          Rebuilds both PDFs after you edit the sources
```

## Course map

| Day | Topic | Answers | Lab |
|---|---|---|---|
| 1 | Big Data and distributed systems foundations | [day1](answers/day1-foundations.md) | |
| 2 | HDFS, YARN, MapReduce | [day2](answers/day2-hadoop-mapreduce.md) | [02-mapreduce-python](labs/02-mapreduce-python) |
| 3 | Hive and Pig | [day3](answers/day3-hive-pig.md), [assignment](answers/day3-assignment.md) | [03-hive](labs/03-hive), [04-pig](labs/04-pig) |
| 4 | Apache Spark | [day4](answers/day4-spark.md) | [01-spark](labs/01-spark) |
| 5 | Kafka and Structured Streaming | coming after the lecture | |
| 6 | NoSQL, governance, security | coming after the lecture | |

## Run the Spark lab in two minutes

```bash
git clone https://github.com/mugishajc/big_data_learning_resources_tools.git
cd big_data_learning_resources_tools
python3 -m venv .venv && source .venv/bin/activate
pip install pyspark
cd labs/01-spark && python sales_three_ways.py --pause   # Spark UI at http://localhost:4040
```

Spark 4 needs Java 17 or 21 (`java -version`). More detail in [labs/README.md](labs/README.md).

## How to study with this

- Answer the question yourself first, then compare. Reading answers without trying gives a false sense of knowing.
- For every "compare X and Y" question, be able to draw the table from memory.
- For Spark, be able to count jobs, stages and tasks from a short code snippet; it comes up often (see Q27 to Q29 in the most-asked file).
- Run at least one lab. Seeing a shuffle in the Spark UI makes the theory stick.

## Contributing

Found a mistake, or have a better explanation or a past question we missed? Open an issue or a pull request. Keep answers short and in plain language, and say which day the question comes from. After editing anything in `answers/` or `cheatsheet/`, run `./scripts/build_pdfs.sh` so the PDFs stay in sync.

## Note

These are student notes written to help revision. They do not replace the lecture slides, and they are not official course material. The lecture slides are not included here; get them from the course page.
