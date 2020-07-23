+++
title = "Divisibility"
date =  2020-07-22T19:51:16+05:30
weight = 7
pre = "<b>6.</b> "
+++

### Divisibility Rules
- **2<sup>n</sup>, 5<sup>n</sup>, and 10<sup>n</sup> -** Check if the last _n_ digits are divisible.
- **3 and 9 -** Check if digital sum is divisible.
- **6 -** Check if number is divisible by both 2 and 3.
- **7 -** Subtract twice the last digit from the remaining number and check divisibility again.
- **11 -** If, _sum of all digits at odd position - sum of all digits at even position_ is 0, then number is divisible by 11.
- **12 -** Check if number is divisible by both 3 and 4	.

### Forming Divisibility Rules
**Composites -** A number is divisible by a given divisor if it is divisible by the highest power of each of its prime factors. For example, to determine divisibility by 36, check divisibility by 4 and by 9. Note that checking 3 and 12, or 2 and 18, would not be sufficient.

**Primes -** We can form divisibility rules for primes >=13 by the following method.

Suppose we want to find divisibility rule for 13, then we form equation as: 3x + 1 = 13, solving for x gives us x = 4 and we must multiply x with unit digit and sum to the remaining number and check divisibility again by 13.

Suppose we want to find divisibility rule for 17, then we form equation as: 7x + 1 = 17, solving for x gives us x = 16/7 (floor of it is 2) and we must multiply x with unit digit and **subtract** from the remaining number and check divisibility again by 17.


### References
1. https://en.wikipedia.org/wiki/Divisibility_rule
2. [D!NG - Divisibility Rules](https://www.youtube.com/watch?v=f6tHqOmIj1E)
3. Brilliant Wiki <br>
	i. [Divisibility Rules](https://brilliant.org/wiki/divisibility-rules/) <br>
	ii. [Proof Of Divisibility Rules](https://brilliant.org/wiki/proof-of-divisibility-rules/) 