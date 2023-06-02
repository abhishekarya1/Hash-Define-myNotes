+++
title = "Notes"
date = 2023-06-01T19:16:00+05:30
weight = 2
+++

Scalability - property of a system to continue to maintain desired performance proportional to the resources added for handling more work

**Tradeoffs**:
- Performance vs Scalability
- Latency vs Throughput
- Consistency vs Availibility (_read below_)

**CAP Theorem**: in a highly distributed system, choose any two amongst - _Consistency_, _Availibility_, and _Partition Tolerance_ (network breaking up). Networks are always unreliable, so the choice comes down to Consistency vs Availablity.
- **CP** - all nodes reads the latest writes; recover in case of network failures. Used in systems which require atomic reads and writes, if system can't verify sync across nodes (consistency) it will respond with error, violating availablity
- **AP** - nodes may not have the latest write data; recover in case of network failures. Used in systems where _eventual consistency_ is allowed, or when the system needs to continue sending data back despite external errors. The node won't wait for sync to happen, it will send whatever data it has.

Video: [What is CAP Theorem?](https://youtu.be/_RbsFXWRZ10)

**PACELC Theorem**: In case of ("PAC") we need to choose between C or A, (E)lse (even if system is running normally in the absence of partitions), we need to choose between (L)atency and (C)onsistency.
