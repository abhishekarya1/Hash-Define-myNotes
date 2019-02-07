+++
title = "Structure Alignment, Padding and Packing"
date =  2019-02-05T22:53:25+05:30
weight = 4
+++

### Structure Alignment, Padding, and Packing

Link: https://www.geeksforgeeks.org/structure-member-alignment-padding-and-data-packing/

### How to avoid Structure Padding in C?

- Using `#pragma pack(1)` idrective to force 1 Byte alignment
- We can also use the following (1 Byte alignment):

```c
struct s { 
    int i; 
    char ch; 
    double d; 
} __attribute__((packed));
```
Link: https://www.geeksforgeeks.org/how-to-avoid-structure-padding-in-c/