+++
title = "Applications"
date =  2020-07-19T11:05:21+05:30
weight = 2
pre = "<b>1.</b> "
+++

### Applications
1. Finding duplicate and missing elements in an array. [Link](https://takeuforward.org/data-structure/find-the-repeating-and-missing-numbers/)
2. Detect if two integers have opposite signs. `(x ^ y) < 0`
3. Adding 1 to number without using + operator. `xPlusOne = -(~x)`, since `~x = -(x+1)` holds.
4. Unset the rightmost set bit. `n & (n - 1)`
5. Set the rightmost unset bit. `n | (n + 1)`
6. Keep only the rightmost set bit. `n & ~(n - 1)`
7. Checking is number is power of 4. `single set bit having even number of 0s on its right side`
8. Checking is number is power of 2. `n & (n - 1) will be 0`
9. Modulus division by a number (n) of the form _2<sup>k</sup>_ (d). `n & (d-1)`, so in place of _(n % 4)_ we can write _(n & 3)_.
10. Rotating bits. Left = `n << k | n >> (32-k)` and Right = `n >> k | n << (32-k)`
11. Multiplying with 3.5. `2x + x + x/2` = `(x << 1) + x + (x >> 1)`
12. Multiplying with 7. `8x - x` = `(x << 3) - x`
13. Counting bits to be flipped to convert A to B (Bit Difference). This is `number of set bits in A ^ B`.
14. Finding position of rightmost set bit. `Do 2's complement, & with original number, take log2(ANDresult)` = `log2(n & -n) + 1`
15. Finding Binary Representation of a decimal number. [Link](https://www.geeksforgeeks.org/binary-representation-of-a-given-number/)
16. Swap two numbers without using a temporary variable.
17. Turn off a particular bit. `n & ~(1 << (k - 1)` (one based indexing from LSB)
18. Toggle particular bit. `n ^ (1 << (k - 1))` (one based indexing from LSB)
19. Russian Peasant (Multiply two numbers using bitwise operators). [Link](https://www.geeksforgeeks.org/russian-peasant-multiply-two-numbers-using-bitwise-operators/)
20. Check if two numbers are equal. `a ^ b = 0 only if a, b are equal`
21. Find XOR of two number without using XOR operator. `(x | y) & (~x | ~y)`
22. XOR from [1 to n] efficiently. [Link](https://www.geeksforgeeks.org/calculate-xor-1-n/) [**XOR repeats on modulo 4**]
23. Toggling Case of characters in a String. `str[i] ^= 32` 