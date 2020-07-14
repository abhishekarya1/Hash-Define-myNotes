+++
title = "GCD and LCM Advanced"
date =  2020-07-13T20:56:22+05:30
weight = 3 
pre = "<b>2.</b> "
+++

### Reducing Fractions

```	
 n	                    n / gcd(n, d)
--- => Reduced Fraction => ---------------
 d	                    d / gcd(n, d)
```

### GCD and LCM of fractions

```
	GCD (all numerators)
GCD = -------------------------
	LCM (all denominators)


	LCM (all numerators)
LCM = -------------------------
	GCD (all denominators)
```

### LCM of factorial and its neighbors
`LCM (n-1)!, n!, and (n+1)! is (n+1)!`

### GCD and LCM follow Distributive Property

```
gcd(a, lcm(b, c)) = lcm(gcd(a, b), gcd(a, c)) 

lcm(a, gcd(b, c)) = gcd(lcm(a, b), lcm(a, c)).
```

### GCD is distributive with other functions too
We can have out own function *f(n)* and *gcd* will be distributive over it and vice-versa.
```
gcd(f(n, x), f(n ,y)) = f(n, gcd(x, y))
f(gcd(n, x), gcd(n ,y)) = gcd(n, f(x, y))
```
Problem Link: https://www.geeksforgeeks.org/gcd-two-numbers-formed-n-repeating-x-y-times/ 

### Stein's Algorithm

`Time = O(n*n), where n is the number of bits in the larger of the two numbers.`

Also called **Binary GCD algorithm**, is used to find gcd based on Euclidean Algorithm in an optimizaed way by avoiding any arithmetical operations and with just bitwise operations.

Link: https://www.geeksforgeeks.org/steins-algorithm-for-finding-gcd/ <br>
Code: https://github.com/abhishekarya1/GfG-Codes/blob/master/Mathematical/GCD%20and%20LCM/gcd_steins_algo.cc

### GCD of floating point numbers
Challenges
- `%` operator doesn't work with floating point numbers in C/C++
- They never become `0` as they are highly precise

```cpp
double floatGCD(double a, double b)
{
	if(fabs(b) < 0.001)				//never reaches 0 but less than 0.001 will do
		return a;

	return floatGCD(b, a - floor(a/b) * b);		//or use: fmod(a, b)
}
```

### GCD of elements in a given range
GCD of consecutive numbers is 1, and GCD of any number with 1 is 1 itself. When we find `GCD(n, n+1)` in the range n to m, the full ranges' GCD becomes 1.

```cpp
int rangeGCD(int start, int end)
{
	if(start == end) return start;

	return 1;
}
``` 

### Array and GCD Problems

#### Largest Subset with GCD 1
If at any point in traversal gcd = 1, then full array is the largest subset as it will also have gcd = 1.

```cpp
int largestSubset(int *arr, int n)
{	
	int curGCD = arr[0];
	for(int i = 1; i < n; i++)
	{
		if(__gcd(curGCD, arr[i]) == 1)
			return n;
	}

	return 0;
}
```

### Minimum steps to come back to starting point in a circular tour
Link: https://www.geeksforgeeks.org/minimum-steps-to-come-back-to-origin-in-a-circular-tour/

If we jump m places in one step and there are a total of n slots in circle, then steps required to return to same place are: `n / gcd(n, m)`