+++
title = "My Sublime Environment"
date = 2018-06-07
weight = 4
+++


### Preliminaries

1. Download and copy /MinGW/bin path to the Environment Variables. Download Link - www.cb.lk/compile
2. Setup Guide. Link - https://medium.com/@aggarwaldeepak/c-learning-environment-3df85a46784b

### Sublime Packages 

Keyboard Shortcut: Ctrl+Shift+P -> Install Packages -> "Package Name"

 - SublimeAStyleFormatter
 - Terminal
 - Wakatime
	
### More Keyboard Shortcuts

 - For Building/Compiling: Ctrl+B
 - For Powershell Terminal: Ctrl+Shift+T
 - For Auto-formatting the code: Ctrl+Alt+F
 - For New Tab: Ctrl+N
 - For Closing Current Tab: Ctrl+W
 - For Saving Current: Ctrl+S
 - For Saving As.. Current: Ctrl+Shift+S
 - For Switching Tabs: Ctrl + Tab
 - For Scrolling Up/Down: Ctrl + Up/Down Key
 - For Inserting HTML Tags: _write tagname_ and then press Tab
 - For Multiple Coloumns: Alt + Shift + _number of coloumns_ (max. = 4, nos. after that for various display modes)
 - Focus on Single Coloumn: Ctrl + _number of coloumn_
 - Jump to the closing/opening braces of a block: Ctrl + M
 - List all functions: Ctrl + R

### Snippets in Sublime
Tools -> Developer -> New Snippet...

Link:: https://www.quora.com/How-can-I-add-my-default-C-C++-code-in-Sublime-Text

		> cpp_default.sublime-snippet

### Input from an "input.txt" file directly in Sublime
Tools -> Build System -> New Build System...
Link:: https://www.quora.com/Is-there-a-way-to-compile-and-run-C++-in-Sublime-Text

	> MyC++Build.sublime-bulid
	
### Build Systems
Used to change with what compiler does sublime compile and other command-line options

Link: https://www.thecrazyprogrammer.com/2017/04/how-to-run-c-and-c-program-in-sublime-text.html	

### subl - command line access

- Open sublime just by typing `subl` in terminal and pressing Enter
- Create a new file by typing `subl file_name.cc` in terminal and pressing Enter

Open start menu,

1. Type Edit environment variables
2. Open the option Edit the system environment variables
3. Click Environment variables... button
4. There you see two boxes, in System Variables box find path variable
5. Click Edit
6. a window pops up, click New
7. Type the Directory path of your .exe or batch file ( Directory means exclude the file name from path)
8. Click Ok on all open windows and ~~restart your system~~ restart the command prompt.