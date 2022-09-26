+++
title = "Awk"
date =  2021-05-01T00:31:56+05:30
weight = 3
+++

### awk (Aho, Weinberger, and Kernighan)
- AWK Operations:
    - Scans a file line by line
    - Splits each input line into fields
    - Compares input line/fields to pattern
    - Performs action(s) on matched lines

- **Syntax:** `$ awk /regex/'{action}' filename` or `$ awk '/regex/{action}' filename`
- **Default behavior:** `$ awk '{print}' file.txt`
- **Field Separator:** `-F "sep"` where sep is the separator 
        `$ awk -F "," '{print $2, $3}' file.txt`
    (prints only the fields 2 and 3 of the file) 
    (fields have to be seaprated by a comma (,) in this case)
- **Read action from file:** `-f file_containing_action`
- **Regex matching:** `$ awk '/regex/' filename.txt`
`$ awk /regex/ filename.txt` 
    - **Regex in a field** (`$ awk '$3 ~ /programmer/' emp_data`)
    ```sh
    if($2 == "string")  #will match whole date of none of it
    if($2 ~ "regex")    #useful for finding only year in "25/12/2019"
    alternatively, if($2 ~ /regex/)
    # $2 !~ "regex" (be careful with single-quotes, they work like in shell)
    ```
    - Set **IGNORECASE** variable in BEGIN block to do case-insensitive matching with `~` as well as `==` _anywhere_ in the script `BEGIN{IGNORECASE=1}`
- **BEGIN and END blocks:**
    ```sh
    $ awk 'BEGIN{print "hi"} {print} END{print "bye"}' file.txt
    ```
- **Line-by-Line:** (value in field 2 ($2) of every line keeps on getting added)
    ```sh
    $ cat file.txt
    apple 1
    ball 2
    cat 3
    dog 4
    
    $ awk 'BEGIN{s=0} {s=s+$2;print s}' file.txt
    1
    3
    6
    10
    ```
- **Built-In variables in awk:**
    - `$1`, `$2`, `$3`, and so on (`$0` is the entire line) 
    - FS, OFS (Input and output file separators)
    ```sh
    #specify FS="CHAR" in BEGIN block
    #If any change/update is done to any field, only then will OFS change for $0, else $0 remains on existing FS even if OFS is defined
    #if OFS is defined then use comma (,) in print to insert between fields 
    print $1, $2, $3, $4
    ```
    - RS, ORS (Input and output record separators) (record = lines)
    - NR, NF, FNR (present line number, present field number, and total lines/records in the file)
    - FILENAME (current file's name)
    - ARGC, ARGV (no. of cmd-line args, array that stores them (0 to ARGC-1))
    ```sh
    # will print whole lines even with $1 as default separator is TAB
    $ awk 'BEGIN{FS=","} {print $1}' file.txt   
    # fixed by specifying separator as comma (,)
    # double-quotes mandatory with FS var
    ```
- **Arithmetic**, **pre and post**, **assignment**, **relational**, **logical**, **ternary** (same as in C) 
(`**`/`^` is for exponentiation, `**=`/`^=` shorthand assignment)
- **String concatenation operator** (SPACE)
  ```sh
  $ awk 'BEGIN{str1 = "Abhi"; str2 = "Arya"; str3 = str1 str2; print str3}' 
  ```
- **Arrays**
    - **Creation** `arrayName[key]=value`
    - **Access** `arrayName[key]`
    - **Delete** `delete arrayName[key]`
    ```sh
    for (i in a)
        print a[i]
    ```
- **Control Flow** (same as in C)
    ```sh
    if(condition) { }
    else { }
    ```
- **Loops** (for, while, do while, break, continue, exit(10)) (same as in C) 
```sh
 for (i in a)
    print i
```
- **Built-in Functions** (https://www.tutorialspoint.com/awk/awk_built_in_functions.htm)
- **User Defined Functions** (`function foo(arg1, arg2) { return bar }`)
- **Redirection** (we can redirect output using > and  >> inside awk action)
  `$ awk 'BEGIN { print "Hello, World" > "/tmp/message.txt" }'`
- **Piping** (https://www.tutorialspoint.com/awk/awk_output_redirection.htm)
- **printf** `printf format, value_list`
    - printf functionality and attributes are same as in C
- **Command-line params:**
    - `$ awk '{}' file.txt arg1 arg2` (access using `ARGV[2]` and so on)(poor way, works but `arg1` recognized as an input file too ad gives error alongwith correct output)
    - `ARGV[0]` is `awk` and `ARGV[1]` is `file.txt`
    - ```sh
        #!/bin/sh
        awk -v arg1="$1" -v arg2="$2" '{}' file     #($1, $2 are cmd-line args to sh command)
      ```