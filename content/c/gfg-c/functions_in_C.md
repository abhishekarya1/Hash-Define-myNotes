+++
title = "Functions_in_C"
date =  2019-02-07T21:53:15+05:30
weight = 5
+++

### Calling functions before and after main() in GCC

```c
#include <stdio.h>

void my_start_func(void) __attribute__ ((constructor));
void my_exit_func(void) __attribute__ ((destructor));

void my_start_func(void) {printf("%s ", "Hello!");} 

void my_exit_func(void) {printf("%s", "Arya");}


int main(void) 
{ 

	printf("%s ", "Abhishek");
	return 0; 
} 

// OUTPUT - Hello! Abhishek Arya
```

## Return type of any function used before declaration is assumed to be `int` and if **it is** `int` then the compilations is successful, else there is a type mismatch error
, compilation fails. Also, is we do not mention the return type, it is assumed implicitly to be `int`.