+++
title = "Modular Arithmetic"
date =  2020-07-12T13:09:11+05:30
weight = 7
pre = "<b>6.</b> "
+++

### Remainders and % Operator
**In Maths:**

```
15 mod 7 = 1
12 mod 5 = 2
16 mod 4 = 0
2 mod 6 = 2

-1 mod 5 = -1 => 4		//do 1 mod 5 and add negative sign
-15 mod 7 = -1 => 6
-12 mod 5 = -2 => 3
12 mod -5 = 2 => -3
16 mod -4 = 0
```

**In Programming:**

- If x completely divides y, the result of the expression `y % x` is 0.
- If y is not completely divisible by x, then the result will be the remainder in the range `[1, x-1]`.
- If x is 0, then division by zero is a `compile-time error`.

**Restrictions in C/C++:**

- The % operator cannot be applied to floating-point numbers i.e float, double, or long double. It leads to `compile-time error`.
- Since C++11, the modulus operator used with negative operands and give predictable result: `x % y` always returns results with the sign of `x`.

### Operations on Modulo
**1.** (a + b) % c = ( ( a % c ) + ( b % c ) ) % c <br>
**2.** (a * b) % c = ( ( a % c ) * ( b % c ) ) % c <br>
**3.** (a – b) % c = ( ( a % c ) – ( b % c ) ) % c <br>
**4.** ~~(a / b ) % c = ( ( a % c ) / ( b % c ) ) % c~~ (Not Distributive)

**Negative Remainders with Subtraction:** We have to be careful with identity 3 as it can give negative value as result of modulo. Two fixes are - 

```cpp
int ans = (a - b) % mod;

if(ans < 0) ans += mod;
```

```cpp
int ans = ((a - b) % mod + mod) % mod;	//slower than previous way as it increases mod operations
```

#### Modulo Division
Identity: `(a / b) % m = ( ( a % m ) * ( 1/b ) % m ) % m`. Finding modulo for division is not always possible.

#### Modulo Exponentiation

### Fixing Overflows with Modulo
- Commonly used number is 10<sup>9</sup>+7 or `1e9+7`.

**Gotcha!!**

```cpp
long long ans;

ans = (a * b) % n;  //a and b are huge numbers
```

The above solution may lead to overflow as we multipled them and `even when we're not storing them in variable ans before the modulo, they are still huge for intermediate value to be stored temporarily for performing modulo operation by the machine.` Fix - 

```cpp
long long ans;
ans = ( (a % n) * (b % n) ) % n;
```

### Congruence

```
if (a mod n) = (b mod n), then
a ≡ b (mod n)
```

```
Some Observations regaarding a ≡ b (mod n):

1. a = k * n + b 	//b need not be the remainder of a/n

2. (a - b) is a multiple of n
```

**Congruence modulo is an equivalence relation for (mod C):** It is reflexive, symmetric, and transitive.
```
Reflexive: A ≡ A (mod N)

Symmetric: if A ≡ B (mod N) then B ≡ A (mod N)

Transitive: if A ≡ B (mod N) and B ≡ C (mod N) then A ≡ C (mod N)
```






### References
1. https://brilliant.org/number-theory <br>
2. https://www.geeksforgeeks.org/modular-arithmetic

