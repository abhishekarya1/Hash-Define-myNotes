+++
title = "PostgreSQL"
date =  2022-06-21T08:40:00+05:30
weight = 3
pre = "<i class='devicon-postgresql-plain'></i> "
+++

An [open-source](https://www.postgresql.org/about/press/faq/#:~:text=PostgreSQL%20is%20liberally%20licenced%20and,licenced%20and%20owned%20by%20Oracle.), [high performance](https://youtu.be/yxM49iyTUU0) RDBMS with lots of features.

It also added JSON support making it one of the few relational database to support NoSQL.

Only 1 engine is available here as opposde to MySQL's 9, but it is so optimized it ties on most parameters with them and comes out better in some. They are also developing a new engine called `zheap` which is focused on _in-place updates_ and _reuse of space_ to reduce bloat.

[Postgres vs. MySQL](https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-vs-mysql/)

## Clients
- UI based - pgAdmin, Azure Data Studio, IntelliJ Datagrip
- Terminal based - psql
- from application using Driver

```txt
Server -> Database -> Schema -> Table
```
A database called `postgres` is already added by default, password must be set upon first access.

## psql

All commands use backslash (`\`) and SQL commands must be terminated with a semi-colon (`;`).

```txt
\? 			psql command help menu
\q 			quit
\! cls		execute "cls" command in parent console

\l 			list all db
\l+ 		list all db with more details

\c demo		connect to database "demo"

\dt 		list tables from current schema
\d foo 		table details of table "foo" (\d+ also available)
```

```sql
CREATE DATABASE demo_db;
DROP DATABASE demo_db;
```

```sh
# connecting via psql command in parent console directly
psql -h localhost -p 5432 -U abhishek demo
```

### Querying
```sql
-- will show indexes, query execution times, and other details
explain [analyze] query;

explain analyze select * from employees where first_name LIKE 'a%';
```

### Internals

#### Parallel Queries
Postgres has "Parallel Query" feature which basically means that it smartly utilizes multiple cores of the CPU to compute results of queries faster.

#### Full-text Search
Full-text search is the method of searching single or collection of documents stored on a computer in a full-text based database. This is mostly supported in advanced database systems like SOLR or ElasticSearch. However, the feature is present but is pretty basic in Postgres.

#### Write-Ahead Logging (WAL)
It is a feature of Postgres where, on a commit, system saves log file(s) to disk before any of the database changes are written to disk. It increases reliability because in case of a crash during save, we can look at the log and perform tasks again.

In a non-WAL environment, we write to disk everytime we commit database and the database state will be saved to disk. In WAL, on a commit, we will first save log file on disk and then save the database changes to disk, this significantly reduces the number of disk writes.

https://www.postgresql.org/docs/current/wal-intro.html

#### Table Size Limit
Maximum table size supported by Postgres is 32 Terabytes.

#### No Clustered Indexes
Postgres doesn't have clustered indexes at all. Every index is non-clustered in Postgres.

https://stackoverflow.com/a/27979121

### Indexes
Data structure that points to other data on the database for faster access. Sort of like a index of a book. When we have to query, DBMS will internally query this index instead of actual table data directly.

Implemented using a subset of columns in `B-Tree`, `Hash`, etc...

Queries that involve indexed columns are generally significantly faster.

**`PRIMARY KEY` is always indexed by default**.

```sql
-- creating index on name column in employees table
CREATE INDEX myIndex 
ON employees(name);

-- index as constraint: UNIQUE INDEX
CREATE UNIQUE INDEX myIndex
ON employees(empId);
```

#### Types of Indexes
**Clustered**: Typically, the clustered index is synonymous with the primary key. Trivially, the **order** of the rows in the database corresponds to the order of the rows in the index. This is why **only one** clustered index can exist in a given table, whereas, multiple non-clustered indexes can exist for a given table.

**Non-Clustered / Secondary**: We can create **multiple** non-clustered indexes for a given table on non-primary-key attibutes. They are **allocated space separately** from the table and hence access is **slower** than a clustered index.

The main difference between clustered and non-clustered indexes is that the database manager attempts to keep the data in the database in the same order as the corresponding keys appearing in the clustered index.

https://dev.mysql.com/doc/refman/5.7/en/innodb-index-types.html

#### Indexes are not magic!
It is not always guaranteed that index will result in faster queries, for example, using `LIKE` clause even on indexed columns leads to slow queries since we have to match sequentially with the clause pattern. Other such cases are:

- when most of the tuples values are redundant. Ex - a gender column will only have some possible values
- `UPPER(name) = 'Rick'`, we can have an index on `name` but not on `UPPER(name)` so queries will be slow, creating index on `UPPER(name)` or a specialized search index from the DB provider can help
- Composite indexes: indexes on two or more columns depend on each other. When we have index on `first_name` and `last_name`, we often run queries using `last_name` and they will be slower since they both depend upon each other for indexing. In such cases, `first_name AND last_name` will utilize index and not `OR` since we will be scanning sequentially for `last_name`.

_Source_: [Hussein Nasser - YouTube](https://youtu.be/oebtXK16WuU)

`B-Tree`(default) index is more suitable for relational, `BETWEEN`, and pattern matching using `LIKE` cases. It is best for general cases.

`Hash` index is more suitable for rows where you know you will be performing equality `=` on frequently.

`GIN` index (Generalized INverted index) is suitable when multiple values are stored in a single column e.g. array, jsonb, etc... 

_Reference_: https://www.postgresqltutorial.com/postgresql-indexes/


### Partitioning Tables
To improve query performance, Postgres divides tables in smaller **partitions**. 

A **partition key** (a column based on which to partition) and a partition method needs to be defined.

Partitioning Methods:
1. **Range Partitioning**: partition based on a range of values. Mostly used for dates.
2. **List Partitioning**: partition based on a list of known values. Mostly used when we have a column with a categorical value like gender, country, etc...
3. **Hash Partitioning**: utilizes a hash function upon the partition key. Mostly used when we need to identify data individually so that it has a unique hash value.