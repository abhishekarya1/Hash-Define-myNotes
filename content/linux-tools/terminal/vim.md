+++
title = "Vim"
date =  2022-09-29T13:03:00+05:30
weight = 5
pre = "<i class='devicon-vim-plain'></i> "
+++

`vi` `vim` ultra customizable and fast, in-terminal editor.

**Command mode** (`:`) editor always opens in this mode by _default_  

**Insert mode** (`i`, `I`, `a`, `A`, `o`, `O`) use any of these to enter insert mode (see diff [below](#default-keybinds))

Use `Esc` to exit a mode.

## Commands
`:w` save file; don't exit

`:q` quit

`:wq` or `:x` save work and quit

`:q!` force quit; without saving any work

`:help` open help manual

## Default Keybinds

```txt
i I 			insert on left side of cursor, start of current line

a A 			insert (append) on right side of cursor, end of current line

o O 			add a line above and insert there, below

h j k l			left, down, up, right

gg G 			goto starting line of document, ending line

w b 			move one word at a time forward, backward

e 				move one word at a time forward, with cursor at end of word

X x 			erase a chaarcter backwards, forwards

u U 			undo last action, all

Ctrl + r 		redo

/<searchtext>   search forward (?<searchtext> for backwards)
n N 			move in direction of search, opposite

0 $ 			jump to start of current line, end
```