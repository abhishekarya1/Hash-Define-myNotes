+++
title = "Misc Topics"
date =  2022-11-28T22:02:00+05:30
weight = 14
+++

Shallow Copy, Deep Copy, Cloning

Thread Priority levels - 1, 5, 10

Marker Interfaces

`>>` vs `>>>` operator

Double-brace initialization

String's length() isn't accurate - counts code points rather than no. of chars

3 GC scenarios: ref null, ref to other object, Island of Isolation

Double-checked locking in Singleton

Use Object as a Key in HashMap - `equals()` and `hashCode()`

`wait()` and `notify()` mechanism in Thread

`wait()` vs `sleep()`

String being immutable is a:
- security friendly: an SQL query stored as String can't be modified in transit (prevents SQL injections)
- security risk: as the object will remain in heap before it is garbage collected by JVM (we don't control its lifetime).
Use `char[]` to store passwords and manual erasure of each element is possible (as opposed to String as they are immutable) as soon as its work is done.
