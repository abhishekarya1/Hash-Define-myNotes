+++
title = "Basics"
date =  2020-07-12T11:45:09+05:30
weight = 2
pre = "<b>0. </b>"
+++

#### One header to include every standard library

```cpp
#include<bits/stdc++.h>
```

- Also includes unnecessary stuff and increases length of code for compilation.
- Saves time during typing.
- Not portable as it's not part of the C++ standard. Available in GCC but not in all others.

#### Macros and typedef

```cpp
#define LL long long
#define ULL unsigned long long
#define LD long double

#define MOD 1e9+7
```
OR

```cpp
typedef long long LL;
typedef unsigned long long ULL;
typedef long double LD;
```

**Usage:**
```cpp
LL a = 123;
ULL b = 456;
LD = 4.6775;
```

#### Macro Functions and Raw Macros
```cpp
#define MAX(a,b) ((a)>(b)?(a):(b))
#define MIN(a,b) ((a)<(b)?(a):(b))
#define ABS(x) ((x)<0?-(x):(x))

#define si(n) scanf("%d",&n)
#define sf(n) scanf("%f",&n)
#define sl(n) scanf("%lld",&n)
#define slu(n) scanf("%llu",&n)
#define sd(n) scanf("%lf",&n)
#define ss(n) scanf("%s",n)

#define REP(i,n) for(int i=0;i<(n);i++)
#define FOR(i,a,b) for(int i=(a);i<(b);i++)
#define FORR(i,n) for(int i=(n);i>=0;i--)
```

#### Faster I/O

{{% notice note %}}
printf/scanf is _faster_ than cout/cin, but we can make cout/cin as faster by using below trick or simply use print/scanf in C++.
{{% /notice %}}

```cpp
ios_base::sync_with_stdio(false);
cin.tie(NULL);
```

OR

```cpp
ios::sync_with_stdio(0);
cin.tie(0);
```
{{% notice tip %}}
Note that the newline "\n" works faster than endl, because endl always causes
a flush operation.
{{% /notice %}}

**Explanation:** Every C++ standard stream is synced with the corresponding standard C stream before program starts. We can stop synchronization by passing argument to `ios::sync_with_stdio()` as `0` or `false`. The function `tie()` ensures flushing `cout` before every `cin` and we stop it by passing `0` or `NULL`.

#### Writing to Files

Just add the below lines at the beginning and proceed using standard I/O streams (`cin` and `cout`). 

```
freopen("input.txt", "r", stdin);
freopen("output.txt", "w", stdout);
```

#### Compiler Flags

```bash
g++ -std=c++11 -O2 -Wall test.cpp -o test
```

This command produces a binary file test from the source code `test.cpp`. The
compiler follows the C++11 standard (`-std=c++11`), optimizes the code (`-O2`),
and shows warnings about possible errors (`-Wall`)

#### memset()
- To set all values in a memory block to a specified value.
- Signature: `void * memset ( void * ptr, int value, size_t num );`

```cpp
#include <bits/stdc++.h>

#define FR(n) for(int i=0;i<n;i++)

using namespace std;

int main()
{
 
	int hash[26];

	memset(hash, 0, sizeof(hash));		//no need of for loop to set values

	FR(26) cout << hash[i] << " ";		//0 0 0 0 0 0 ... 26 times

    return 0;
}
```