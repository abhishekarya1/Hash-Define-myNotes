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
        while(n % i == 0)       //removing every i from n
        {
            cout << i << " ";
            n /= i;
        }
    }

    if(n > 1) cout << n;
}
```

#### Applications

Link: https://www.handakafunda.com/number-system-concepts-for-cat-even-factors-odd-factors-sum-of-factors/

1. All factors
2. Even/Odd factors
3. Sum of all factors
4. Sum of Even/Odd factors
5. Sum of all factors divisible by a number

#### Types of Numbers based on Divisors
1. [Smith Numbers](https://www.geeksforgeeks.org/smith-number/) - Composite numbers with sum of prime factors equal to sum of digits in the number. <br>
2. [Sphenic Numbers](https://www.geeksforgeeks.org/sphenic-number/) - A positive integer having exactly three distinct prime factors. Alternatively, it is a product of exactly three distinct primes. Every sphenic number will have exactly 8 divisors. <br>
3. [Hoax Numbers](https://www.geeksforgeeks.org/hoax-number/) - Similar to Smith numbers but here factors must be distinct. Some Hoax Numbers are Smith Numbers. <br>
4. [Frugal Number](https://www.geeksforgeeks.org/frugal-number/) - A number whose number of digits is strictly greater than the number of digits in its prime factorization (including exponents). As apparent, a prime number cannot be frugal. <br>
5. [Blum Integer](https://www.geeksforgeeks.org/blum-integer/) - It is a semiprime (product of two distinct primes) and those two prime factors are of the form _4t+3_ where _t_ is some integer. <br>
6. [Superperfect Number](https://www.geeksforgeeks.org/superperfect-number/) - A superperfect number is a positive integer which satisfies _σ<sup>2</sup>(n) = σ(σ(n)) = 2*n_, where _σ_ is divisor summatory function. <br>
7. [Powerful Number](https://www.geeksforgeeks.org/powerful-number/) - A number is said to be Powerful Number if for every prime factor _p_ of it, _p<sup>2</sup>_ also divides it. For example, 36 is a powerful number as it is divisible by both 3 and square of 3 i.e, 9. <br>
8. [Deficient Number](https://www.geeksforgeeks.org/deficient-number/) -  Sum of divisors of the number is less than twice the value of the number _n_. The difference between these two values is called the _deficiency_. <br>
9. []()