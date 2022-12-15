+++
title = "Prime Numbers"
date =  2020-07-12T13:09:11+05:30
weight = 4
pre = "<b>3.</b> "
+++

### Properties, Conjectures and Theorems

**Definition:** A prime number is a number greater than 1 that has exactly two positive integer divisors, 1 and itself.

0. 1 is neither a prime, nor a composite.
1. 2 is the only even prime.
2. Only consecutive primes are 2 and 3.
3. Every prime number can represented in form of `6n±1` except 2 and 3, where _n_ is natural number.
4. There are infinitely many primes. **(Euclid's Theorem)**
5. [Prime Number Theorem](https://en.wikipedia.org/wiki/Prime_number_theorem) - The number of primes till _n_ are approximately equal to `n /ln (n)` when _n_ is large. Alternatively, the probability that a given, randomly chosen number _n_ is prime is inversely proportional to its number of digits, or to the logarithm of _n_.
6. [Goldbach's conjecture](https://en.wikipedia.org/wiki/Goldbach%27s_conjecture) - Every even integer greater than 2 can be expressed as the sum of two primes.
7. [Lemoine's conjecture](https://en.wikipedia.org/wiki/Lemoine%27s_conjecture) - Any odd integer greater than 5 can be expressed as a sum of an odd prime and an even semiprime.
8. [Legendre’s Conjecture](https://www.geeksforgeeks.org/legendres-conjecture/) - It says that there is always one prime number between any two consecutive natural number's (n = 1, 2, 3, 4, 5, …) square.
9. [Bertrand's postulate](https://www.geeksforgeeks.org/bertrands-postulate/) - Bertrand's postulate is a theorem stating that for any integer _n > 3_, there always exists at least one prime number _p_ with _n < p < 2n-2_.
10. GCD of 2 primes is always 1.
11. [Euclid's lemma](https://www.geeksforgeeks.org/euclids-lemma/) - If a prime _p_ divides _a * b_, then, _p_ divides at least one of _a_ and _b_. For example, _2|(6*9) => 2|6_. This may or may not be true for any non-prime instead of _p_.
12. [Hardy-Ramanujan Theorem](https://en.wikipedia.org/wiki/Hardy%E2%80%93Ramanujan_theorem) - The number of prime factors of _n_ will approximately be _log(log(n))_ for most natural numbers _n_.
13. [Rosser's Theorem](https://www.geeksforgeeks.org/rossers-theorem/) - The _n<sup>th</sup>_ prime number is greater than the product of _n_ and natural logarithm of _n_ for all _n_ greater than 1. Mathematically, For _n >= 1_, if _p_ is the _n<sup>th</sup>_ prime number, then `p > n * (ln n)`.
14. [Fermat's Little Theorem](https://www.geeksforgeeks.org/fermats-little-theorem/)
15. [Euclid Euler Theorem](https://www.geeksforgeeks.org/euclid-euler-theorem/)
16. [Ulam Spiral or Prime Spiral](https://www.geeksforgeeks.org/the-ulam-spiral/)

### Other interesting Numbers
0. **Co-Primes -** Two numbers, _a_ and _b_ are said to be co-prime iff _gcd(a,b) = 1_. Two conecutive numbers are always co-prime. Any prime number is co-prime with every other number.
1. **Twin Prime -** A twin prime is a prime number that is either 2 less or 2 more than another prime number—for example, either member of the twin prime pair (11, 13). In other words, a twin prime is a prime that has a prime gap of two.
2. **Prime Triplet -** Prime Triplet is a set of three prime numbers of the form _(p, p+2, p+6)_ or _(p, p+4, p+6)_.
3. **Semiprime -** A semiprime number is a natural number that is a product of two prime numbers. Semiprimes include the squares of prime numbers. Because there are infinitely many prime numbers, there are also infinitely many semiprimes. Ex - 4, 6, 9, 10, 14, 15...
4. **Mersenne Primes -** A Mersenne prime is a prime that can be expressed as _2<sup>p</sup>-1_, where _p_ is a prime number. They are extremely rare. Note that having the form of _2<sup>p</sup>-1_ does not guarantee that the number is prime. Ex - 2<sup>11</sup>-1 is not a prime. `The largest known prime is a Mersenne Prime discovered using Lucas-Lehmer Series`.
5. **Emirps -** An emirp (prime spelled backwards) is a prime number that results in a different prime when its decimal digits are reversed. This definition excludes the related palindromic primes. The term reversible prime may be used to mean the same as emirp, but may also, ambiguously, include the palindromic primes. Ex -  13, 17, 31, 37, 71, 73, 79, 97, 107, 113, ...
6. **Special Primes -** A prime number is said to be Special prime number if it can be expressed as the sum of three integer numbers: two neighboring prime numbers and 1. For example, 19 = 7 + 11 + 1, or 13 = 5 + 7 + 1. 
7. **Left and Right Truncatable Prime -** If we keep on removing a digit from left or right, the number still remains a prime. Ex - 317.
8. **Super Primes -** also known as _higher order primes_ are the subsequence of prime numbers that occupy prime-numbered positions within the sequence of all prime numbers. First few Super-Primes are 3, 5, 11 and 17. Since, 3 occupies the 2nd position and so on...
9. **Palindromic Primes -** sometimes called a _palprime_ is a prime number that is also a palindromic number. Ex - 2, 3, 5, 7, 11...
10. **Sophie Germain Prime -** A prime number p is called a sophie prime number if _2p+1_ is also a prime number. The number _2p+1_ is called a _safe prime_. For example 11 is a prime number and 11\*2 + 1 = 23 is also a prime number so, 11 is sophie germain prime number.
11. **Almost Prime -** A k-Almost Prime Number is a number having exactly k prime factors (not necessary distinct)
For example,
2, 3, 5, 7, 11 ….(in fact all prime numbers) are 1-Almost Prime Numbers as they have only 1 prime factors (which is themselves).
4, 6, 9…. are 2-Almost Prime Numbers as they have exactly 2 prime factors (4 = 2\*2, 6 = 2\*3, 9 = 3\*3) 
Similarly 32 is a 5-Almost Prime Number (32 = 2\*2\*2\*2\*2) and so is 72 (2\*2\*2\*3\*3).
12. **Pernicious Number -** A pernicious number is a positive integer which has prime number of ones in its binary representation. The first pernicious number is 3 since 3 = (0011)(in binary representation) and 1 + 1 = 2, which is a prime.

13. **Twisted Prime -** If a prime's reverse is also a prime number. Ex - 31 and 13.

14. **Balanced Prime -** If a prime is equal to the (sum of its neighbours) / 2. Ex - 5, 53, 157, 173, ...

15. **Sexy Prime -** In mathematics, Sexy Primes are prime numbers that differ from each other by six. For example, the numbers 5 and 11 are both sexy primes, because they differ by 6. For a prime p, if p + 2 or p + 4 (where p is the lower prime) is also prime.

16. **Pierpont Prime -** A Pierpont Prime is a prime number of the form *p = 2<sup>l</sup>.3<sup>k</sup> + 1* (having factors 2 and 3 only + 1). First few Pierpont prime numbers are 2, 3, 5, 7, 13, 17, 19, 37, 73, 97, 109, …

17. [**Newman–Shanks–Williams Prime**](https://www.geeksforgeeks.org/newman-shanks-williams-prime/)

18. **Fermat Numbers -** A number of the form _2<sup>x</sup> + 1_ (where x > 0) is prime if and only if x is a power of 2, i.e., x = 2<sup>n</sup>. So overall number becomes _2<sup>2<sup>n</sup></sup> + 1_. The first few Fermat numbers are 3, 5, 17, 257, 65537, 4294967297, ... An important thing to note is a number of this is not always prime.

19. **Circular Prime -** A prime number is a Circular Prime Number if all of its possible rotations are itself prime numbers.

20. **Permutable Prime -** A Permutable prime number is that number which after switching the position of digits through any permutation is also prime. Some of the permutable prime numbers are 2, 3, 5, 7, 11, etc.

### Primality Tests

#### 1. School Method
Uses the fact that a composite number must have atleast one _prime_ factor till _sqrt(n)_ (obviously).

Link: https://www.geeksforgeeks.org/primality-test-set-1-introduction-and-school-method/

`Time = O(√n)`
```cpp
//School Method. Time = O(sqrt(n))
bool isPrime(int n)
{
	if(n <= 1) return false;

	for(int i = 2; i*i <= n; i++)		//better than using sqrt()
	{
		if(n % i == 0) return false;
	}

	return true;
}
```

#### 1.1 Optimized School Method

`Time = O(√n)`

**Optimization:** We can check only odd numbers after 2 in the range 3 to sqrt(n).

```cpp
bool isPrime(int n) 
{ 
    // check if n is a multiple of 2 
    if (n % 2 == 0) 
        return false; 
  
    // if not, then just check the odds 
    for (int i = 3; i * i <= n; i += 2)  
        if (n % i == 0) 
            return false;     
    return true; 
} 
```

**Optimization:** We can check only numbers of the form _6k±1_ in the range 2 to sqrt(n).

```cpp
bool isPrimeOptimized(int n)
{
	if(n <= 1) return false;
	if(n <= 3) return true;

	//remove multiples of 2 and 3
	if(n % 2 == 0 || n % 3 == 0)
		return false;

	//from 5 check all multiples of the form 6k±1 (prime factors only)
	for (int i = 5; i*i <= n; i += 6)
	{
		if(n % i == 0 && n % (i+2) == 0)
			return false;
	}

	return true;
}
```

#### 2. Fermat's Method

Probabilistic test based on Fermat's Little Theorem. [Carmichael numbers](https://en.wikipedia.org/wiki/Carmichael_number) are composite numbers which fail this test. Carmichael numbers are also called _Fermat pseudoprimes_.

Link: https://www.geeksforgeeks.org/primality-test-set-2-fermet-method/


**If p is a prime number, then for every a, 1 < a < p-1,  
a<sup>p-1</sup> ≡ 1 (mod p)
 OR 
a<sup>p</sup>-1 % p = 1**


#### 3. Miller-Rabin Test
This method is a probabilistic method (Like Fermat), but it generally preferred over Fermat’s method.

Link: https://www.geeksforgeeks.org/primality-test-set-3-miller-rabin/

#### 4. Solovay-Strassen Test
Link: https://www.geeksforgeeks.org/primality-test-set-4-solovay-strassen/

#### 5. Lucas Primality Test
Link: https://www.geeksforgeeks.org/lucas-primality-test/

#### 6. Lucas-Lehmer Series
Link: https://www.geeksforgeeks.org/primality-test-set-5using-lucas-lehmer-series/

#### 7. AKS Primality Test
[Galactic Algorithm](https://en.wikipedia.org/wiki/Galactic_algorithm)

Link: https://www.geeksforgeeks.org/aks-primality-test/

#### 8. Wilson's Theorem
Link: https://www.geeksforgeeks.org/wilsons-theorem/
Link: https://www.geeksforgeeks.org/implementation-of-wilson-primality-test/

#### 9. Vantieghems Theorem for Primality Test
Checks primes only till 11.

Link: https://www.geeksforgeeks.org/vantieghems-theorem-primality-test/

#### 10. Lehmann's Primality Test
Link: https://www.geeksforgeeks.org/lehmanns-primality-test/

### Find all primes upto N (Sieves)

#### Sieve of Eratosthenes
`Time = O(n * log(log(n)))`

Complexity Analysis: https://www.geeksforgeeks.org/how-is-the-time-complexity-of-sieve-of-eratosthenes-is-nloglogn/

**Algorithm:** <br>
1. Create a list of numbers from 0 to n (size = n+1), and mark all as 1/true, mark 0 and 1 as 0 (they aren't prime) <br>
2. Start from 2 and, <br>
3. Check if 1, if it is then mark all its multiples from i\*i till n as 0 (because if we're at i, then every number till i\*i is already marked) <br>
4. Repeat this while i <= sqrt(n) (all numbers till `sqrt(n)*sqrt(n)` (n) will get marked)

```cpp
void primeSieve(int n)
{
	vector<int> s(n + 1, 1);		//seive size = n+1, default all to 1
	s[0] = s[1] = 0;

	for (int i = 2; i * i <= n; i++)
	{
		if (s[i] == 1)
			for (int j = i * i; j <= n; j += i)
				s[j] = 0;
	}

	for (int i = 0; i < s.size(); i++)		//display
		if (s[i] == 1)
			cout << i << " ";
}
```

Time Complexity: 
```
n * (1/2 + 1/3 + 1/5 + ... + 1/n)

=> n * (this is a Harmonic Progression) 

=> n * (log log n)
```
#### Sieve of Eratosthenes in 0(n) time complexity

Link: https://www.geeksforgeeks.org/sieve-eratosthenes-0n-time-complexity/

#### Sieve Of Sundaram
`Time = O(n log n)` (Slower than linear Eratosthenes)

**Algorithm:** <br>
SOS can find all primes upto _2\*n+2_ for a given _n_. <br>
1. Calculate _newN = (n-1)/2_, Make a sieve of size _nNew+1_ and mark all in sieve as _false_, <br>
2. Mark all numbers of the form _i + j + 2ij_ as _true_ where _1 <= i <= j_, <br>
3. Print 2,
4. Remaining primes are of the form _2i + 1_ where i is index of NOT (false) marked numbers. So print _2*i + 1_ for all _i_
   such that _sieve[i]_ is _false_. 

```cpp
bool sieveSundaram(int n)
{
	int nNew = (n - 1) / 2;

	bool s[nNew + 1];
	memset(s, false, sizeof(s));

	// Main logic of Sundaram.  Mark all numbers of the
	// form i + j + 2*i*j as true where 1 <= i <= j
	for (int i = 1; i <= nNew; i++)
		for (int j = i; (i + j + 2 * i * j) <= nNew; j++)
			s[i + j + 2 * i * j] = true;

	// Print 2
	if (n > 2)
		cout << 2 << " ";

	// Print other primes. Remaining primes are of the form
	// 2*i + 1 such that marked[i] is false.
	for (int i = 1; i <= nNew; i++)
		if (s[i] == false)
			cout << 2 * i + 1 << " ";

  return 0;
}

```

### Goldbach's Conjecture and Applications

```cpp
//Loop for checking and printing all prime sum pairs
for (int i = 2; i <= n/2; ++i)
	{
		if(isPrime(i) && isPrime(n - i))		// if(s[i] && s[n-i])
			{
				cout << i << ", " << (n - i);
			}
	}
```

#### Application
1. Express even number as sum of two primes (Direct application) <br>
2. [Express odd number as sum of atmost three primes](https://www.geeksforgeeks.org/express-odd-number-sum-prime-numbers/) <br>
3. [If N can be expressed as sum of four primes](https://www.geeksforgeeks.org/n-expressed-sum-4-prime-numbers/) <br>
4. [If N can be written as sum of K prime numbers](https://www.geeksforgeeks.org/check-number-can-written-sum-k-prime-numbers/)
### References
1. https://www.geeksforgeeks.org/mathematical-algorithms/mathematical-algorithms-prime-numbers-primality-tests/ <br>
2. https://procoderforu.com/prime-numbers
3. [Brilliant Wiki](https://brilliant.org/number-theory) <br>
	i. [Prime Numbers](https://brilliant.org/wiki/prime-numbers) <br>
	ii. [Infinitely Many Primes](https://brilliant.org/wiki/infinitely-many-primes/) <br>
	iii. [Distribution of Primes](https://brilliant.org/wiki/distribution-of-primes/) <br>
	iv. [Mersenne Prime](https://brilliant.org/wiki/mersenne-prime/)
4. [Theorems and Conjectures involving prime numbers](https://math.libretexts.org/Bookshelves/Combinatorics_and_Discrete_Mathematics/Book%3A_Elementary_Number_Theory_(Raji)/02%3A_Prime_Numbers/2.07%3A_Theorems_and_Conjectures_involving_prime_numbers)	