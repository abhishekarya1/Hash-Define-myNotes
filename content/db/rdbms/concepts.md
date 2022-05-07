+++
title = "Concepts"
date =  2020-11-30T14:13:02+05:30
weight = 1
pre = "<i class='far fa-lightbulb'></i> "
+++

## Concurrency Control & ACID in Transactions
Transactions and their ACID Properties: [link](https://www.geeksforgeeks.org/acid-properties-in-dbms/)

Atomicity is ensured by: `commit` and `rollback` TCL operations of DBMS. We ensure Consistency and Isolation by the following means.

### Transaction States
<img src="https://beginnersbook.com/wp-content/uploads/2018/12/DBMS_Transaction_States_diagram.png" width="500">

### Concurrency and its advantages
**Concurrency:** When two or more transactions are allowed to proceed together. They may be executed _out-of-order_ or in _partial order_, without affecting the final outcome.

**Advantages:** Less waiting time, less response time, better utilization of resources, increased efficiency.

### Some Problems of Isolation
- Dirty Read - reading uncommited values from the buffer, may not always be bad
	- either read only the commited values from the source
	- or commit as soon as a read-write operation in the destination transaction
- Unrepeatable Read - reads same data twice, and get a different value each time.
- Lost Update (Write-Write Problem)/Blind Write - another transaction commits a different value
- Phantom Read - reading a deleted item

When we perform a `W()` (write) operation, we write to a local buffer. It's only at a `C` (commit) operation that we actually write to our database.

### Types of Schedules
[Notes](https://www.geeksforgeeks.org/types-of-schedules-in-dbms)
<img src="https://media.geeksforgeeks.org/wp-content/cdn-uploads/20190813142109/Types-of-schedules-in-DBMS-1.jpg" width="800">

If a schedule has `n` transactions then total number of serial schedules possible are `n!`.

### Conflict Serializability O(n^2) & Conflict Equivalent
[Notes](https://www.geeksforgeeks.org/conflict-serializability-in-dbms)

[Precedence Graph to test Serializability](https://www.geeksforgeeks.org/precedence-graph-for-testing-conflict-serializability-in-dbms/)

### View Serializability (NP-Complete) & View Equivalent
Superset of Conflict Serializability. <br>
**Pro Tip:** Every View Serailizable schedule has atleast one blind write. If schedule is not CS and has atleast on blind write, then we must prove view equivalence with all `n!` serial schedules.
<br>
[Notes](https://www.geeksforgeeks.org/view-serializability-in-dbms-transactions/)

<img src="https://i.imgur.com/0VI0PTb.png" width="400">

### Recoverable Schedule
[Notes](https://www.geeksforgeeks.org/recoverability-in-dbms/)

Dirty read can make a schedule unrecoverable. We must check if dirty read exists and if it does then changes must get commited in the same order/direction in which the dirty read was performed.

- **Cascading Rollback** - Transactions rollback in the order of dirty read
- **Cascadeless Schedule** - Commits as soon as writes, no dirty reads exists <br>
[Video](https://youtu.be/qH2iYtuJEwQ?list=PLmXKhU9FNesR1rSES7oLdJaNFgmuj0SYV)
- **Strict Schedule** - can't read or write before source transaction commits. Need not be serial.

### Concurrency Control Techniques

















## References
- [Knowledge Gate - YouTube](https://www.youtube.com/playlist?list=PLmXKhU9FNesR1rSES7oLdJaNFgmuj0SYV)
- [GeeksforGeeks - DBMS](https://www.geeksforgeeks.org/concurrency-control-in-dbms/) (see left sidebar on page)
- [Gate Vidyalay - Notes](https://www.gatevidyalay.com/database-management-system/) (best short notes)