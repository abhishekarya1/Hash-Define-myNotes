---
title: Bitwise Operations and Recursion
date: 2018-06-10
---
### BITWISE Operator
	>> Right Shift Operator - results in 2^(number of times shifted)
	<< Left Shift Operator
- Bitwise AND (&) yields an integer value.
- Bitwise OR (|) yields an integer value.
- Bitwise XOR (^) yields either 0 or 1.
- To identify if the last bit is SET(=1), AND(&) the number with 1.

### Recursion
```
int factorial(int n){
	if(n==0)							// Base Case
	{
		return 1;
	}
	int smallFact = factorial(n-1);		// Recurrence Relation
	Fact = smallFact * n;
	return Fact;
}
```
