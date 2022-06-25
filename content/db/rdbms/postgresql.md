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


### Partitioning Tables
To improve query performance, Postgres divides tables in smaller **partitions**. 

A **partition key** (a column based on which to partition) and a partition method needs to be defined.

Partitioning Methods:
1. **Range Partitioning**: partition based on a range of values. Mostly used for dates.
2. **List Partitioning**: partition based on a list of known values. Mostly used when we have a column with a categorical value like gender, country, etc...
3. **Hash Partitioning**: utilizes a hash function upon the partition key. Mostly used when we need to identify data individually so that it has a unique hash value.