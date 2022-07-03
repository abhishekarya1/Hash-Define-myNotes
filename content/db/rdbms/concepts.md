+++
title = "Concepts"
date =  2022-06-24T10:42:00+05:30
weight = 2
pre = "<i class='fas fa-pen' style='color: white'></i> "
+++

### Indexes
Data structure that points to other data on the database for faster access. Sort of like a index of a book. When we have to query, DBMS will internally query this index instead of actual table data directly.

An index is a tree made **on** top of the table, where it is used to access table rows (leaf nodes). Refer diagram link below for more clarity.

Implemented using a subset of columns in `B-Tree`(default), `Hash`, etc...

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

**Clustered**: clustered index uses primary key column values of the table as intermediate nodes in B-Tree. The keys are [**sorted and then stored**](https://docs.microsoft.com/en-us/sql/relational-databases/indexes/clustered-and-nonclustered-indexes-described?view=sql-server-ver16#:~:text=Clustered%20indexes%20sort%20and%20store%20the%20data%20rows%20in%20the%20table%20or%20view%20based%20on%20their%20key%20values) in a B-Tree leafs, and leaf nodes of the tree have **actual table data** and all leafs are sorted in ascending order. The table rows are then rearranged acc to index i.e. primary key having asc order. This is why **only one** clustered index can exist in a given table (since asc sort is unique), whereas, multiple non-clustered indexes can exist for a given table.

**Non-Clustered / Secondary**: We can create **multiple** non-clustered indexes for a given table on other attibutes too. The leaf node in the B-Tree are record pointers which point to row in table corresponding to the key value. Access is **slower** than clustered index because of this record pointer redirection (linked-list style). Inserts are faster though since no sorting is performed.

Postgres doesn't have clustered indexes at all. Also, no limits on the number of indexes on a table in Postgres.

Clustered index outperforms non-clustered indexes for a majority of `SELECT` queries.

_B-Tree Diagrams_: https://stackoverflow.com/a/67958216

#### Indexes are not magic!
It is not always guaranteed that index will result in faster queries, for example, using `LIKE` clause even on indexed columns leads to slow queries since we have to match sequentially with the pattern. Other such cases are:

- when most of the tuples values are redundant. Ex - a gender column will only have some possible values
- `UPPER(name) = 'Rick'`, we can have an index on `name` but not on `UPPER(name)` so queries will be slow, creating index on `UPPER(name)` or a specialized search index from the DB provider can help
- Composite indexes: indexes on two or more columns depend on each other. When we have index on `first_name` and `last_name`, we often run queries using `last_name` and they will be slower since they both depend upon each other for indexing. In such cases, `first_name AND last_name` will utilize index and not `OR` since we will be scanning sequentially for `last_name`.

_Source_: [Hussein Nasser - YouTube](https://youtu.be/oebtXK16WuU)

`B-Tree`(default) index is more suitable for relational, `BETWEEN`, and pattern matching using `LIKE` cases. It is best for general cases.

`Hash` index is more suitable for rows where you know you will be performing equality `=` on frequently.

`GIN` index (Generalized INverted index) is suitable when multiple values are stored in a single column e.g. array, jsonb, etc... 

_Reference_: https://www.postgresqltutorial.com/postgresql-indexes/



### Transactions
A transaction is a _sequence of operations_ performed (using one or more SQL statements) on a database as _a single logical unit of work_.

Ex - A bank fund transfer from user A to B is essentially just a simple transfer, but comprises of many operations like subtract funds from A and add funds to B.

DBMS like MySQL and Postgres "gurantee" **ACID** (Atomicity, Consistency, Isolation, Durability) properties.

**Atomicity**: Every operation in transaction should happen "all or none", the transactions themselves should be atomic

**Consistency**: Database state after and before every transaction should be consistent

**Isolation**: Multiple transactions should "appear" to proceed as if they are independently executing (no interference) and completely transparent to each other

**Durability**: Changes should persist even after transcation is finished (commit to disk)

[TCL Commands](/db/rdbms/mysql/#tcl)

#### Issues
When two or more transactions read/write to a common data resource, below issues can be faced:

1. **Dirty Reads**: transaction reads uncommitted data from another transaction

2. **Phantom Reads**: two exact same queries (with same predicate typically using `WHERE` clause) returning different rows as output when run at an interval (or in separate transactions); due to another transaction _changing data corresponding to the predicate_ and committing it

3. **Non-repeatable Reads**: reads the same _row_ twice at different points in time and gets a different value each time

#### Isolation Levels

4 levels are defined by SQL standard to avoid above issues. In increasing order of isolation:

1. **Read Uncommitted**: can read data that is uncommitted in other transactions; often leads to dirty reads.

2. **Read Committed** (_default in Postgres_): guarantees that only the data that had been committed can be read. Any uncommited data in other transaction is transparent to us; dirty reads are avoided here.

3. **Repeatable Read**: guarantees that once we have read some data, it will always return the same data in future too. Holds read and write locks for _all row(s) that transaction operates on_. Due to this, non-repeatable reads are avoided as other transactions cannot read, write, update or delete the row(s) that are locked. (Row level locking)

4. **Serializable**: locks the whole table to a transaction so every other concurrent transaction is blocked to read/write to the entire table. (Table level locking)

5. **Snapshot**: makes the same guarantees as serializable, but not by requiring that no concurrent transaction can modify the data. Instead, it forces every reader to see its own version of the world (it's own "SNAPSHOT"). This makes it very easy to program against as well as very scalable as it does not block concurrent updates. However, that benefit comes with a price: extra server resource consumption.

![isolation level and issues chart](https://i.imgur.com/PZfvE7t.png)

https://www.postgresql.org/docs/7.2/transaction-iso.html

https://stackoverflow.com/questions/4034976/difference-between-read-commited-and-repeatable-read


### Normalization

