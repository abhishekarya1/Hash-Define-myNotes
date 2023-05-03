+++
title = "IntelliJ IDEA"
date = 2023-05-03T21:01:00+05:30
weight = 2
+++

## Config
Change theme to -> Monokai

Change keymap to -> Eclipse

Change Completion case sensitivity - https://intellij-support.jetbrains.com/hc/en-us/community/posts/205806989-Case-insensitive-code-completion

Run main application .java file to up the spring boot server

Suppress some warning rules regarding unused methods under @RequestMapping etc

Tree Appearance -> Flatten packages

## Shortcuts
```txt
2x Shift - Search anywhere, run slash (/) commands

Ctrl + E - Show Recent Files

Ctrl + N - Search for Classes

Ctrl + Shift + N - Non-Classes (Files) Search

Ctrl + B - Goto method
	Ctrl + Alt + Left/Right Arrow - navigate

Ctrl + Shift + F/R - Find/replace in all

Ctrl + Shift + V - Show clipboard contents

Ctrl + D - Duplicate current line

Alt + 1 - Goto file explorer

Esc - back to editor

Shift + Esc - back to editor and hide explorer

Alt + F7 - find usages

2x Ctrl - Run anything

Ctrl + Shift + Alt + L - optimize imports and Reformat options

Ctrl + Shift + Alt + T - Refactor current

Ctrl + Shift + A - Find actions (lists all shortcuts)

Ctrl + F12 - Show class structure
```
## Debugging
Conditional breakpoints (debug loops with this; will stop at the element we want)

View all breakpoints

Exception breakpoints (stops on the line where the exception occurs!)

Evaluate, Variables tab, and Watches

"Set value" with Variables tab!

"Force return" from a method and set a return value in (Frames tab)

"Throw exception" to throw an exception in runtime (Frames tab)

"Reset frame" to cancel a method call (Frames tab)

"Force return" from a method and set a return value (Frames tab)

"Watchpoint" on class fields (both static and instance) (stop everytime the field's value is accessed/modified)

"Tracepoint" to print value with a custom log statement (Shift + click)

Breakpoint Filters: Catch class, Instance, Class, Caller

Place breakpoint in a Stream and use StreamDebugger to debug it

Use "Renderers" to customize how objects look in the Variables tab

Inspect all objects in memory and run diffs on memory change with Memory tab

View threads and related info in Threads tab; we can step into a method and view all threads that are running it

_Reference_: https://youtube.com/playlist?list=PLVuaPU1nEcV_bslGd23_4LjZWlJuv306R 