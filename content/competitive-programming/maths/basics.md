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
1. Calculate no. of prime factors
2. Calculate no. of even factors 
3. Calculate no. of odd factors
4. Sum of even factors
5. Sum of odd factors

### Euclid's Theorems

#### Theorem 1: Euclid's Division Lemma
According to Euclid's Division Lemma, `if we have two positive integers a and b, then there exist unique integers q and r which satisfies the condition a = bq + r where 0 ≤ r < b.` The basis of the Euclidean division algorithm is Euclid's division lemma.

#### Theorem 2: There are infinitely many primes


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


### Find the number of trailing zeroes in a number or a factorial