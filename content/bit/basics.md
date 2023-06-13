+++
title = "Basics"
date =  2020-07-19T10:17:43+05:30
weight = 1
pre = "<b>0.</b> "
+++

## Operators and Data Type
### Bitwise Operators in C/C++
AND (`&`), OR (`|`), NOT (`~`), XOR (`^`), LEFT SHIFT (`<<`), RIGHT SHIFT (`>>`)

{{% notice warning %}}
The left shift and right shift operators should _not_ be used for _negative_ numbers. If any of the operands is a negative number, it results in _undefined behaviour_. For example results of both `-1 << 1` and `1 << -1` is _undefined_. 

Also, if the number is shifted more than the size of integer, the behaviour is _undefined_. For example, `1 << 33` is undefined if integers are stored using 32 bits. See this for more details.
{{% /notice %}}


### int Data Type
In C/C++ `int` variable is _32-bits_ in size and can contain any integer between _−2<sup>31</sup>_ and _2<sup>31</sup> − 1_.

The first bit in a signed representation is the sign of the number (`0` for non-negative numbers and `1` for negative numbers), and the remaining _n − 1_ bits contain the magnitude of the number. Two's complement is used to represent negative numbers. 

### Properties
AND (`&`) - Used to "mask" bits, it can check for set bits and we can mask a number using another.

OR (`|`) - Used to set bits.

NOT (`~`) - 1's complement of a number.

XOR (`^`) - Exclusivity between two numbers' bits. Toggling bits.
>
LEFT SHIFT (`<<`) - Left shift performed _k_ times multiplies the number by _2<sup>k</sup>_
>
RIGHT SHIFT (`<<`) - Right shift performed _k_ times divides the number by _2<sup>k</sup>_

**2's Complement of _n_ = _-n_**


## Binary Negative - 2s Complement Form
We needed a system to represent negative numbers in binary. 1s complement won't work because it will yield two representations for `0`, `0000` (`+0`) and its 1s complement `1111` (`-0`????).

Finally we settled on 2s complement to represent negative numbers, this way zero has a single representation and addition also checks out `n + (-n) = 0`.

With `n` bits, we can represent numbers in the range [_−2<sup>n-1</sup>_, _2<sup>n-1</sup> − 1_].

After _2<sup>n-1</sup> - 1_ positives, numbers loop around to lowest negative value as shown in the below diagram:

![](https://images.slideplayer.com/31/9715344/slides/slide_24.jpg)

```cpp
// loop around demonstration with int overflow in C++
#include <iostream>
#include <climits>

int main() {
    std::cout << INT_MAX + 1;		// overflow; prints "-2147483648" (lowest negative)
    return 0;
}
```

{{% notice notice %}}
It is not always possible to see a negative number written in binary form and tell what number it is by magnitude calc using powers of 2. It works for `-4 = 1100, +4 = 0100` but not for `-5 = 1011, +5 = 0101` and many others.
{{% /notice %}}

```txt
since, 2s complement = 1s complement + 1

-n = ~n + 1

=> ~n = -(n+1)
```

