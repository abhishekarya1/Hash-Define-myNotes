+++
title = "Useful Functions"
date =  2020-07-13T20:16:51+05:30
weight = 2
pre = "<b>1. </b>"

+++

### Faster I/O

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

### Writing to Files

Just add the below lines at the beginning and proceed using standard I/O streams (`cin` and `cout`). 

```
freopen("input.txt", "r", stdin);
freopen("output.txt", "w", stdout);
```


### memset()
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

### GCD
`__gcd(a, b)` in `<algorithms>`

### LCM
Since C++17, `std::lcm(a, b)` 