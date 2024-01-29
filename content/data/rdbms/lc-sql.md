+++
title = "Leetcode SQL"
date =  2024-01-28T22:02:00+05:30
weight = 2
pre = "🪑 "
+++

## Handling NULL
Always use `IS` or `IS NOT` with `NULL`, don't use `= NULL` since its incorrect SQL and will always be unequal (_false_) even with `NULL`.

Working with `NULL`:
```sql
IFNULL(expr, alt_val)
COALESCE(val1, val2, ... valN)

-- if order_id is null, it replaces it with 0 before comparing
-- it works by returning the first non-null value form the list
WHERE COALESCE(order_id, 0) = 0
```

In Postgres, double-quotes `""` are used to represent identifier names such as column, relation, etc. To represent string type use single-quotes `''`.

## Methods and Data
```sql
LENGTH(str) > 0

-- date types can be subtracted
-- if date2 is yesterday and date1 is today then
date1 - date2 = 1
```

## Joining
Every type of `JOIN` is a cross-product (aka Cartesian Product) that yields `m * n` rows, on it the filter is applied using the `ON` clause.
- it is restricted to write joins without predicate except cross-join: writing any join without a predicate will output cross-product (even inner join where there is nothing common between two tables and you'd expect zero rows but [that is not the case](https://sql-playground.wizardzines.com/#select%20*%20from%20clients%20inner%20join%20cats) ([db-fiddle](https://www.db-fiddle.com/f/kwBLvL8WUSbxvjSprJg5ce/304))
- by default, just writing `JOIN` is equivalent to `INNER JOIN` (specify predicate in both; because of above point)
- `CROSS JOIN` needs no predicate; provided to explicitly specify cross-product
 - outer joins are `LEFT JOIN`, `RIGHT JOIN`, `FULL JOIN` (`OUTER` keyword is optional)

`NATURAL JOIN` is a special case where a column name is common between two tables and SQL engine can implicitly use it to perform inner join based on its equality (equi-join) between two tables. No predicate is required here (obv) and the result set has only one copy of the common column (`SELECT * FROM ... JOIN ...` will yield only one copy of the common column). We can have `NATURAL LEFT JOIN` and others too.

Performing joins can be done with comma too (old way), then `WHERE` clause is used to specify join condition:
```sql
-- old way, specify join condition in WHERE clause
SELECT e.name AS Employee 
FROM Employee e, Employee m
WHERE e.managerId = m.id AND e.salary > m.salary

-- using JOIN and ON clause
SELECT e.name AS Employee 
FROM Employee e JOIN Employee m ON e.managerId = m.id 
WHERE e.salary > m.salary

-- comma is equivalent to CROSS JOIN if no WHERE clause is specified
```

### SELECT clause with Joins 
A transient "join" table is created (projection) which can be accessed in the `SELECT` clause using original table aliases.

```sql
SELECT b.name, COUNT(a.id)
FROM A a JOIN B b ON a.id = b.id
GROUP BY b.name
```
In the above example, `COUNT(a.id)` counts rows from the transient table and not the original `A a` table.

### No Venn Diagrams for Joins
Because there can be more rows than the size of each of the tables in the case we perform an inner join without predicate, joins in SQL are not set operations, like in this case which was supposed to be set intersection and we expected nothing common.

Because of the above reason, its [not accurate to represent joins with Venn Diagrams](https://blog.jooq.org/say-no-to-venn-diagrams-when-explaining-joins/), but they are mostly correct for basic understanding. SQL provides set operations - `UNION`, `INTERSECT`, `EXCEPT` (aka `MINUS` in vendor-specific dialects)

### Non-Equi Joins are hella useful! 
Equi joins are fairly intuitive but non-equi joins are what helps in [problem solving](https://learnsql.com/blog/sql-non-equi-joins-examples/).

Problem solving tips:
- irl, a single `Employees` table may store lots of data like employee-manager details, `Processes` table can store process start-finish timestamps - do self join to solve
- many problems can be solved with subqueries or CTE too, but solving it with joins can be better for execution time and space constraints 

### ON vs WHERE clause with Joins
**ON** - applied during the join operation (only rows matching the criteria are picked for joining)

**WHERE** - applied after the join operation (on transient table)

```sql
-- typical use case: performs join and applies where condition on transient join table
SELECT *
FROM A a JOIN B b ON a.id = b.id
WHERE a.id < 3

-- clubbing condition in join predicate (equivalent to above only for inner joins)
SELECT *
FROM A a JOIN A b ON a.id = b.id AND a.id < 3
```
[db-fiddle](https://www.db-fiddle.com/f/kwBLvL8WUSbxvjSprJg5ce/300)

While they may appear equivalent and that's the case with Inner Joins, but not with Outer Joins! [db-fiddle](https://www.db-fiddle.com/f/kwBLvL8WUSbxvjSprJg5ce/303)

<<<<<<< HEAD
**Effect on Inner Join** - The filtering can happen anywhere and the end result is same.

**Effect on Outer Join** - The left table is added as it is (LEFT JOIN) and we consider only rows matching the predicate for join from table `B b`. This creates a total of atleast _rowCount(A)_ rows. But if we apply condition in WHERE clause, we will end up with a handful of rows that match the condition.
=======
Inner Join - The filtering can happen anywhere and the end result is same.

Outer Join - The left table is added as it is (LEFT JOIN) and we consider only rows matching the predicate for join from `b`. This creates a total of atleast _rowCount(A)_ rows. But if we apply condition in WHERE clause, we will end up with only some rows that match the condition.
>>>>>>> aac5eacbf32561c024b2fa0a10ce34e6422be253

[Reference](https://www.atlassian.com/data/sql/difference-between-where-and-on-in-sql)

## Advance Querying and Aggregation

`GROUP BY` groups rows and we can display aggregate quantities from the table in `SELECT` clause like `COUNT(id)`, `SUM(qty)`, etc. Apply conditions on group set using `HAVING` clause. [link](https://leetcode.com/problems/customer-who-visited-but-did-not-make-any-transactions/)

Use `REGEXP` in MySQL, or `~` in Postgres:
```sql
WHERE name REGEXP '^[a-zA-Z0-9]+$'  -- MySQL
WHERE name ~ '^[a-zA-Z0-9]+$'       -- PostgreSQL
WHERE name LIKE 'abhi%'             -- Both, but limited pattern matching (not Regex)
```