+++
title = "Prime Factorization and Divisors"
date =  2020-07-14T14:21:29+05:30
weight = 5
pre = "<b>4.</b> "
+++

**Recall:** [Fundamental Theorem Of Arithmetic](/competitive-programming/maths/basics/#fundamental-theorem-of-arithmetic)

### Important Points
1. The number of divisors is odd only for perfect square numbers. For the rest, the count is even. Use `floor(sqrt(b)) - ceil(sqrt(a)) + 1` to calculate all perfect square numbers between _a_ and _b_.
2. Only a prime's square has exactly 3 distinct factors i.e. _1_, _p_, and _p<sup>2</sup>_.
3. Power of a prime _p_ in _n!_ is given by Legendre's Factorization of n! => `Power of p in n! = floor(n/p) + floor(n/p^2) + floor(n/p^3)..... till p^k > n`. We can also calculate prime signature by finding out the exponents for each prime starting from 2 till p <= sqrt(n).
4. Maximum occurring divisor in an interval is 2.
5. Common divisors of two numbers are divisors of their GCD.
6. Numbers which gets divided by both _n_ **and** _m_ upto _q_ => _q / LCM(n, m)_, Numbers that get divided by _n_ **or** _m_ upto _q_ => _(q / m + q / n - q / LCM(n, m))_.

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

    return sum + 1;     //as we started loop from 2 to avoid adding n itself
}
```

**Sieve Based Method:**

`Time = O(len)` where _len_ is the number of divisors, and 

`Space = O(MAX)`

```cpp
const int MAX = 1e5;

vector<int> divisor[MAX + 1];   //array of vectors

void divisorSieve()
{
    for (int i = 1; i <= MAX; i++)
    {
        for (int j = i; j <= MAX; j += i)
        {
            divisor[j].push_back(i);
        }
    }
}

void printDiv(int n)
{

    for (int j = 0; j < divisor[n].size(); j++)
    {
        cout << divisor[n][j] << " ";
    }
}

int main() {

    int n = 10;
    //cin >> n;

    divisorSieve();

    printDiv(n);
}
```

### Prime Factorization

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

#### Using Sieve in O(log n) time
Link: https://www.geeksforgeeks.org/prime-factorization-using-sieve-olog-n-multiple-queries/

{{% notice info %}}
The idea is to store the Smallest Prime Factor (SPF) for every number in a separate array. Then to calculate the prime factorization of the given number by dividing the given number repeatedly with its smallest prime factor till it becomes 1 and storing the quotient in every step. Those quotients are prime factors of the number.
{{% /notice %}}

```cpp
void factorSieve(int n, bool* s, int* spf)
{
    s[0] = s[1] = false;
    spf[1] = 1;
    for (int i = 2; i <= n; i++)    //notice i<=n
    {
        if (s[i])
        {
            spf[i] = i;     //change
            for (int j = i * i; j <= n; j += i)
            {
                s[j] = false;
                if (spf[j] == -1) spf[j] = i;   //change
            }
        }
    }
}

int main()
{

    int n;
    cin >> n;

    bool s[n + 1];
    int spf[n + 1];
    memset(s, true, sizeof(s));
    memset(spf, -1, sizeof(spf));
        
    factorSieve(n, s, spf);

    //main logic
    while (n != 1)
    {
        cout << spf[n] << " ";
        n /= spf[n];
    }

    return 0;
}
```

##### Pollard's Rho Algorithm
Link: https://www.geeksforgeeks.org/pollards-rho-algorithm-prime-factorization/

### Applications

**Prime Signature -** https://mathworld.wolfram.com/PrimeSignature.html

Link: https://www.handakafunda.com/number-system-concepts-for-cat-even-factors-odd-factors-sum-of-factors/

1. All factors
2. Even/Odd factors
3. Sum of all factors
4. Sum of Even/Odd factors
5. Sum of all factors divisible by a number

### Types of Numbers based on Divisors
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
13. [Friendly Pair](https://www.geeksforgeeks.org/check-given-two-number-friendly-pair-not/) - Two numbers whose ratio of sum of divisors and number itself is equal. <br>
14. [P-Smooth Number or P-friable Number](https://www.geeksforgeeks.org/p-smooth-numbers-p-friable-number/) - An integer is _P–smooth_ number if the _largest Prime factor of that number <= p_. 1 is considered (by OEIS) as P–smooth number for any possible value of P because it does not have any prime factor. <br>
15. [k-Hyperperfect Number](https://www.geeksforgeeks.org/determine-whether-a-given-number-is-a-hyperperfect-number/) - A number _n_ is called _k-hyperperfect_ if: _n = 1 + k ∑idi_ where all _di_ are the proper divisors of _n_. Taking _k = 1_ will give us _perfect numbers_. <br>