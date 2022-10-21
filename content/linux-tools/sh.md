+++
title = "Shell Scripting"
date =  2021-05-01T00:31:34+05:30
weight = 2
pre = "<i class='devicon-bash-plain'></i> "
+++


### Basics
**#!** (sha-bang) (points to executable that runs the script)
```sh
#!/bin/sh
#!/bin/bash
#!/usr/bin/python3
```

**Comments**
```sh
# this is a comment
````

**Executing** remember to give executable permission (`x`)
```txt
$ ./test.sh         executes; but doesn't export variables to environment
 
$ bash test.sh      no need of +x permission; doesn't export variables to environment
$ sh test.sh        same as above (but uses "sh" as shell)

$ source test.sh    executes and exports variables to environment
$ . test.sh         dot (.) is just a shorthand for the "source" command
```

**Quotes and Backslash**: 
- _Double-quotes_: allows some special chars (`${}`, `$()`) inside; wildcards not allowed
- _Single-quotes_: ignores **all** special chars inside it; everything is printed literally
- _Backslash_: escape seq, and names containing spaces (`My\ Documents`)

### Variables
Case-sensitive, no special characters except underscore (`_`)

**Creation**:
```sh
#!/bin/sh
echo $name              # nothing printed, by default -> empty var 
name=John               # assignment
echo Hello $name!       # usage

readonly age=55         # a constant
unset name              # reset variable's value to empty

# empty vars
foo=
bar=""
```

Spaces between operands and operators are not at all valid:
```sh
name = John     # error; command "name" not found 

name=John       # valid
```

**Usage**:

1. `$VAR_NAME` : A `$` prefix is required only when using the variable; not during assignment

2. Using `${}` to use variable value:
```sh
REALM=Ana
echo "You're in ${REALM}heim"
```
3. _Default value_ (`:=`): a default value can be set if variable is empty at the time of usage
```sh
echo ${NAME:="John"}
```
4. _Existence check_ (`:?`): stops execution if variable is empty
```sh
${varName:?Error varName is not defined}  
```
**Scopes**: Environment (all currently running child terminals can access them; session-scope) and Local (function only)
```sh
export myvar="foobar"    # "exporting" variable myvar to environment

. test.sh                # "sourcing" the script's variables to environment
```

### User Input
**Interactive**
```sh
read username

# a prompt and variable input in the same line
read -p 'Enter username: ' name

# secret; don't show input in terminal output
read -s -p 'Enter password: ' password

# read array; space separated array input (by default)
read -a names
echo ${names[0]} ${names[1]}    # usage
```
**Command-line arguments**
```txt
$0          script name
$1 ... $n   command line args

$#          number of cmd line args the scipt is called with
$*          wrap all args in a single double-quotes
$@          wrap individual args in double-quotes separately

$$          current PID
$?          exit status of prev command, 0 = success, 1 = failure
```

### Executing commands inline
Use either backticks (\`\`) or `$()`

```sh
echo "Today's date is `date`"

echo "Today's date is $(date)"

# Both of the above lines print: Date is Tue Oct  4 01:53:55 IST 2022
```

### Printing and Sleeping
```txt
echo -e 'foo\nbar'       allow escape characters inside, in any quotes
echo *                   wildcard; lists directory contents (like `ls`)
echo *.png               list all .png files in pwd
  
printf "Marks: %d" $num     just like in C lang
```
```sh
# sleep for 30 sec
sleep 30s

#sleep for half-a-minute
sleep 0.5m

# sleep for 1 hour
sleep 1h
```

### Operators
Arithmetic: `+` `-` `*` `/` `%` `**`

`$(( expression ))` is used for arithmetic evaluation followed by sustitution (in-place of `expression`).

{{% notice note %}}
`$(( expression ))`: Evaluates the expression. Return value is the value of expression after evaluation.

`(( expression ))`: This too evaluates the expression in the same way as above. But, if the value of the expression is non-zero, the return value is `0`; otherwise the return value is `1` (yes, this if flipped than in C! value `0` fed to `if` will execute its clause). So, this is often used with conditionals like `if`, `else` etc...
{{% /notice %}}

```sh
echo 3+4                         # there are no types in BASH, only String (prints "3+4")

echo $(( 2 + 3 ))                # spaces doesn't matter here
echo $(( $num1 + $num2 ))        # usage with vars

expr 2 + 3              # spaces matters here (prints "2+3", if no spaces)
expr $num1 + $num2      # with vars

expr 4 \* 5            # need to escape * with expr or syntax error! (weird)
````
**Unary Operators**: `++` `--` (_post_ and _pre_)
```sh
i=0
while [ $i -lt 10 ] 
do
echo $i
((i++))     # notice
done
```

**Relational**:
```sh
ans=$(( 5 < 29 ))
echo $ans

# prints "1" (non-zero means True)
```
For evaluating to a boolean, use `[]` and below forms of the relational operators:

```txt
-gt     greater than
-lt     less than
-e      equal to (==)
-ne     not equal to (!=)
-le     less than or equal to
-ge     greater than or equal to

Usage (all spaces matter): [ $n1 -gt $n2 ]
```

{{% notice note %}}
As a rule of thumb, always use `<` symbols inside `(( condition ))` and `-lt` forms inside `[ condition ]`.

Sometimes we also use `[[ condition ]]` (_newer_) (like with an `if` clause). The advantage being that both `-lt` forms as well as the `<` symbols work inside it.

`[[ ]]` is more safer to use (no glob expansion), but the trade-off is backwards compatibility as it is much newer.
{{% /notice %}}

_Reference_: http://mywiki.wooledge.org/BashFAQ/031

