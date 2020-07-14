+++
title = "Primes"
date =  2020-07-12T13:09:11+05:30
weight = 5
pre = "<b>4.</b> "
+++

### Basics and Theorems

### Primality Tests

#### 1. Naive School Method

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


### Find all primes upto N (Sieves)

### References
1. https://www.geeksforgeeks.org/prime-numbers <br>
2. https://brilliant.org/number-theory