+++
title = "GCD and LCM Advanced"
date =  2020-07-13T20:56:22+05:30
weight = 3 
pre = "<b>2.</b> "
+++

### GCD and LCM follow Distributive Property

```
gcd(a, lcm(b, c)) = lcm(gcd(a, b), gcd(a, c)) 

lcm(a, gcd(b, c)) = gcd(lcm(a, b), lcm(a, c)).
```

### GCD is distributive with other functions too
We can have out own function *f(n)* and *gcd* will be distributive over it and vice-versa.
```
gcd(f(n, x), f(n ,y)) = f(n, gcd(x, y))
f(gcd(n, x), gcd(n ,y)) = gcd(n, f(x, y))
```
Problem Link: https://www.geeksforgeeks.org/gcd-two-numbers-formed-n-repeating-x-y-times/ 

### Stein's Algorithm

`Time = O(n*n), where n is the number of bits in the larger of the two numbers.`

Also called **Binary GCD algorithm**, is used to find gcd based on Euclidean Algorithm in an optimizaed way by avoiding any arithmetical operations and with just bitwise operations.

Link: https://www.geeksforgeeks.org/steins-algorithm-for-finding-gcd/ <br>
Code: https://github.com/abhishekarya1/GfG-Codes/blob/master/Mathematical/GCD%20and%20LCM/gcd_steins_algo.cc

### 