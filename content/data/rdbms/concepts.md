+++
title = "Concepts"
date =  2022-06-24T10:42:00+05:30
weight = 2
pre = "<i class='fas fa-pen' style='color: white'></i> "
+++

### Indexes
Data structure that points to other data on the database for faster access. Sort of like a index of a book. When we have to query, DBMS will internally query this index instead of actual table data directly.

An index is a tree made **on** top of the table, where it is used to access table rows (leaf nodes). Refer diagram link below for more clarity.

Implemented using a subset of columns in `B-Tree`(default in Postgres), `Hash`, etc...

Queries that involve indexed columns are generally significantly faster.

**`PRIMARY KEY` is always indexed by default**.

```sql
-- creating index on emp_office column in employees table
CREATE INDEX myIndex 
ON employees(emp_office);

-- index as constraint: UNIQUE INDEX
CREATE UNIQUE INDEX myIndex
ON employees(name);
```

#### Types of Indexes

**Clustered / Primary**: clustered index uses primary key column values of the table as intermediate nodes in B-Tree. The table rows are [**sorted acc to key and then stored**](https://docs.microsoft.com/en-us/sql/relational-databases/indexes/clustered-and-nonclustered-indexes-described?view=sql-server-ver16#:~:text=Clustered%20indexes%20sort%20and%20store%20the%20data%20rows%20in%20the%20table%20or%20view%20based%20on%20their%20key%20values) in a B-Tree leafs, and leaf nodes of the tree have **actual table data** and all leafs are in ascending order. Along with sorting, the table rows are also rearranged into blocks so that it suits the index (tree). **Only one** clustered index can exist in a given table (since there can only be 1 PK and only one asc sort for it), whereas, multiple non-clustered indexes can exist for a given table. In most RDBMS, clustered index is automatically created using PK upon table creation.

**Non-Clustered / Secondary**: We can create **multiple** non-clustered indexes for a given table using non-key attibutes. The leaf nodes in the B-Tree are record pointers which point to row/block in table corresponding to the key value. They are often stored separately from table because they have record pointers and not the actual table data. Reading is **slower** than clustered index because of this record pointer redirection (linked-list style). Inserts are faster than clustered index since no sorting is required for leaf nodes.

Postgres doesn't have clustered indexes at all. Also, no limits on the number of indexes on a table in Postgres.

Clustered index outperforms non-clustered indexes for a majority of `SELECT` (read) queries that involve traversing (reverse too) and range based queries.

_B-Tree Diagrams_: https://stackoverflow.com/a/67958216

Other types of index:
- **Bitmap index** - table data is stored as bitmaps (0-1 arrays) and answering queries is done by performing bitwise operations on them. Suitable for cases where values repeat less frequently e.g. gender.
- **Dense index** - a file that stores key (PK) value and a record pointer to every corresponding record in the table data file
- **Sparse index** - a file that stores key (PK) value and a record pointer to every corresponding block in the table data file

_Reference_: [Database index - Wikipedia](https://en.wikipedia.org/wiki/Database_index)

#### Indexes are not magic!
It is not always guaranteed that index will result in faster queries, for example, using `LIKE` clause even on indexed columns leads to slow queries since we have to match sequentially with the pattern. Other such cases are:

- when most of the tuples values are redundant. Ex - a gender column will only have some possible values
- `UPPER(name) = 'Rick'`, we can have an index on `name` but not on `UPPER(name)` so queries will be slow, creating index on `UPPER(name)` or a specialized search index from the DB provider can help
- Composite indexes: indexes on two or more columns depend on each other. When we have index on `first_name` and `last_name`, we often run queries using `last_name` and they will be slower since they both depend upon each other for indexing. In such cases, `first_name AND last_name` will utilize index and not `OR` since we will be scanning sequentially for `last_name`.

_Source_: [Hussein Nasser - YouTube](https://youtu.be/oebtXK16WuU)

`B-Tree`(default in Postgres) index is more suitable for relational, `BETWEEN`, and pattern matching using `LIKE` cases. It is best for general cases.

`Hash` index is more suitable for rows where you know you will be performing equality `=` on frequently.

`GIN` index (Generalized INverted index) is suitable when multiple values are stored in a single column e.g. array, jsonb, etc... 

_Reference_: https://www.postgresqltutorial.com/postgresql-indexes



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

