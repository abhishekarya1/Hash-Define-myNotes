+++
title = "Prime Numbers"
date =  2020-07-12T13:09:11+05:30
weight = 4
pre = "<b>3.</b> "
+++

### Properties

**Definition:** A prime number is a number greater than 1 that has exactly two positive integer divisors, 1 and itself.

0. 1 is neither a prime, nor a composite.
1. 2 is the only even prime.
2. Only consecutive primes are 2 and 3.
3. Every prime number can represented in form of `6n±1` except 2 and 3, where _n_ is natural number.
4. There are infinitely many primes.
5. [Prime Number Theorem -](https://en.wikipedia.org/wiki/Prime_number_theorem) The number of primes till _n_ are approximately equal to `n /ln (n)` when _n_ is large. Alternatively, the probability that a given, randomly chosen number _n_ is prime is inversely proportional to its number of digits, or to the logarithm of _n_.
6. [Goldbach's conjecture -](https://en.wikipedia.org/wiki/Goldbach%27s_conjecture) Every even integer greater than 2 can be expressed as the sum of two primes.
7. [Lemoine's conjecture -](https://en.wikipedia.org/wiki/Lemoine%27s_conjecture#:~:text=In%20number%20theory%2C%20Lemoine's%20conjecture,number%20and%20an%20even%20semiprime.) Any odd integer greater than 5 can be expressed as a sum of an odd prime and an even semiprime.
8. [Bertrand's postulate -](https://en.wikipedia.org/wiki/Bertrand%27s_postulate) Bertrand's postulate is a theorem stating that for any integer _n > 3_, there always exists at least one prime number _p_ with _n < p < 2n-2_.
9. **Twin Prime -** A twin prime is a prime number that is either 2 less or 2 more than another prime number—for example, either member of the twin prime pair (11, 13). In other words, a twin prime is a prime that has a prime gap of two.
10. **Semiprime -** A semiprime number is a natural number that is a product of two prime numbers. Semiprimes include the squares of prime numbers. Because there are infinitely many prime numbers, there are also infinitely many semiprimes. Ex - 4, 6, 9, 10, 14, 15...
11. GCD of 2 primes is always 1.
12. Euclid's lemma - If a prime _p_ divides _a * b_, then, _p_ divides at least one of _a_ and _b_. For example, _2|(6*9) => 2|6_.
13. **Mersenne Primes -** A Mersenne prime is a prime that can be expressed as _2<sup>p</sup>-1_, where _p_ is a prime number. They are extremely rare. Note that having the form of _2<sup>p</sup>-1_ does not guarantee that the number is prime. Ex - 2<sup>11</sup>-1 is not a prime.

14. **Emirps -** An emirp (prime spelled backwards) is a prime number that results in a different prime when its decimal digits are reversed. This definition excludes the related palindromic primes. The term reversible prime may be used to mean the same as emirp, but may also, ambiguously, include the palindromic primes. Ex -  13, 17, 31, 37, 71, 73, 79, 97, 107, 113, ...

### Primality Tests

#### 1. School Method

Link: https://www.geeksforgeeks.org/primality-test-set-1-introduction-and-school-method/

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
Link: https://www.geeksforgeeks.org/aks-primality-test/

#### 8. Wilson's Theorem
Link: https://www.geeksforgeeks.org/wilsons-theorem/
Link: https://www.geeksforgeeks.org/implementation-of-wilson-primality-test/

#### 9. Vantieghems Theorem for Primality Test
Link: https://www.geeksforgeeks.org/vantieghems-theorem-primality-test/

#### 10. Lehmann's Primality Test
Link: https://www.geeksforgeeks.org/lehmanns-primality-test/

### Find all primes upto N (Sieves)

```cpp
void seivePrime(int n)
{	
	vector<int> s(n, 0);
	for(int i = 0;i < s.size(); i++)
	{
		if(s[i])
	}
}
```

### References
1. https://www.geeksforgeeks.org/prime-numbers <br>
2. https://procoderforu.com/prime-numbers
3. [Brilliant Wiki](https://brilliant.org/number-theory) <br>
	i. [Prime Numbers](https://brilliant.org/wiki/prime-numbers) <br>
	ii. [Infinitely Many Primes](https://brilliant.org/wiki/infinitely-many-primes/) <br>
	iii. [Distribution of Primes](https://brilliant.org/wiki/distribution-of-primes/) <br>
	iv. [Mersenne Prime](https://brilliant.org/wiki/mersenne-prime/)
4. [Theorems and Conjectures involving prime numbers](https://math.libretexts.org/Bookshelves/Combinatorics_and_Discrete_Mathematics/Book%3A_Elementary_Number_Theory_(Raji)/02%3A_Prime_Numbers/2.07%3A_Theorems_and_Conjectures_involving_prime_numbers)	