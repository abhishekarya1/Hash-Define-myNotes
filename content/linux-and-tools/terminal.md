+++
title = "Terminal"
date =  2021-05-01T00:31:24+05:30
weight = 1
+++



## Linux Terminal Commands
- **Shell**: Intermidiary between OS kernel and console/terminal.
---

### Basics
- **echo {text}** (prints text or blank if no text specified)
	- **-e** (recognize escape '\seq' sequences inside "string") (not recognized by default)
- **date** (prints date and time)
- **whoami** (prints user name)
- **pwd** (prints the present working directory)
- **cd {path}**
  - **cd .** (current directory/does nothing)
  - **cd ..** (immediate parent directory)
  - **cd \~** or **cd** (default "home" directory)
  - **cd /** (root directory [/])
  - **cd -** (previously visited directory, even if it is the far child)
  
- **ls {path}**
  - **-a** : shows hidden files (.example) too (a = all)
  - **-l** : shows a detailed list of files in a long format (l = long)
  - **-la , -al** : combined
  - **wildcard** (`$ ls *.txt`)
- **touch [file1] {file2} ...** (updates timestamp when applied on existing files) 
- **file [filename/dirname]...[fileN/dirN]** (tells what kind of file it is, also works with directory)
- **cat {_file1_} {_file2_}** (prints contents of a file OR combine two files and print their content **in order**)
  - **-n** (display with line numbers for all lines)
  - **-b** (display with line numbers for only non-empty lines) 
- **less [_file_name_]** (text nav and search in console itself)
  - _PgUp, PgDown, Up arrow, Down arrow_ : navigation
  - _g_ : jump to beginning of the text file
  - _G_ : jump to end of the text file  
  - _/searchtext_
  - _q_ : quit
  - _h_ : help

- **history {n}**
- _Reverse Search (Ctrl+R)_ : Hit Ctrl+R to navigate the reverse search
- _Up-Arrow_ for last command
- **clear** clears terminal

- **cp [sourcefile/dir] [destfile/dir]** (copy files and directories, overwrites by default)
	- **\*** (used to represent all single characters or any string)
 	- **?** (used to represent one character)
 	- **[^]** (used to represent any character within/not within the brackets)
    ```
    $ cp *.jpg ./home/pete/Pictures
    ```
  	- **-r** (to copy directories (recursively copy)) (can't copy directories without it)
  	- **-i** (to prompt before overwriting a file)

- **mv** (move one or more than one file/dir or **rename** files/dir) (by default recursive)
    ```
        $ mv old_name new_name
        $ mv file path/
        $ mv file1 file2 path/
    ```
    - **-i** (prompt before overwrite)
    - **-b** (rename old and move the new file) (b = backup)
- **mkdir [_dir_name_] {_dir1_name_}** (make directories)
    - **-p** (make multiple nested dir)
    ```
        $ mkdir -p books/premchand/favorites
    ```
- **rm [_file/dir_name_]... {_file/dirN_}** (remove files/non-empty dir)
    - **-f** (force delete even if write protected) 
    - **-i** (prompt before deleting)
    - **-r** (recursively delete all subdirectories) (_only way it can work on dir_)
- **rmdir [_dir_name_] ... {_dirN_}** (removes directories _only if_ they're empty)
- **find** (recursively search a file or dir) 
    ```sh
  $ find /home -name puppies.jpg
  $ find /home -type d -name MyFolder
  $ find /home -type d -empty
  $ find . -name cert
  $ find / -name hey -type d
  $ find dir1 dir2 -name "abc*f"
  $ find . -perm 700
  $ find . -size +3M (files greater than 3Mb)
  $ find . -size -200c (files smaller than 200 bytes)
  $ find . -atime -3 (accessed within last 3 days)
  ```
---
### Text Manipulation
- **stdout** : **>** (write from start) & **>>** (append) [both create a new file if it doesn't exist]
- **stdin** : `$ cat < foo > bar` (data goes from "foo" to "cat" and then to "bar") 
- **stderr**
 
- **Pipe (|)** : Channel the output of one command to input of another
    `$ echo | cat file.txt` (if contents of file.txt are "Hello World" then they are printed on console)
- **tee** : Channel output to two process simultaneously
    `$ ls | tee file.txt` (prints ls output on console as well as writes to file.txt)
- **env** ($SHELL, $HOME, $USER, $PATH and other environment variables)
- **cut** (print selected parts of the file line to console)
	```sh
	$ cut -c 2 my.txt
	$ cut -f 1 my.txt
	$ cut -f 1 -d ";" my.txt
	
	$ cur -f 2,5,7 sample.txt
	$ cut -c 5-10 sample.txt
	$ cut -c 5- sample.txt
	$ cut -c -5 sample.txt
	```
- **paste** (merge data from files, pastes corresponding lines with TAB delimiter between them by default)
	```sh
	$ paste file (equivalent to cat)
	$ paste -s file (combine all lines in file into one, TAB separated)
	$ paste file1 file2 (prints corresponding lines from both the files)
	$ paste -d: file1 file2 (custom delimiter :)
	$ paste -d")" file1 file2 (some char need brackets)
	$ paste - - < file (merge file lines into two columns) 
	$ paste -d";" - - - < file1
	```
- **head, tail** _filename.txt_ (read first/last few lines of a file, default = 10)
    - `$ head -n 15 filename.txt`  (space between `-n15` doesn't matter)
    - `$ head -n -2 file` (print all but the last 2 lines)
    - `$ tail -n +2 file` (start print from line 2)
    - `$ head -c 20 filename.txt`  (print the first 20 characters from first line of the file) 
    - `$ tail -f filename.txt` : follows the last lines of the file in real-time update
- **expand** _filename.txt_ (convert TAB to spaces)(doesn't modify file but prints to console)
- **unexpand** -a _filename.txt_ (convert TAB to spaces)(doesn't modify file but prints to console)
- **join** [file1] [file2] (joins by a common field)
    - `$ join -1 2 -2 1 file1.txt file2.txt` (-1 is _file1.txt_, -2 is _file2.txt_) (field 2 in file1.txt = field 1 in file2.txt)
- **split** filename (splits into different files on threshold lines, default = 1000)
- **sort** _filename.txt_   (default separator is not TAB but space here, specify using `-t $'\t'`)
    - **-r** (reverse sort)
    - **-n** (numerical sort, `9 > 43` in normal, but correct with `sort -n`)
    - **-f** (both upper and lower case of a letter are equal in sort comparison)
    - **+X** (ignores first X fields, X = any number)
    - `-k n` (sort on the nth field of the line)
    - `-t 'char'` (use char as field delimiter) (ex: -t '|' or -t ',')
    - `-u` (show only distinct lines)
    - `-m list1 list2` (sort and merge lists into one and print only) (use pipe for writing to file)
- **tr** (translate)
   ```sh
   $ tr "a" "z" file.txt
   $ tr a-z A-Z (waits for input)
   $ cat file | tr a-z A-Z (translate and print)
   $ cat file | tr a-z A-Z > file (tr and write) (alternatively | cat > file)
   $ tr -c 'a' 'z' (complement of set1 replaced by set2. Ex. abcd -> azzz)
   $ tr -d 'a' (delete all of set. Ex. abcda -> bcd) 
   $ tr -s [:space:] (squeeze multiple occurances of set into one. Ex. baaaad -> bad)
   ```
- **uniq** (https://linuxjourney.com/lesson/uniq-unique-command) (only adjacent duplicate lines are detected)
    - **-c** (count line)  
    - **-u** (only unique lines)
    - **-d** (only duplicate lines)
    - **-i** (ignore case)
    - **-fN** (skip the first N fields in comparison)
- **wc** _file.txt_ (display the lines, words, and bytes, respectively)
    - **-l** (only lines)
    - **-w** (only words)
    - **-c** (only bytes)
    - **-L** (length of longest line in file)
- **nl** _file.txt_ (displays line with numbers at the left side)
- **grep** (`grep {-flag} 'regex' {file1} ... {fileN}`) (Global Regular Expression Print)
    - returns all strings, file, or dir names matching the regex pattern
---
### Vi/Vim
- **/search_pattern** ("n" to go forward or "N" to go backward in search)
- **?search_pattern** (search backwards)
- Navigation in vi (**hjkl -> ldur** arrows)
- Command mode (Shift+:)
- Edit mode
- Saving and quitting
---
### User Management

