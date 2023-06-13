+++
title = "Applications"
date =  2020-07-19T11:05:21+05:30
weight = 2
pre = "<b>1.</b> "
+++

### Most Used
Assume `0`-based indexing, we can shift `n` too instead of `1` in the following tricks. 

- Set `i`th bit: `n | (1 << i)`
- Unset `i`th bit: `n & ~(1 << i)`
- Get `i`th bit, check if `i`th bit is set or unset: if `n & (1 << i) > 0` then set, else unset
- Toggle `i`th bit: `n ^ (1 << i)`
- Unset the rightmost set bit: `n & (n - 1)`
- Set the rightmost unset bit: `n | (n + 1)`
- Keep only the rightmost set bit: `n & ~(n - 1)`
- Check parity of a number: `if(n & 1)` then odd, else even
- Check if a number is power of 2: `n & (n - 1)` will be 0 (falsely reports `0` as a power of 2). Use this instead: `if (n && !(n & (n - 1)) == 0)`
- Swap two numbers with XOR: `x = x ^ y; y = x ^ y; x = x ^ y;`
- Toggle case of a character in a string: `str[i] ^= 32`
- Modulus division by a number (n) of the form _2<sup>k</sup>_ (d): `n & (d-1)`, so in place of _(n % 4)_ we can write _(n & 3)_.

### Some More Usages
- Detect if two integers have opposite signs: `(x ^ y) < 0`
- Check if two numbers are equal: `a ^ b = 0 only if a, b are equal`
- Counting bits to be flipped to convert A to B (Bit Difference): This is `number of set bits in A ^ B`.
- Multiplying with 3.5: `2x + x + x/2` = `(x << 1) + x + (x >> 1)`
- Multiplying with 7: `8x - x` = `(x << 3) - x`
- Adding 1 to number without using `+` operator: `xPlusOne = -(~x)`, since `~x = -(x+1)` holds.
- Checking is number is power of 4: `single set bit having even number of 0s on its right side`
- Finding position of rightmost set bit: `Do 2's complement, & with original number, take log2(ANDresult)` = `log2(n & -n) + 1`
- Find XOR of two number without using XOR operator: `(x | y) & (~x | ~y)`
- XOR from [1 to n] efficiently: [Link](https://www.geeksforgeeks.org/calculate-xor-1-n/) [**XOR repeats on modulo 4**]
- Rotating bits: Left = `n << k | n >> (32-k)` and Right = `n >> k | n << (32-k)`

### Algorithms
- Brian Kernighan's Algorithm - to find number of set bits in binary representation of a number
- Russian Peasant (Multiply two numbers using bitwise operators) [[link](https://www.geeksforgeeks.org/russian-peasant-multiply-two-numbers-using-bitwise-operators/)]
- Binary Exponentiation [[link](https://cp-algorithms.com/algebra/binary-exp.html#implementation)]
- Binary GCD [[link](https://cp-algorithms.com/algebra/euclid-algorithm.html#binary-gcd)]

### Related Questions
- Finding duplicate and missing elements in an array [[link](https://takeuforward.org/data-structure/find-the-repeating-and-missing-numbers/)]
- Finding Binary Representation of a decimal number [[link](https://www.geeksforgeeks.org/binary-representation-of-a-given-number/)]