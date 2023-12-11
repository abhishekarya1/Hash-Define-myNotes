+++
title = "Basics"
date =  2020-07-12T13:09:11+05:30
weight = 1
pre = "<b>0.</b> "
+++

### Peano Axioms
Link: https://en.wikipedia.org/wiki/Peano_axioms

### Fundamental Theorem Of Arithmetic
The fundamental theorem of arithmetic (FTA), also called *the unique factorization theorem*, states that `every integer greater than 1 either is prime itself or is the product of a unique combination of prime numbers`.

**1 is not considered prime because we lose uniqueness in factorization if we consider it a prime:**
```
25 = 5 * 5 * 1
   = 5 * 5 * 1 * 1
   = 5 * 5 * 1 * 1 * 1
   ... no unique factorization
```

#### Uses
We can easily calculate:
1. No. of divisors
2. No. of prime factors
3. No. of even factors 
4. No. of odd factors
5. Sum of even factors
6. Sum of odd factors

### Euclid's Theorems

#### Theorem 1: Euclid's Division Lemma
According to Euclid's Division Lemma, `if we have two positive integers a and b, then there exist unique integers q and r which satisfies the condition a = bq + r where 0 ≤ r < b.` The basis of the Euclidean division algorithm is Euclid's division lemma.

#### Theorem 2: There are infinitely many primes

Proof: https://primes.utm.edu/notes/proofs/infinite/euclids.html

### Odd & Even Numbers
- Even numbers are of the form `2k`, and odd numbers are of the form `2k+1` for k = 0, 1, 2, 3...
- Even numbers are also called `Parity 0` integers and odd numbers are called `Parity 1` integers. 

```cpp
if(n % 2 == 0) cout << "Even";
else cout << "Odd";
```

**Efficient Way:**

```cpp
if(n & 1) cout << "Odd";
if(~ n & 1) cout << "Even";     //else
```

### Big Integers

{{% notice note %}}
Numbers larger than `long long` type can be stored and operated upon in an array or a vector.
{{% /notice %}}

##### Problem: Factorial of Large Numbers
Editorial Link: https://www.geeksforgeeks.org/factorial-large-number/

**Array Implementation:**

```cpp
//Execution Time: 0.22 sec

#include<iostream>

#define MAX 10000

using namespace std;

void factorial(int);
int multiply(int, int*, int);

void factorial(int n)
{
    int res[MAX];

    res[0] = 1;
    int res_size = 1;

    for (int i = 2; i <= n; i++)        //normal factorial formula => 1 * 2 * 3 ... n-1 * n
    {
        res_size = multiply(i, res, res_size);
    }

    for (int i = res_size - 1; i >= 0; i--) //result stored in res in reverse O(1) because inserting in beginning is O(n)
        cout << res[i];
}

int multiply(int x, int* res, int res_size)
{
    int carry = 0;
    for (int i = 0; i < res_size; i++)
    {
        int prod = res[i] * x + carry;
        res[i] = prod % 10;
        carry = prod / 10;
    }

    while (carry)       //if there is a carry left after our res multiplication is finished
    {
        res[res_size] = carry % 10;     //set the carry as last digits of res
        carry /= 10;
        res_size++;         //and update the res_size
    }

    return res_size;
}

int main()
{
    int n;
    cin >> n;

    factorial(n);

    return 0;
}
```

**Vector Implementation:**

```cpp
//Execution Time: 0.49 sec

#include<iostream>
#include<vector>

using namespace std;

int main()
{
    ios::sync_with_stdio(0);
    cin.tie(0);

    int n;
    cin >> n;

    vector<int> res;
    res.push_back(1);

    for (int i = 2; i <= n; i++)    //normal factorial formula
    {
        int carry = 0;
        int prod = 0;

        for (int j = 0; j < res.size(); j++)    //multiplying by individual digits
        {
            prod = res[j] * i + carry;
            res[j] = prod % 10;
            carry = prod / 10;
        }

        while (carry)       //take care of remaining carry
        {
            res.push_back(carry % 10);
            carry /= 10;
        }
    }

    for (int i = res.size() - 1; i >= 0; i--) cout << res[i];   //displaying in reverse, our number stored in vector res

    cout << "\n";
}

return 0;
```


### Binary Exponentiation
`Time = O(log n)`

_a^n_ implies that we have to multiply _a_, exactly _n-1_ times with itself to evaluate it. Ex - _2^3_ = _2_ * _2_ * _2_.

We can do this with only order of _log n_ multiplications by using binary representation of _n_ as -
```
3^13 = 3^(1101) = 3^8 * 3^4 * 3^1
```

Since the binary representation of _n_ has _floor(log n) + 1_ bits, hence O(_log n_) time.

**Iterative**:
```cpp
long binpow(long a, long b) {
    long res = 1;
    while (b > 0) {
        if (b & 1) {
            res = res * a;      //on set bit, multiply by power of a
        }
        a = a * a;              //do a^2 for each bit
        b >>= 1;                //shift to read next bit
    }

    return res;
}
```

**Halving power each time and then squaring:**
```cpp
long binpow(long a, long b)
{
	if(b == 0) return 1;

	long half = binpow(a, b/2);

	if(b&1)
		return half * half * a;
	else
		return half * half;
}
```

**Squaring and then halving:** (tail recursive)
```cpp
long binpow(long a, long b)
{
	if(b == 0) return 1;

	long sq = a * a;

	if(b&1)
		return a * binpow(sq, b/2);
	else 
		return binpow(sq, b/2);
}
```

**For negative _b_ and floating point _a_:**

```cpp
float binpow(long a, long b)		//float
{
	if(b == 0) return 1;

	float half = binpow(a, b/2);		//float

	if(b % 2 == 0) 
		return half * half;
	else 
	{
		if(b > 0) return a * half * half;
		else
			return (half * half) / a;		//this 
	}
}
```

#### Calculating big exponential mods (a^b mod m)
Mod every multiplication operation in iterative impl.

```cpp
//Iterative exponent mod (faster and efficient)
long binpow(long a, long b, long m) {
    a %= m;
    long res = 1;
    while (b > 0) {
        if (b & 1)
            res = (res * a) % m;
        a = (a * a) % m;
        b >>= 1;
    }
    return res;
}
```