**Logical**:
```txt
&& -a     AND operator
|| -o     OR operator
!         NOT operator

Usages: [[ && ]]
        [ -a ]
        [] && []
``` 

```sh
# Examples
if [ $a -lt 100 -o $b -gt 100 ]
```

**String operators**:
```txt
[ $a = $b ]         true if equal
[ -z $b ]           true if length is zero ("")
[ $a ]              true if not empty variable
< > != ==           compare strings with relational operators
```

{{% notice note %}}
With Strings, Use `<` symbols inside `[[ condition ]]`. The `(( condition ))` operator doesn't work with Strings.
{{% /notice %}}


**File tests**:
```txt
file="my.txt"       file names can be kept as Strings; context will be inferred upon usage with file test operators

[ -d $file ]        true if directory
[ -f $file ]        true if file

[ -r $file ]        true if readable
[ -w $file ]        true if writable
[ -x $file ]        true if executable

[ -e $file ]        true if exists
```

### Decision Making

All test operators `[ ]`, `[[ ]]` or `(( ))` convert a non-zero value inside them to a return value of `0`, and the `if` clause is executed in that case. So, if an `if` clause have a non-zero value, it is executed, otherwise `else`.

**if-then-elif-then-else-fi**
```sh
if [ ... ]
then
	#body
else
fi

# alt syntax #1
if (( ... ))
then
    #body
else     
fi

# alt syntax #2
if [[ ... ]]
then
    #body
else     
fi
```

```sh
if [ ... ]; then	#if and then needs to be on different lines or use ";"
elif
then
else    #if both the above "ifs" fail
fi
```

**CASE Statements**:

```sh
fruit="kiwi"  

case  $fruit  in  
"apple")	echo "Apple pie is quite tasty."  
;;  
"banana")	echo "I like banana nut bread."  
;;  
"kiwi")		echo "New Zealand is famous for kiwi."  
;; 
*)			echo "Default Case."
;; 
esac
```

### Arrays
Zero-indexed, one-dimensional arrays. No index bound checks.
```sh
arr=("apple" "ball" "cat" "dog")       # create, notice no commas ","

arr[1]=bear             # modify an element

echo ${arr[3]}          # access an element

unset arr[1]            # remove an element (make it empty value)

echo ${arr[*]}          # print all elements
echo ${arr[@]}          # print all elements

echo ${arr[@]:2:6}      # print range of elements (slicing)

echo ${#arr[*]}         # print number of elements in array) (can also use -> #arr[@])

arr=(`cat`)             # take input from terminal and create array; if they're newline separated, that'll also work
```

Curly braces `{}` are important to avoid variable name parsing ambiguity. Ex - `$arr`[1] (treats arr as a normal variable which is empty)

**String Slicing**: Strings can be sliced just like arrays:
```sh
str="JohnDoe"
echo ${str:0:4}     # prints "John"
```

### Loops
- **for**
```sh
# on a static list
for i in 1 2 3 4 5
do
    echo "Loop is on : $i"
done


# on a range
for i in {1..10}    # {1..10..2} to jump by 2 steps
do
    echo "Loop is on : $i"
done


# on a command's output
for i in `ls`
do
    echo "Loop is on : $i"
done


# C-like for loop syntax
for ((i=0; i<5; i++))
do
    echo "Loop is on : $i"
done
```

- **while**
```sh
while [ ... ]
do
done
```

- **until**
```sh
until [ ... ]
do
done
```
- **select** (not in sh, but in bash)

**Loop Controls**:
```sh
break
continue
exit

# specify a <n> parameter to break/continue out of n enclosing loops -> break n
# specify an exit_code parameter to exit command -> exit 0, for successful termination
```

###  Functions
```sh
function foo(){  }

foo(){  }

foo 	# call
```	

```sh
foo(){
    echo "$1 $2 is the best!"
    #parameters can be accessed using $1, $2 and so on inside the function
    return 69
}

foo john doe	# parameterized function call
echo $?		    # capture value returned by last command (i.e. 69)
```

**Local variables**:
```sh
changeName(){
    name = $1       # line 1
    echo "Name changed to: $name"
}

name = "Morty"
echo "Name before is: $name"
changeName Rick
echo "Name after is: $name"  # line 2

# line 2 will print "Rick"
# the variable "name" on line 1 is not local, to make it local see below:

local name = $1

# line 2 will print "Morty" if we use this as line 1
```

### Debugging
```txt
# from terminal

$ bash -x ./test.sh
```

```sh
# editing source sha-bang

#!/bin/sh -x
```

```sh
set -x

# debug only a portion of the script

set +x
```

### Summary of Brackets & Braces

|  Notation | Description  | Used with  | Usage Example | 
|---|---|---|---|
| `${}` | Variable name replacement with its value, inside it | variables  | `${realm}heim` |
| `$()`  | Command substitution - literally execute commands inside it (_alt of_ \`\`) | commands  | `$(ls -la)` |
| `[ ]`  | Test (use only `-lt` symbols inside) (_spaces matter_) | `if`, etc...  | `if [ 5 -gt 1 ]` |
| `[[ ]]` | Test (_newer_ & _safer_) (use both `-lt` and `<` symbols inside) (_spaces matter_)  | **_same as above_**  | `if [[ 5 > 1 ]]` or `if [[ 5 -gt 1 ]]` |
| `(( ))`  | Test - returns `0` or `1` after arithmetic evaluation, can't test Strings inside this |  **_same as above_** | `if (( 5+1 ))`  |
| `$(( ))`  | Arithmetic evaluation and substitution, returns evaluated value  |  arithmetic expressions | `sum=$(( 5+1 ))` |