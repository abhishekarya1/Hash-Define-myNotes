+++
title = "Terminal"
date =  2021-05-01T00:31:24+05:30
weight = 1
+++

## Background
- [Video](https://www.youtube.com/watch?v=ShcR4Zfc6Dw)
- [Article](https://www.gnu.org/gnu/linux-and-gnu.en.html)
---

## Linux Terminal Commands
- **Shell**: Intermidiary between OS kernel and console/terminal.
---

### Basics
- **echo {text}** (prints text or blank if no text specified)
	- **-e** (recognize escape '\seq' sequences inside double-quoted "string") (not recognized by default or without inside double-quotes)
- **date** (prints date and time)
- **whoami** (prints user name)
- **pwd** (prints the present working directory path)
- **cd {path}**
  - **cd .** (current directory/does nothing)
  - **cd ..** (immediate parent directory)
  - **cd \~** or **cd** (default "home" directory)
  - **cd /** (root directory)
  - **cd -** (previously visited directory, even if it is far away (not immediate))
  
- **ls {path}**
  - **-a** : shows hidden files (.example) too (a = all)
  - **-l** : shows a detailed list of files in a long format (l = long)
  - **-la , -al** : combined
  - **wildcard** (`$ ls *.txt`)

- **Wildcards**
    - **\*** (used to represent all single characters or any string)
    - **?** (used to represent one character)
    - **[^]** (used to represent any character within/not within the brackets)

{{% notice info %}}
Filenames and directory names are case-insensitive.

A file and a directory having exact same names cannot coexist in the same directory since directories are also files in linux.
{{% /notice %}}
  
- **touch [file1] {file2} ...** (updates timestamp when applied on existing files) 
- **file [filename/dirname]...[fileN/dirN]** (tells what kind of file it is, also works with directory)
- **cat {_file1_} {_file2_} ...** (prints contents of a file OR combine files and print their content **in order**)
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
    - copies contents if destination is a file
    ```
    $ cp *.jpg ./home/pete/Pictures
    ```
    - **-r** (to copy directories (recursively copy)) (_only way it can work on dir_)
    - **-i** (to prompt before overwriting a file)

- **mv [file/dir1] ... [file/dirN] [dest_dir]** (move one or more than one file/dir or **rename** files/dir) (by default recursive; overwrites)
    ```
        $ mv old_name new_name
        $ mv file path/
        $ mv file1 file2 path/
    ```
    - **-i** (prompt before overwrite)
- **mkdir [_dir_name_] {_dir1_name_}** (make directories)
    - **-p** (make multiple nested dir)
    ```
        $ mkdir -p books/premchand/favorites
    ```
- **rm [_file/dir_name_]... {_file/dirN_}** (remove files/dir)
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
- **stderr** : [Link](https://linuxjourney.com/lesson/stderr-standard-error-redirect)
 
- **Pipe (|)** : Channel the output of one command to input of another. Ex: `$ ls -la | less`

    - NOTE: (`$ ls | file.txt` doesn't copy ls output to file.txt, so pipe `|` is different from redirection `>`)
- **tee** : writes to both the standard output and one or more files

    - **-a**: append mode; no overwriting if file already exists

    `$ ls | tee file.txt` (prints ls output on console as well as writes to file.txt)
- **env** ($SHELL, $HOME, $USER, $PATH and other environment variables)
- **cut** (print selected parts of the file line to console)
    - **-c** : character, starts from 1
    - **-f** : field, specify delimiter with **-d** (default is TAB)
    ```sh
	$ cut -c 2 my.txt
    $ cut -c 2,7 my.txt
	$ cut -f 1 my.txt
	$ cut -f 1 -d ";" my.txt
	
	$ cut -f 2,5,7 sample.txt
	$ cut -c 5-10 sample.txt  (both positions included)
	$ cut -c 5- sample.txt    (5-end)
	$ cut -c -5 sample.txt    (start-5)   
    ```

- **paste** (merge lines from files, pastes corresponding lines with TAB delimiter between them by default)
	```sh
	$ paste file (equivalent to cat)
	$ paste -s file (combine all lines in file into one, TAB separated)
	$ paste file1 file2 (prints corresponding lines from both the files side-by-side on terminal)
	$ paste -d: file1 file2 (custom delimiter : for output)
	$ paste -d")" file1 file2 (other chars need double-quotes)
	$ paste - - < file (fold two lines into two columns)
	$ paste -d ";" - - - < file1 (three columns)
    ```

- **head, tail** _filename.txt_ (read first/last 10 lines of a file, by default)
    ```sh
    $ head -n 15 filename.txt  (space between -n15 doesnt matter)
    $ head -n -2 file (print all but the last 2 lines)
    $ tail -n +2 file (start print from line 2)
    $ head -c 20 filename.txt  (print the first 20 characters from first line of the file) 
    $ tail -f filename.txt (follows the last lines of the file in real-time update)
    ```
- **expand** _filename.txt_ (convert TAB to group of spaces)(doesn't modify file but prints to console)
- **unexpand** -a _filename.txt_ (convert group of spaces to TAB)(doesn't modify file but prints to console)
- **join** [file1] [file2] (joins by field = 1 by default)
    - `$ join -1 2 -2 1 file1.txt file2.txt` (-1 is _file1.txt_, -2 is _file2.txt_) (field 2 in file1.txt = field 1 in file2.txt)
- **split** _filename.txt_ (splits into different files after threshold line, default = 1000, created file name = x\*\*)
    - `$ split -l 5 file1.txt file` (split first 5 lines from file1.txt and files named `fileaa`,`fileab`, ... are created)
- **sort** _filename.txt_   (default separator is not TAB but space here, specify using `-t $'\t'`)
    - **-r** (reverse sort)
    - **-n** (numerical sort, `9 > 43` in normal, but correct with `sort -n`)
    - **-f** (ignore-case; both upper and lower case of a letter are equal in sort comparison)
    - **+X** (ignores first X fields, X = any number)
    - `-k n` (key; sort on the nth field of the line)
    - `-t 'char'` (use char as field delimiter) (ex: -t '|')
    - specify TAB delimiter using `-t $'\t'` because [this](https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#ANSI_002dC-Quoting)
    - `-u` (unique; show only distinct lines)
    - `-m list1 list2` (merge already sorted files; do not sort; print only) (use > for writing to file)
- **tr** (translate)
   ```sh
   $ tr "a" "z" #Syntax: tr SET1 SET2
   $ tr "()" "[]" (elements of the SET1 are replaced with corresponding element from SET2)
   $ tr a-z A-Z (waits for input)
   $ cat file | tr a-z A-Z (translate and print)
   $ cat file | tr a-z A-Z > file (tr and write) (alternatively | cat > file)
   $ tr -c 'a' 'z' (complement of set1 replaced by set2. Ex. abcd -> azzz)
   $ tr -d 'a' (delete all of set. Ex. abcda -> bcd) 
   $ tr -s [:space:] (squeeze multiple occurances of set into one. Ex. baaaad -> bad)
   ```
- **uniq** (only **_adjacent_** duplicate lines are detected unlike _sort -u_)
    - **-c** (display unique items with count)  
    - **-u** (only unique lines)
    - **-d** (only duplicate lines)
    - **-i** (ignore case)
    - **-fN** (skip the first N fields in comparison)
- **wc** _file.txt_ (display the lines, words, and bytes, respectively)
    - **-l** (only lines)
    - **-w** (only words)
    - **-c** (only bytes)
    - **-L** (length of longest line in file)
- **nl** _file.txt_ (displays line with numbers at the left side; starts with 1)
- **grep** (Global Regular Expression Print)
    - returns all strings, file, or dir names matching the regex pattern
    ```sh
    $ grep abcd test.txt
    ````
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
- Every user has a username and a UID associated with them, same for groups (single group can have multiple users under it) 
    - Users -> Groups : (UID -> GID)
- **sudo** (run commands as a superuser) (sudo = superuser do) 
- Important files:
    - `/etc/sudoers` (file containing sudo user's info)
    - `/etc/passwd` (conatains user info)
    - `/etc/shadow` (contains password details of users (encrypted))
    - `/etc/group` (contains group info)

- **Adding a user :** `$ sudo useradd bob`
- **Deleting a user :** `$ sudo userdel bob`
- **Changing password for a user :** `$ passwd bob`
---
### Help
- **help** {_cmd_name_}
- **man** cmd_name
- cmd_name **\-\-help**

### Terminal (Meta)
- `alias foobar="ls -la"`
- `unalias foobar`
- **exit**, **logout**
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
    - 0: empty permission
- **Ownerships**
    - **chown** user_name myfile
    - **chgrp** group_name myfile
    - **chown** user:group myfile (combined form)
- **unmask** (takes away the specified permissions for all new files that will be created (default unmask is 022)) 
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

[My Notes on CURL](/linux-and-tools/curl)

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