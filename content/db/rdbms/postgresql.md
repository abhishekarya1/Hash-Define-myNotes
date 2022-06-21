+++
title = "PostgreSQL"
date =  2022-06-21T08:40:00+05:30
weight = 2
pre = "<i class='devicon-postgresql-plain'></i> "
+++

An [open-source](https://www.postgresql.org/about/press/faq/#:~:text=PostgreSQL%20is%20liberally%20licenced%20and,licenced%20and%20owned%20by%20Oracle.), [high performance](https://youtu.be/yxM49iyTUU0) RDBMS with lots of features.

It also added JSON support making it one of the few relational database to support NoSQL.

Only 1 engine is available here as opposde to MySQL's 9, but it is so optimized it ties on most parameters with them and comes out better in some. They are also developing a new engine called `zheap` which is focused on _in-place updates_ and _reuse of space_ to reduce bloat.

## Clients
- UI based - pgAdmin
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
\d foo 		table details of "foo" (\d+ also available)

```

```sql
CREATE DATABASE demo_db;
DROP DATABASE demo_db;
```

```sh
# connecting via psql command in parent console directly
psql -h localhost -p 5432 -U abhishek demo
```