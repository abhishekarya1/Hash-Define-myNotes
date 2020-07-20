+++
title = "Applications"
date =  2020-07-19T11:05:21+05:30
weight = 2
pre = "<b>1.</b> "
+++

### Applications
1. Finding single element that occurs odd number of times in an array. 
2. Detect if two integers have opposite signs. `(x ^ y) < 0`
3. Adding 1 to number without using + operator. `xPlusOne = -(~x)`, since `~x = -(x+1)` holds.
4. Turn off the rightmost set bit. `n & (n - 1)`
5. Checking is number is power of 4. `single set bit having even number of 0s on its right side`
6. Checking is number is power of 2. `n & (n - 1) will be 0`
7. Modulus division by a number (n) of the form _2<sup>k</sup>_ (d). `n & (d-1)`, so in place of _(n % 4)_ we can write _(n & 3)_.
8. Rotating bits. Left = `n << k | n >> (32-k)` and Right = `n >> k | n << (32-k)`
9. Multiplying with 3.5. `2x + x + x/2` = `(x << 1) + x + (x >> 1)`
10. Multiplying with 7. `8x - x` = `(x << 3) - x`
11. Counting bits to be flipped to convert A to B (Bit Difference). This is `number of set bits in A ^ B`.
12. Finding position of rightmost set bit. `Do 2's complement, & with original number, take log2(ANDresult)` = `log2(n & -n) + 1`
13. Finding Binary Representation of a decimal number. [Link](https://www.geeksforgeeks.org/binary-representation-of-a-given-number/)
14. Swap two numbers without using a temporary variable.
15. Swap two nibbles in a byte. `((x & 0x0F) << 4 | (x & 0xF0) >> 4 )`
16. Turn off a particular bit. `n & ~(1 << (k - 1)` (one based indexing from LSB)
17. Toggle particular bit. `n ^ (1 << (k - 1))` (one based indexing from LSB)
17. Russian Peasant (Multiply two numbers using bitwise operators). [Link](https://www.geeksforgeeks.org/russian-peasant-multiply-two-numbers-using-bitwise-operators/)
18. Check if two numbers are equal. `a ^ b = 0 only if a, b are equal`
19. Find XOR of two number without using XOR operator. `(x | y) & (~x | ~y)`
20. XOR from [1 to n] efficiently. [Link](https://www.geeksforgeeks.org/calculate-xor-1-n/)
21. Toggling Case of characters in a String. `str[i] ^= 32`
22. 