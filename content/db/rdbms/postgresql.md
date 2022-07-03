+++
title = "PostgreSQL"
date =  2022-06-21T08:40:00+05:30
weight = 3
pre = "<i class='devicon-postgresql-plain colored'></i> "
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
It is a feature of Postgres where, **the log file is written to and saved (aka _flushed_) to disk before (and more frequently than) the data files (files having table and index data) are written to and flushed to disk**.

If we follow this procedure, we do not need to flush data pages to disk on every transaction commit, because we know that in the event of a crash we will be able to recover the database using the log. We flush log file on every commit. After the transaction is finished, we can flush data pages too on disk.

WAL significantly reduces the number of disk writes as only the log file needs to be flushed to disk to guarantee that a transaction is committed, rather than every data file changed by the transaction.

In a non-WAL environment, we write changed data files to disk everytime we commit and the database state will be saved to disk, if that is successful, a log entry is made and the log is saved to disk.

https://www.postgresql.org/docs/current/wal-intro.html

#### Table Size Limit
Maximum table size supported by Postgres is 32 Terabytes.

#### No Clustered Indexes
Postgres doesn't have clustered indexes at all. Every index is non-clustered in Postgres.

https://stackoverflow.com/a/27979121


### Partitioning Tables
To improve query performance, Postgres divides tables in smaller **partitions**. 

A **partition key** (a column based on which to partition) and a partition method needs to be defined.

Partitioning Methods:
1. **Range Partitioning**: partition based on a range of values. Mostly used for dates.
2. **List Partitioning**: partition based on a list of known values. Mostly used when we have a column with a categorical value like gender, country, etc...
3. **Hash Partitioning**: utilizes a hash function upon the partition key. Mostly used when we need to identify data individually so that it has a unique hash value.