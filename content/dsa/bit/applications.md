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
- XOR from [1 to n] efficiently: [Link](https://www.geeksforgeeks.org/calculate-xor-1-n/) [**XOR repeats on modulo 4**] [based on `n % 4` values can be `n, 1, n+1, 0`]
- Rotating bits: Left = `n << k | n >> (32-k)` and Right = `n >> k | n << (32-k)`

### Algorithms
- Brian Kernighan's Algorithm - to find number of set bits in binary representation of a number [[link](https://www.geeksforgeeks.org/count-set-bits-in-an-integer/)]
- Russian Peasant Multiplication and Egyptian Multiplication (Multiply two numbers using bitwise operators) [[link](https://www.geeksforgeeks.org/russian-peasant-multiply-two-numbers-using-bitwise-operators/)]
- Binary Exponentiation [[link](https://cp-algorithms.com/algebra/binary-exp.html#implementation)]
- Binary GCD [[link](https://cp-algorithms.com/algebra/euclid-algorithm.html#binary-gcd)]

### Related Questions & Tricks
- Power Set - all subsets [[link](https://leetcode.com/problems/subsets/)]
- Find Binary Representation of a decimal number [[link](https://www.geeksforgeeks.org/binary-representation-of-a-given-number/)]

**Operations on Range**:
- Find XOR of numbers in range L to R [[link](https://www.geeksforgeeks.org/find-xor-of-numbers-from-the-range-l-r/)] - use XOR's modulo property for ranges `ans = [L - R] = [1 - R] ^ [1 - (L-1)]`
- Find AND of numbers in range L to R [[link](https://leetcode.com/problems/bitwise-and-of-numbers-range/submissions/)]
	- Brute Force: TC = `O(n)`, TLE on LC
	- Shifting Approach: needs only L and R as both of their common part is also common to all numbers in the range. Common part will yield the same as AND's result (common part), rest will become `0` (shift out and shift back replacing it with 0s). TC = `O(log n)`
	- Keep Unsetting Rightmost Set Bit Approach: builds answer using the same concept as above but goto only set bits instead of shifting each bit. Do `n & (n-1)` and this unsets the rightmost set bit and then AND operation on this position with any other number will yield `0` at this position in the final answer, so we keep doing this to form ans till `ans > left` (in the last iteration `ans & left` will happen as `left = ans-1`). TC = `O(popcount(n))`

**Forming two buckets trick**:
- Find duplicate and missing elements in an array [[link](https://takeuforward.org/data-structure/find-the-repeating-and-missing-numbers/)]
- Find two elements occuring odd numnber of times [[link](https://takeuforward.org/data-structure/two-odd-occurring/)]

**Counting Bits trick**: usually we can count set bits in `log n` time using Brian-Kernighan's Algorithm, but if we need to count set bits for each number in range `[0 - n]` we can do so in `O(n)` time using DP as `dp[i] = dp[i/2] + i%2` where `dp[0] = 0` is the base case [problem](https://leetcode.com/problems/counting-bits/) [video](https://www.youtube.com/watch?v=awxaRgUB4Kw)
- this is based on the simple observation that for a number `N` shifting it rightwards by 1 (dividing by 2; halving) will either have equal set bits (if `N` is even) or 1 extra set bits (if `N` is odd) since shifting causes LSB to get lost

### TC of Bitwise Algorithms
Everything we do on a binary representation of a number is `log n` time, since a number's binary representation can contain atmost `n` bits.