- Users -> Groups : (UID -> GID)
- **sudo** (run commands as a superuser) (sudo = superuser do)
- **su** (substitute user with password)
- **/etc/sudoers** (file containing sudo user's info)
- **useradd** `$ sudo useradd bob`
- **userdel** `$ sudo userdel bob`
- **passwd** `$ passwd bob`
---
### Help
- **help {_cmd_name_}** 
- **man** cmd_name
- **cmd_name --help**
- **whatis** cmd_name : (small description of a command)
---
### Terminal
- **alias**, **unalias**, **exit**, **logout**
---

### Permisssions (order = rwx) (generic file -, dir d)
- `d | rwx | r-x | r-x ` (file_type | user perm | group perm | other user perm)
- r (readable), w (writable), x (executable), - (empty)
- **chmod** (change mode) (o = other, u = user, g = group, a = all)
    - `$ chomod u+r myfile` (adding r permission for the current user)
    - `$ chmod ug+x myfile`
    - `$ chmod +x myfile`
    - `$ chmod a-r myfile` (removing r permission for all users, groups and others)
    - `$ chmod g = rx myfile` (sets rx in group permission and removes w)
- **Numeric Format** `$ chomod 755 myfile` (7 = 4+2+1 = user, 5 = 4+1 = group, 5 = other)
    - 4: read permission
    - 2: write permission
    - 1: execute permission 
- **Ownership**
    - **chown** user_name myfile
    - **chgrp** group_name myfile
    - **chown** user:group myfile (combined form)
- **unmask** (takes away the specified permissions) 
	`$ unmask 021 myfile` 

---

### Filters (grep, sed, awk)

- **grep** `$ grep 'regex' {file1} ... {fileN}`
  - **-i** (case insensitive match)
  - **-c** (print only count of matching lines)
  - **-n** (print matched line with number)
  - **-l** (print only the names of files with matching lines)
  - **-v** (print all lines that DO NOT match the pattern)
  - **-r "pattern" \*** (recursive search)
  - **-w "is"** (check for full words (can't match his, this, tiss now))
  - **-B 'regex'** (regex is Basic, a+) (default)
  - **-E* 'regex'** (regex is extended, (this|that|those)) 
  - Use `ls | grep 'regex'` to search for directory/file names and print them (ls only has `*`, `?` and `[]` by default w/o grep)

- **sed** 
- **Syntax:** `$ sed '/pattern/' file`
```sh
$ sed -e s/unix/linux/ file (alternative syntax)
$ sed -e 's/unix/linux/' -e '5d' file (can issue multiple commands using -e) 
$ sed '/unix/' file (print first line containing unix)
$ sed '/unix/ig' file (print all lines containing unix, case-insensitive)
$ sed 's/unix/linux/' file (substitute only the 1st occurance of unix with linux)
$ sed 's/unix/linux/3' file (substitute only the 3rd occurance of unix with linux)
$ sed 's/unix/linux/g' file (substitute all, global)
$ sed 's/unix/linux/3g' file (substitute 3rd to all occurances)
$ sed '3 s/unix/linux/' file (replace string only on 3rd Line)
$ sed '1,3 s/unix/linux/' file
$ sed 's/unix/{&}/g' file (wrap all occurances on unix in {})
$ sed 's/unix/linux/p' file (if replaced, then print new line twice on the console, otherwise only once)
$ sed -n 's/unix/linux/p' file (only print once even if replaced)
$ sed '5d' file (delete 5th line)
$ sed '$d' file (delete last line)
$ sed '3,$d' file (delete 3rd to last lines)
$ sed '/unix/d' file (delete line having pattern)
```
Link: https://www.geeksforgeeks.org/sed-command-in-linux-unix-with-examples/

---
### Miscellaneous
- **cal**
  - `-y` {`2020`}
  - `-1` (current month only)
  - `-3` (prev, current, and next month)
- **diff**
Link: https://www.geeksforgeeks.org/diff-command-linux-examples/
### Networking
- `ifconfig`
- `cURL` (Client URL): Command line tool and library to send and get requests using a number of protocols (used for testing APIs)

	```sh
	$ curl www.google.com 
	#sends a GET request by default
	```
	- `-i` (include HTTP header)
	- `-I` or `--head` (show only the HTTP header)
	- `-o file.txt` (output to file.txt)(we can use `>` too)
	- `-O` (download the response)
	- `-d` or `--data` (POST = send data to the server)
	```sh
	$ curl -d "name=abhi&location=boston" www.example.com
	```
	- `-X PUT -d` (for PUT method)
	```sh
	$ curl -X PUT -d "name=abhi&location=boston" www.example.com
	```
	- `-X DELETE` (for DELETE method)
	- `-u user:pass` (authentication)
	- `-L` (follow redirection, will go to new resource)