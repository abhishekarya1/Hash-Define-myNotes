+++
title = "Shell Scripting"
date =  2021-05-01T00:31:34+05:30
weight = 2
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

String are in `""` or `''`, or even without any quotes. Tilde-quotes (``) are reserved and means literal execution of whatever is inside them.

**Executing** remember to give executable permission (`x`)
```txt
$ ./test.sh

-- or --

$ sh test.sh
```

### Variables
**Scopes**: Environment, Shell, and Local (CASE SENSITIVE JUST LIKE REST OF UNIX)
```sh
#!/bin/sh
echo $name              # nothing printed, by default -> empty var 
name=John               # assignment
echo Hello $name!       # usage

readonly age=55         # a constant
unset name              # reset variable's value to empty
```
`$VAR_NAME` : A `$` prefix is required only when using the variable; not during assignment

Spaces between operands and operators are not at all valid (mostly) in a shell script.
```sh
name = John     # error; command "name" not found 

name=John       # valid
```

### User Input
**Interactive**
```sh
read username

# a prompt and variable input in the same line
read -p 'Enter username: ' name

# secret; don't show input in terminal output
read -sp 'Enter password: ' password

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

- A _fresh_ shell console is started when we run a script, no var values are stored by default in between script runs.
- **export** $MY_VAR = abhi, and then run the script
- To channel back changes in variables to env, use dot `$ . ./script.sh`
- `touch "${USER_NAME}_file"` ({} specify variable placeholder and "" avoid var name extent)
- **Wildcards** (`*` `?` etc are allowed
- **Special Chars** (`"`, `'`, `\`, `(backtick)`, `$`) (Escape them as and when applicable)

### Quoting 
- **Double-quotes** (allows some special chars inside, like `$`, but not `\escape_seqs`)
- **Single-quotes** (ignores all special char inside)
- **Backticks** (anything inside of it is executed)

---
### Arrays
- `myArray=(one, two, three, four)...` (Definition)
- `myArray[3]=nine` (write single element)
- `echo ${myArray[3]}` (print single element)
- `echo ${myArray[*]}` or `echo ${myArray[@]}` (print all elements)
- `echo ${#array[*]}` (print number of elements in array) (can also use `@`)
<br>
- (curly braces {} are mandatory)
- (indexing starts from 0)
---
### Operators
- `$((2+3))`(no space issues)
- \`expr 2 + 3\` (spaces matters a lot here) (prints -> 2+3, if no space)
- https://www.tutorialspoint.com/unix/unix-basic-operators.htm
---

### Decision Making

- **if-then-elif-else-fi**
```sh
if [ ... ]
then
	#body
fi
```

```sh
if [ ... ]; then	#if and then needs to be on different lines or use ";"
elif
then
fi
```

```sh
#!/bin/sh 

FRUIT="kiwi"  

case  "$FRUIT"  in  
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
---
### Loops
- **for**
    ```sh
    #!/bin/sh
    for i in 1 2 * 4 5
    do
        echo "Loop is on : $i"
    done
    ```
    (* loops on every file name too in the current dir)

- **while**
    ```sh
    while [#condition]
    do
    done
    ```
    
    ```sh
    while :  #always true
    do
    done
    ```
 - **until**
	```sh
	 until [#condition]
	 do
	 done
	```
- **select** (not in sh, but in bash)
- **Loop Controls**
	- **break** {n}
	- **continue** {n} 
---
### Substitution
- Command Substitution (`` or `$()`)
	```sh
	#!/bin/sh
	DATE=`date`		#date is executed and result stored in variable
	echo "Current Date: $DATE"  
	# Output-> Current Date: 07 Nov 2020 00:09:01
	```
--- 
###  Functions
- **Syntax**
```sh
#definition

foo(){
#body
}

foo 	#function call
```	
- **Parameterized Function**
 ```sh
 foo(){
 echo "$1 $2 is the best!"
 #parameters can be accessed using $1, $2 and so on inside the funtion
return 10
 }

foo abhi arya		#function call
echo "$?"		#capture value returnd by last command
 ```