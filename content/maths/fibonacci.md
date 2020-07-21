+++
title = "Fibonacci Numbers"
date =  2020-07-21T17:02:15+05:30
weight = 6
pre = "<b>5.</b> "
+++

In mathematics, the Fibonacci numbers, commonly denoted _F<sub>n</sub>_, form a sequence, called the _Fibonacci sequence_, such that each number is the sum of the two preceding ones, starting from 0 and 1. That is, **_F<sub>0</sub> = 0_, _F<sub>1</sub> = 1_,** and **_F<sub>n</sub> = F<sub>n-1</sub> + F<sub>n-2</sub>_** for **_n > 1_**. Sequence = 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, ...

**Negative :** The Fibonacci sequence also works below 0. It has alternating + and - accordingly. Ex - ..., −8, 5, −3, 2, −1, 1, 0. Which is basically, **_F<sub>−n</sub> = (−1)<sup>n+1</sup> * F<sub>n</sub>_** for **_n > 1_**.

They also appear in biological settings, such as branching in trees, the arrangement of leaves on a stem, the fruit sprouts of a pineapple, the flowering of an artichoke, an uncurling fern, and the arrangement of a pine cone's bracts.

### Finding nth Fibonacci Number

#### Recursive 

`Time = O(2^n)`

`Space = O(n)`

```cpp
int fib(int n)
{
    if(n == 0) return 0;
    if(n == 1) return 1;

    return fib(n - 1) + fib(n - 2);
}
```

#### Dynamic Programming

`Time = O(n)`

`Space = O(n)`

```cpp
int fib(int n)
{
    int arr[n + 1];
    arr[0] = 0;
    arr[1] = 1;

    for(int i = 2; i <= n; i++)
    {
        arr[i] = arr[i - 1] + arr[i - 2];
    }

    return arr[n];
}
```

#### Space Optimized (Best)

`Time = O(n)`

`Space = O(1)`

```cpp
int fib(int n)
{
    if(n == 0) return 0;
    if(n == 1) return 1;

    int a = 0, b = 1, c;

    for(int i = 2; i <= n; i++)
    {
        c = a + b;
        a = b;
        b = c;
    }

    return c;
}
```

#### Using Power of Matrix

Link: https://www.geeksforgeeks.org/program-for-nth-fibonacci-number/

#### Using Binet's Formula - O(1)

`Time = O(1)`

`Space = O(1)`

**Formula:** _F<sub>n</sub>_ is the nearest integer to _ϕ<sup>n</sup> / √5_.

```cpp
int fib(int n) { 
  double phi = (1 + sqrt(5)) / 2; 
  return round(pow(phi, n) / sqrt(5)); 
} 
```

### Some Interesting Facts.
1. To check if a number (_n_) is fibonacci or not - If either or both of **_5n<sup>2</sup>+4_** and **_5n<sup>2</sup>-4_** are perfect squares, then _n_ is a fibonacci number.
2. The series of last digits of numbers in Fibonacci sequence repeats with a cycle length of 60. Infact, Fibonacci sequence is periodic wrt Modulo.
3. **Cassini's Identity -**_F(n-1) \* F(n+1) – F(n) \* F(n) = (-1)<sup>n</sup>_. 
4. gcd(F<sub>a</sub>, F<sub>b</sub>) = F<sub>gcd(a, b)</sub> 
5. **Fibonorial -** In mathematics, the Fibonorial _n!<sub>F</sub>_, also called the Fibonacci factorial, where _n_ is a non-negative integer, is defined as the product of the first _n_ positive Fibonacci numbers.
6. [Hosoya's Triangle](https://www.geeksforgeeks.org/hosoyas-triangle/) - Follows four seed relations - `H(0, 0) = H(1, 0) = H(1, 1) = H(2, 1) = 1` and two recurrnce relations - `H(n, j) = H(n - 1, j) + H(n - 2, j)` and for the last element in current row `H(n, j) = H(n - 1, j - 1) + H(n - 2, j - 2)`.

### Zeckendorf's Theorem & Fibonacci Coding
Zeckendorf's Theorem states that every positive integer can be written uniquely as a sum of distinct non-neighbouring Fibonacci numbers. Ex = 30 = 21 8 1, and  41 = 34 5 2.

Fibonacci coding is used in place of binary representation to represent positive numbers in data processing and communications. One important observation about this representation is, **number of 1s in the Fibonacci representation tends to be much less than the number of 1s in the binary representation**. Hence if in any application where it is more costly to store a 1 than to store a 0, it would make sense to use the fibonacci representation.

```
//Greedy Algorithm to print Fibonacci representation of a number

1) Let n be input number

2) While n > 0
     a) Find the greatest Fibonacci Number smaller than n.
        Let this number be 'f'.  Print 'f'.
     b) n = n - f 
```

```cpp
int smallestFib(int n)
{
	if (n == 0) return 0;
	if (n == 1) return 1;

	int a = 0, b = 1, c = 1;
	while (c <= n)		//change
	{
		c = a + b;
		a = b;
		b = c;
	}

	return a;
}

int main() {
	int n = 30;

	int i = 0;
	while (n > 0)		//change
	{
		i = smallestFib(n);
		cout << i << " ";
		n = n - i;
	}

}

```

[Link#1](https://www.geeksforgeeks.org/zeckendorfs-theorem-non-neighbouring-fibonacci-representation/) <br>
[Link#2](https://www.geeksforgeeks.org/fibonacci-coding/)

### Modular Nature of Fibonacci
Fibonacci series is always periodic under modular representation i.e. _F (mod m)_ will repeat after a certain period and the cycle will repeat too. [Examples](https://www.geeksforgeeks.org/nth-multiple-number-fibonacci-series/)


### References
1. [GeeksforGeeks](https://www.geeksforgeeks.org/mathematical-algorithms/#fibonacci)<br>
2. [Brilliant Wiki](https://brilliant.org/number-theory/) <br>
	i. [Fibonacci Sequence](https://brilliant.org/wiki/fibonacci-series/) <br>
	ii. [Tribonacci Sequence](https://brilliant.org/wiki/tribonacci-sequence/)