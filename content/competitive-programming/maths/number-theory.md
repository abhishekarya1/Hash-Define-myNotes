+++
title = "Number Theory"
date =  2020-07-12T13:09:11+05:30
weight = 2
pre = "<b>0.</b>"
+++

#### Odd & Even Numbers
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

#### Big Integers

#### Primes

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

##### Primality Tests

##### Find all primes upto N (Sieves)

#### Modular Arithmetic

