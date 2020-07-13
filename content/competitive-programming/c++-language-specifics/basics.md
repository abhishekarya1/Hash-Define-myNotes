+++
title = "Headers, Macros, and Compiler Flags"
date =  2020-07-12T11:45:09+05:30
weight = 1
pre = "<b>0. </b>"
+++

### One header to include every standard library

```cpp
#include<bits/stdc++.h>
```

- Also includes unnecessary stuff and increases length of code for compilation.
- Saves time during typing.
- Not portable as it's not part of the C++ standard. Available in GCC but not in all others.

### Macros and typedef

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

### Macro Functions and Raw Macros
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

### Compiler Flags

```bash
g++ -std=c++11 -O2 -Wall test.cpp -o test
```

This command produces a binary file test from the source code `test.cpp`. The
compiler follows the C++11 standard (`-std=c++11`), optimizes the code (`-O2`),
and shows warnings about possible errors (`-Wall`)

