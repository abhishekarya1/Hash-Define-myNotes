+++
title = "Prime Factorization and Divisors"
date =  2020-07-14T14:21:29+05:30
weight = 5
pre = "<b>4.</b> "
+++

**Recall:** [Fundamental Theorem Of Arithmetic](/competitive-programming/maths/basics/#fundamental-theorem-of-arithmetic)

### Finding Divisors

`Time = O(n)`

```cpp
void printDivisors(int n)
{
	for (int i = 1; i <= n; ++i)		//till n
	{
		if(n % i == 0) 
			cout << i << " ";
	}
}
```

#### Prime Factorization

`Time = O(√n)`

```cpp
void printPrimeFactors(int n)
{
    for(int i = 2; i*i <= n; i++)
    {
        while(n % i == 0)
        {
            cout << i << " ";
            n /= i;
        }
    }

    if(n > 1) cout << n;
}
```

#### 