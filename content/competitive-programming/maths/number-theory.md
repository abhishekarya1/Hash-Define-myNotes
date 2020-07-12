+++
title = "Number Theory"
date =  2020-07-12T13:09:11+05:30
weight = 2
pre = "<b>0.</b>"
+++

### Odd & Even Numbers
- Even numbers are of the form `2k`, and odd numbers are of the form `2k+1` for k = 0, 1, 2, 3...
- Even numbers are also called `Parity 0` integers and odd numbers are called `Parity 1` integers. 

```cpp
if(n % 2 == 0) cout << "Even";
else cout << "Odd";
```

**Efficient Way:**

```cpp
if(n&1) cout << "Odd";
else cout << "Even";
```

### Big Integers

### Primes

**Reference:** https://www.geeksforgeeks.org/prime-numbers

```cpp
// Naive Prime Check. Time = O(n)
bool isPrime(int n)
{
	if(n <= 1) return false;

	for(int i = 2; i <= sqrt(n); i++)
	{
		if(n % i == 0) return false;
	}

	return true;
}
```

#### Primality Tests

#### Find all primes upto N (Sieves)

### Modular Arithmetic

**References:** <br>
1. https://brilliant.org/number-theory <br>
2. https://www.geeksforgeeks.org/modular-arithmetic


#### Remainders and % Operator
**In Maths:**

```
15 mod 7 = 1
12 mod 5 = 2
16 mod 4 = 0

-15 mod 7 = -1 => 6
-12 mod 5 = -2 => 3
12 mod -5 = 2 => -3
16 mod -4 = 0
```

**In Programming:**

- If y completely divides x, the result of the expression `x % y` is 0.
- If y is not completely divisible by x, then the result will be the remainder in the range `[1, x-1]`.
- If x is 0, then division by zero is a `compile-time error`.

**Restrictions in C/C++:**

- The % operator cannot be applied to floating-point numbers i.e float, double, or long double. It leads to `compile-time error`.
- Since C++11, the modulus operator used with negative operands and give predictable result: `x % y` always returns results with the sign of `x`.

#### Identities
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

##### Modulo Division
Identity: `(a / b) mod m = (a x (inverse of b if exists)) mod m`. Finding modulo for division is not always possible.

##### Fixing Overflows with Modulo
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

