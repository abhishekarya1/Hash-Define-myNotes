+++
title = "Concepts"
date =  2022-06-24T10:42:00+05:30
weight = 2
pre = "<i class='fas fa-pen' style='color: white'></i> "
+++

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

2. **Phantom Reads**: two exact same queries (with predicate - `WHERE` clause) returning different rows as output when run at an interval (or in separate transactions); due to another transaction changing data corresponding to the predicate and committing it

3. **Non-repeatable Reads**: reads the same row twice at different points in time and gets a different value each time

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

