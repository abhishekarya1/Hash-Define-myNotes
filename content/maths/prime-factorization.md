+++
title = "Prime Factorization and Divisors"
date =  2020-07-14T14:21:29+05:30
weight = 5
pre = "<b>4.</b> "
+++

**Recall:** [Fundamental Theorem Of Arithmetic](/competitive-programming/maths/basics/#fundamental-theorem-of-arithmetic)

### Important Points
##### The number of divisors is odd only for Perfect Squares.

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
**Efficient Approach:** Suitable for finding sum of divisors (**Aliquot Sum**) as it does not print divisors in ascending order.

`Time = O(√n)`

```cpp
void printDivisors(int n)
{
    for (int i = 2; i*i <= n; ++i)      //till sqrt(n)
    {
        if(n % i == 0) 
        {   
            if(i*i == n) cout << i << " ";      //for cases like, n=16, i and (n/i) both will be 4, we print only one
            else cout << i << " " << (n/i) << " ";
        }    
    }

    cout << 1; //don't forget the 1
}
```

**Aliquot Sum:**
```cpp
int sumDiv(int n)
{
    int sum = 0;
    for (int i = 2; i * i <= n; ++i)
    {
        if (n % i == 0)
        {
            if (i * i == n) sum += i;
            else sum += i + (n / i);
        }
    }

    return sum+1;
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

    if(n > 1) cout << n;    //the largest factor is prime itself
}
```

##### Using Sieve O(log n)
Link: https://www.geeksforgeeks.org/prime-factorization-using-sieve-olog-n-multiple-queries/

##### Pollard's Rho Algorithm
Link: https://www.geeksforgeeks.org/pollards-rho-algorithm-prime-factorization/

#### Applications

**Prime Signature -** https://mathworld.wolfram.com/PrimeSignature.html

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
9. [Perfect Number](https://www.geeksforgeeks.org/perfect-number/) - A number is a perfect number if is equal to sum of its proper divisors, that is, sum of its positive divisors excluding the number itself. Ex - 6 = 1 + 2 + 3. It is unknown whether there are any odd perfect numbers. <br>
10. [Betrothed numbers](https://www.geeksforgeeks.org/betrothed-numbers/ ) - Betrothed numbers are two positive numbers such that the sum of the proper divisors of either number is one more than (or one plus) the value of the other number. _n1 = sum2 - 1_ and _n2 = sum1 - 1_. <br>
11. [k-Rough Number or k-Jagged Number](https://www.geeksforgeeks.org/k-rough-number-k-jagged-number/) - A k-rough or k-jagged number is a number whose smallest prime factor is greater than or equal to the number ‘k’. <br>
12. [Amicable Pair](https://www.geeksforgeeks.org/check-amicable-pair/) - Two different numbers so related that the sum of the proper divisors of each is equal to the other number. <br>
13. [Friendly Pair](https://www.geeksforgeeks.org/check-given-two-number-friendly-pair-not/) - Two numbers whose ratio of sum of divisors and number itself is equal.
