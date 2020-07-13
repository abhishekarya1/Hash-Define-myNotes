+++
title = "GCD, LCM, and Euclidean Algorithm"
date =  2020-07-13T11:52:11+05:30
weight = 2
pre = "<b>1.</b> "
+++

## GCD
GCD (Greatest Common Divisor) or HCF (Highest Common Factor) of *n* numbers *n1*, *n2*, *n3*, ... is defined as largest number *g* which divides all of them. Ex - *GCD(15, 20) = 5*, *GCD(6,7) = 1*.

### Properties
1. `GCD(a, b) <= min(a, b)`

2. `GCD(a, b) >= 1`

3. `GCD(a, b) = GCD(|a|, |b|)` 

4. `For any non-zero m ∈ Z, GCD(ma, mb) = |m| * GCD(a, b)`

5. `GCD(a, b) = GCD(a + b, b) = GCD(a - b, b) = GCD(a * b, b)` (may or may not be equal to `GCD(a/b, b)`)

6. `GCD(a, b) = GCD(a - kb, b), where k = 0, 1, 2 ...`

7. `GCD(a, b) = GCD(a % b, b)` while `a > b` **(Euclid's Theorem)** (Since 6 is true, modulo is nothing but remaining after repeated subtraction of b from a (aka division => a - (a / b) * b)

### Solutions

#### Prime Factorization
Product of smallest powers of only common factors.

#### Brute Force

`Time = O(min(a, b))`

Since *property 1*, start from 1 and divide each number by *a* and *b*, keep track of the largest number that divides both and gcd will be that number after the loop finishes.


#### Based on GCD(a, b) = GCD(a - b, b)
This algorithm again takes `O(max(a, b))` time in worst case because if *b = 1*, then, we have to call function *a* times.

This is basically reduction of larger number into smaller by subtraction.

```cpp
int GCD(int a, int b){
	if(a == 0) return b;
	if(b == 0) return a;

	if(a == b) return a;

	if(a > b) return GCD(a - b, b);
	else return GCD(a, b - a);	
}
```

#### Based on Euclid's theorem
`Time = O(log(min(a, b)))`

`Worst Case = a and b are consecutive numbers in fibonacci sequence`

`Worst Case recursive calls = n-2`

This is basically reduction of larger number into smaller by modulo.

```cpp
int GCD(int a, int b)
{
	if(b == 0) return a;

	return GCD(b, a % b);		//don't forget to swap
}
```

## LCM 
LCM (Lowest Common Multiple) *l* of numbers *n1*, *n2*, *n3*, ... is defined as them least number that is completely divisible by all the numbers. Ex - *LCM(6, 12) = 12*, *LCM(5, 18) = 90*.

### Properties
1. `LCM(a, b) >= max(a, b)`
2. `a * b = LCM(a, b) * GCD(a, b)` **(true for only two numbers)**

### Solutions

#### Prime Factorization
Product of largest powers of all factors.

#### Brute Force

Since *property 1*, start from *max(a, b)* and take all its subsequent multiples and the first number that divides *min(a, b)* will be our answer.

```cpp
int LCM(int a, int b) 
{ 
    int lar = max(a, b); 
    int small = min(a, b); 
    for (int i = lar; ; i += lar) { 
        if (i % small == 0) 
            return i; 
    } 
} 
```

#### Using GCD
Use formula in *property 2* above.


## Euclidean Algorithm
```
gcd(a, b) =	a,		if b = 0
		
		gcd(b, a % b)	otherwise
```

## Extended Euclidean Algorithm
EA can find *gcd(a, b)*, but EEA can also find coefficients `x` and `y` such that: `x * a + y * b = gcd(a, b)` 

```
x = y1

y = x1 - floor(a / b) * y1
```
Proof: https://www.cp-algorithms.com

**Implementation**
```cpp
int gcd (int a, int b, int &x, int &y) {
	if (b == 0) {
		x = 1; y = 0; 
		return a;
	}
	int x1, y1;
	int d = gcd (a, a%b, x1, y1);
	x = y1;
	y = x1 - (a / b) * y1;

	return d;
}
```

## References
1. https://procoderforu.com/gcd/<br>
2. https://www.geeksforgeeks.org/c-program-find-gcd-hcf-two-numbers/ <br>
3. https://cp-algorithms.com