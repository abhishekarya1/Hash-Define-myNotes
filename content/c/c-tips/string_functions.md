+++
title = "Character and String Functions"
date =  2019-02-04T16:33:46+05:30
weight = 3
+++

### Some Character Functions from `<ctype.h>`

Mostly, internally, the ASCII value of the character is passed as argument and returns `int` other than zero if true, else return 0.

- isprint() - Printable character is not a control character, they can be seen on screen
- iscntrl() - Control character like '\n' and '\r'
- islower() - Check lower-case
- isupper() - Check uper-case
- isgraph() - Graphic character other than space
- ispunct() - Punctuation character
- isdigit() - Numeric character
- isalpha() - Alphabet character

- toupper() - Converts character to upper case
- tolower() - Converts character to upper case

### `<math.h>` Library Fucntions
Link: https://www.geeksforgeeks.org/c-library-math-h-functions/

### Some misc functions
- rand() and srand() - <stdlib.h>
- time() and difftime() - <time.h>

### Some String Function - `<string.h>`
- strcat() - Concatenate
- strlen() - Length
- strcmp(left, right) - Compare and return +ve value if character at left string is greater in ASCII value than character in right string, else -ve if otherwise.
- strdup() - Duplicate
- strndup() - Duplicate till n<sup>th</sup> position
- strrev() - Reverse
- strcpy() - Copy
- strspn() - https://www.geeksforgeeks.org/strspn-function-c/