+++
title = "Google Dorking"
date = 2021-12-10T12:45:42+05:30
weight = 1
+++

```md
> Exact Match
"lorem ipsum"

> Exclude
searchtext -texttoexclude

> site:url
site:url searchtext
> inurl:url
> intitle:text
> intext:text

> Before..After and Range
Before: 2020
After: 2015

2015..2020
$10..$50

> Logic and Group
A | B
A OR B
A(B|C)
Example - java(cofee|script)

> Wildcard (\*)
How to build * with python
site:*.github.io -www

> filetype: format

> related:url

> link:url
Returns a list of pages linking to the specified UR, works with links deep within any directory too

> cache:url
Displays information about the url if cached by Google
```
### References
- Fireship - How to "Google It" like a Senior Software Engineer - [YouTube](https://youtu.be/cEBkvm0-rg0)
- Google Hacking - [Wikipedia](https://en.wikipedia.org/wiki/Google_hacking)
- Google Hacking Database (GHDB) - [Exploit-DB](https://www.exploit-db.com/google-hacking-database)
- Google Hacking 101- [PDF](https://www.oakton.edu/user/2/rjtaylor/cis101/Google%20Hacking%20101.pdf)