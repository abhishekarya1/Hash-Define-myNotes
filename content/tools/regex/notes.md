+++
title = "Notes"
date =  2021-05-01T00:24:54+05:30
weight = 2
+++

Regex pronunciation: *"Redj-ex"*

## Regex in programming languages

C++11 onwards (`<regex>` header), Python, Java, Javascript, PHP, Java, etc...

#### C++ 

Regex is written in the form of a string inside double-quotes (`""`)

```cpp
regex foo("Geek[a-zA-Z]+"); //foo is the object of regex 
```
#### Javascript & Ruby

Regex is written within forward slashes (`/regex/`)

```js
var str = 'cat';
if (str.match(/a/)) {
  console.log("matched 'a'");
}

if (str.match(/x/)) {
  console.log("matched 'x'");
}
```

#### Python
```py
import re

txt = "The rain in Spain"
x = re.search("^The.*Spain$", txt)
```

---
### Basic Match
[Ex#0](https://www.regexpal.com/?fam=116958)

---
### Meta Characters
Reserved chars. Use `\` to escape. Ex - `.`, `[]`, etc...

### Escaping Meta Characters
Prepend a metacharacter with a backslash `\` to use it as a matching char. Ex: `^\^exponent`

---
### Dot `.`
Matches a single character only (except newline char `\n`)

[Ex#0](https://www.regexpal.com/?fam=116959)
[Ex#1](https://regexr.com/5u7bq)

--- 
### Character Set
aka Character Class. They work character-by-character i.e. `[ctpj]ar` is same as `[c|t|p|j]ar`.
Specified inside square brackets `[]`
  - No Space : [Ex#0](https://www.regexpal.com/?fam=116961)
  - Hyphen (Ranged) : [Ex#1](https://www.regexpal.com/?fam=116971)
  - Both of the above : [Ex#2](https://www.regexpal.com/?fam=116994)
  
A dot `.` inside a Char class means a literal dot `.`
  - [Ex#0](https://www.regexpal.com/?fam=116963)
  - [Ex#1](https://www.regexpal.com/?fam=116964)
    
#### Negated Character Set
Any char/charset written within `[]` and preceded by `^` will be negated.
  - `[^c]ar` : [Ex#0](https://www.regexpal.com/?fam=116965)
  - `[^ctpj]` : [Ex#1](https://www.regexpal.com/?fam=116995)

---
### Quantifiers

#### Repetitions
Symbols `*`, `+`, and `?`
  - Asterisk `*` : No. of occurances of char/charset preceding it must be >=0 
    - On single char : [Ex#0](https://www.regexpal.com/?fam=116967)
    - On charset : [Ex#1](https://www.regexpal.com/?fam=116968)
    
  - Plus `+` : No. of occurances of char/charset preceding it must be >=1
    - On single char : [Ex#0](https://www.regexpal.com/?fam=116969)
    - On charset : [Ex#1](https://www.regexpal.com/?fam=116970)
    
  - Question Mark `?` (strictly zero or one)
    - Makes the preceding character optional. It matches zero or one instance of the preceding character. If character is there, it matches whole word, if not, then it matches remainning word other than optional char.
    - [Ex#0](https://www.regexpal.com/?fam=116974)

#### Specifying Ranges 
aka "Quantifiers", written only post char/charset.
Can be applied to both Char and Charset
Usage Styles : `{n1,n2}`, `{n1,}`, `{n}`

---
### Capturing Groups
Uses `()` to create a group and capture the match. Ex - `(ab)*`

Can use altenations inside of it as `(c|r|m|e|f)at`: [Ex#0](https://www.regexpal.com/?fam=116976)

Grouping and applying quantifiers is also possible: [Ex#1](https://www.regexpal.com/?fam=116997)

### Non-Capturing Groups
Uses `?` followed by a `:` within `()` to create a group but not capture the match. Ex - `(?:c|r|m|e|f)at`

---
### Alternation `|`
Works like logical OR operator.

Question: Isn't `[Tt]he` same as `(T|t)he`?
  
Ans: In the above case it's the same. But, alternations work at expression level and charset at char level only.
We can alter between expressions (multiple-chars/string) using `|` as `abhi(shek|manyu)` but not as `abhi[shekmanyu]`.

---
### Anchors
Caret `^` and Dollar `$`
- Caret `^` used to specify start position of the input string. It does not matches the character but position at the start of the input. Ex - String input that starts with T is matched by `^T`
- Dollar `$` used to specify used to specify start position of the input string. It does not matches the character but position at the end of the input. Ex - String that ends with e is matched by `e$`
- `\b` and `\B` are non-character consuming anchors too.

---
### Shorthand Character Sets
|Shorthand|Description|
|:----:|----|
|.|Any character except new line|
|\w|Matches alphanumeric characters: `[a-zA-Z0-9_]`|
|\W|Matches non-alphanumeric characters: `[^\w]`|
|\d|Matches digits: `[0-9]`|
|\D|Matches non-digits: `[^\d]`|
|\s|Matches whitespace characters: `[\t\n\f\r\p{Z}]`|
|\S|Matches non-whitespace characters: `[^\s]`|

---
### Word Boundaries
Denoted by `\b`, in most regex dialects, is a position between \w and \W (non-word char), or at the beginning or end of a string if it begins or ends (respectively) with a word character (`[0-9A-Za-z_]`). So, in the string "-12" , it would match before the 1 or after the 2. The dash is not a word character.
[Ex#0](https://regex101.com/r/5zYI7K/1)

Note that `^` and `$` are also word boundries as start and end of input respectively.
Also note that `\b`and `\B` matches without consuming any char.


**Non-Word Boundry:**: Matches, without consuming any characters, at the position between two characters matched by `\w`.
[Ex#1](https://regex101.com/r/NtXJY8/1)

---
### Backreferences
When we make a capture group, regex engine references the result implicitly in a first occurance order and we can use that reference with `\ref_num` to use it again. 
[Ex#0](https://www.regexpal.com/?fam=116999)

Note that capturing is neccessary for backreferening to happen and work.
Also note that backreferences match the **same text** as most recently matched by the capturing group they reference (i.e. its resultant match `33`) and not just the _group pattern_ `\d\d`.
[Ex#1](https://regex101.com/r/iMkVk7/1)

**Backreferences to failed groups:** Concept and important distinction [here](https://www.hackerrank.com/challenges/backreferences-to-failed-groups/problem). First Ex is "b participated but failed, the result was then captured using `()`", second Ex is "never participated at all" since the entire group was optional, it skipped checking match for `(b)` group altogether. 

TL;DR - We can make a capture group optional using ? and any backreference to it won't match if capture group doesn't match anything.

---
### Branch Reset Groups*

*Branch reset group is supported by Perl, PHP, Delphi and R*


**Syntax:**`(?|(regex1)|(regex2)|(regex3)|.....)`


**Explanation:** It allows us to branch/choose from among `regex1`, `regex2`, `regex3` capture groups, any one, capture the result one time and reference it later on. Note that the `(?|regex)` itself counts as one occurance of the chosen matched single capture group.

[Ex#0](https://www.hackerrank.com/challenges/branch-reset-groups/problem)

---
### Forward References*
*Forward reference is supported by JGsoft, .NET, Java, Perl, PCRE, PHP, Delphi and Ruby*


**Explanation:** It allow you to use a backreference to a group that appears later in the regex. Forward references are obviously only useful if they’re inside a repeated group.
[Ex#0](https://www.regular-expressions.info/backref2.html#forward)
[Ex#1](https://www.hackerrank.com/challenges/forward-references/problem)

---
### Lookarounds
Also called "Assertions".

Two types: **Lookaheads** and **Lookbehinds**.

They do not capture the lookaround symbol that is being checked (character inside `()`).

|Symbol|Name|Description|
|:----:|----|----|
|(?= )|Positive Lookahead|Used on RHS of main regex|
|(?! )|Negative Lookahead|"|
|(?<= )|Positive Lookbehind|Used on LHS of main regex|
|(?<! )|Negative Lookbehind|"|

[Ex#0](https://regexr.com/5u7iu)

---
### Flags
Also known as "Modifiers".
Heavily dependent on regex engine being used.

|Flag|Description|
|:----:|----|
|i|Case insensitive: Match will be case-insensitive.|
|g|Global Search: Match all instances, not just the first.|
|m|Multiline: Anchor meta characters work on each line. By default, the `$` is at the end of the whole input, but `m` flag forces it at every line end|

We can use them together: `/^regex$/gm`

---
### Greedy vs Lazy Matching
Use `?` with any of the six quantifiers to match in a lazy way.

'Greedy' means match longest possible string. 

'Lazy' means match shortest possible string.l

For example, the greedy `h.+l` matches 'hell' in 'hello' but the lazy `h.+?l` matches 'hel'.


Good explaination taken from [here](https://javascript.info/regexp-greedy-and-lazy).

Good Example [here](https://stackoverflow.com/questions/2301285/what-do-lazy-and-greedy-mean-in-the-context-of-regular-expressions).
