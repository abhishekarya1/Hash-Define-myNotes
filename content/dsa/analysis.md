+++
title = "Algorithmic Analysis"
date = 2021-09-28T20:19:34+05:30
weight = 1
pre = "<b>0. </b>"
+++

## Algorithmic Analysis

References: [GfG](https://www.geeksforgeeks.org/fundamentals-of-algorithms/?ref=shm#AnalysisofAlgorithms) and [Kunal](https://youtu.be/mV3wrLBbuuE).

**Asymptotic** - Closely approaching a curve or value, defining some limit

**Asymptote** - A curve closely approaching another curve (asymptotic to another curve)

In mathematical analysis, asymptotic analysis, also known as "asymptotics", is a method of describing limiting behavior.

**Frequency Count** - Number of times each statement is executed e.g. 5n+1

**Time Complexity** - Measure of growth in runtime(_t_) of an algorithm w.r.t size of input(_n_) i.e. it is not an absolute measure but a mathematical function e.g. O(nlogn)

**Space Complexity** = Auxiliary Space (may not grow) + Space taken by input (will grow as input grows). Space complexity of all sorting algorithms is `O(n)` despite the fact that some of them use auxiliary space (merge sort) and some don't (bubble sort).

**Asymptotic Notations** - Describe the limiting behavior of a function (time complexity).

{{% notice tip %}}
Literal meaning:
`O(g(n))` is { `f(n)`: Represents a **set of functions** whose growth w.r.t input size(n) is always <= `c * g(n)` }
The curve for `f(n)` also always lie under `c * g(n)` for sufficiently larger values of `n >= n0`, where n0 is algorithmic threshold and `c` is some arbitrary positive constant i.e. `c*g(n) >= f(n)`.

All curves that remain under `g(n)`'s curve in above case for all values of `n >= n0` is represented by `O` (big O) (strictly bound = curve + every curve under that curve).

The same can be extended for other two cases `Θ` and `Ω`.

For loosely bound asymptotes: little-oh(`o`) we can say `o(g(n)) = c*g(n) > f(n)` (notice no `>=`).
The same can be extended for little-theta.

{{% /notice %}}

```txt
Some common time complexities:

O(1) 				- Constant
O(loglogn)			- when loop variable update = pow(i, k)
O(logn)				- Logarithmic
O(cuberoot(n))
O(sqrt(n))
O(n)				- Linear
O(nlogn)			- Linearithmic
O(n^k) 				- Polynomial (k = constant)
O(k^n)				- Exponential (k = constant)
O(n!) or O(n^n)		- Factorial or n-power-n
```
[Practice](https://discuss.codechef.com/t/multiple-choice-questions-related-to-testing-knowledge-about-time-and-space-complexity-of-a-program/17976)

Cases:
- **Best Case**: Element found at index 0 (`O(1)`)
- **Worst Case**: Element never found (`O(n)`)
- **Average Case**: Element found at the middle index. (often times average of all the possible inputs isn't so obvious)

**Recurrence Relations** - an equation that recursively defines the total time taken as sum of parts where each part is also performed recursively. Solve them to get growth function (time complexity). A generalization of Master theorem called [Akra-Bazzi Method](https://www.geeksforgeeks.org/akra-bazzi-method-for-finding-the-time-complexities/) and [Practice Problems](https://www.csd.uwo.ca/~mmorenom/CS424/Ressources/master.pdf).

**Amortized Analysis** - to find the _average running time per operation in the worst case_. Each individual instruction's time is added and sum is divided by the total number of instructions. [Tutorial](https://algorithmtutor.com/Analysis-of-Algorithm/Amortized-Analysis-of-Algorithms/)

**Stirling's approximation** - `Θ( log(n!) ) = Θ( nlogn )`

#### P vs NP
- **P** (Polynomial Time): Easy and solvable by following some known sequence steps
- **NP** (Non-deterministic Polynomial Time): Solvable but doesn't follow a known sequence (does brute-force, which isn't relistic); we can verify solutions to such problems quickly though
- **NP Complete**: Hardest problems in the NP set. If one day, one of the NP-Complete problems can be reduced to a solvable (in polynomial time) problem L, then all of NP problems can reduced to L, and thus solved. Ex - Protein folding, Sudoku, Minesweeper, etc...
- **NP Hard**: Problems that may or may not be NP, and if problems not in NP get solved, other NP problems won't become reducible to L

The big question? **Is P = NP?**: Proving things is also a NP problem itself!

[P vs. NP and the Computational Complexity Zoo - YouTube](https://youtu.be/YX40hbAHx3s)