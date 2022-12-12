+++
title = "Basics"
date =  2020-07-19T10:17:43+05:30
weight = 1
pre = "<b>0.</b> "
+++

### Bitwise Operators in C/C++
AND (`&`), OR (`|`), NOT (`~`), XOR (`^`), LEFT SHIFT (`<<`), RIGHT SHIFT (`>>`)

{{% notice warning %}}
The left shift and right shift operators should _not_ be used for _negative_ numbers. If any of the operands is a negative number, it results in _undefined behaviour_. For example results of both `-1 << 1` and `1 << -1` is _undefined_. 

Also, if the number is shifted more than the size of integer, the behaviour is _undefined_. For example, `1 << 33` is undefined if integers are stored using 32 bits. See this for more details.
{{% /notice %}}


### int
In C/C++ `int` variable is _32-bits_ in size and can contain any integer between _−2<sup>31</sup>_ and _2<sup>31</sup> − 1_.

The first bit in a signed representation is the sign of the number (`0` for nonnegative numbers and `1` for negative numbers), and the remaining _n − 1_ bits contain the magnitude of the number. Two's complement is used to represent negative numbers. Ex -> 2 = 0...10 and -2 = 1...10  

### Peculiar Properties
AND (`&`) - Used to "mask" bits, it can check for set bits and we can mask a number using another.

OR (`|`) - Used to set bits.

NOT (`~`) - 1's complement of a number.

XOR (`^`) - Exclusivity between two numbers' bits. Toggling bits.
>
LEFT SHIFT (`<<`) - Left shift performed _k_ times multiplies the number by _2<sup>k</sup>_
>
RIGHT SHIFT (`<<`) - Right shift performed _k_ times divides the number by _2<sup>k</sup>_

**2's Complement of _n_ = _-n_**