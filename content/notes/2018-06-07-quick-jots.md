---
title: Quick Jots
date: 2018-06-07
---

- The most significant dimension of an array is optional while defining a function with array as an argument. 

```
int example(int arr[][3][3], int n) { }		// Function Definition
```
- Short-circuit Evaluation 

```
while(i < len && arr[i] == 100)		// if first condition is false, second is never evaluated

while(i < len || arr[i] == 100)		// if first condition is true, second is never evaluated
```

```
while(i < len && arr[i] == 100)
while(arr[i] == 100 && i < len)     // both these statements are not equivalent as second returns a segmentation fault, because the first is evaluated first		
```

