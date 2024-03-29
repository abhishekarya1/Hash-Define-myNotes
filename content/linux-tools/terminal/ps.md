+++
title = "Jobs, Process, Mux"
date =  2022-10-02T00:20:00+05:30
weight = 6
+++

## Jobs
Jobs are programs only but they hold the terminal in which they run "hostage" since they may run for a long time, we can't use the terminal for the period in which they are running in the foreground. We can send them to background, or make them keep running even after the terminal is closed.

`Ctrl + Z` suspends (stops) a running program and sends it to background, such that the terminal is free to be interacted to by the user.

`jobs` list all jobs attached to the current terminal/shell

```txt
$ jobs
[1]-  Running                 xeyes &
[2]+  Running                 xclock &
[3]-  Stopped				  xeyes
```
The `+` in the left side tells us that the job will be acted upon if no number is supplied with `%<n>` in job related commands. The `&` at the rightmost side tells us that the job is running in the background.

`bg %1` send job number 1 to background; the terminal becomes usable

`fg %1` bring job number 1 to foreground; the terminal becomes un-usable

`<command> &` run the command in background

`nohup <command>` keep running the command even if the parent terminal is closed (no hangup)

`kill %1` kill job number 1; sends a termination request to it (default)

## Process
`ps` list all running processes in the current shell and their info

`ps -aux` same as above but has more info like CPU usage, memory usage, etc...

- **PID** - process id
- **PPID** - parent process id
- **TTY** - terminal the process is attached to

`top` shows real-time stats on processes (refreshes every 10 sec)

`top -p 1` show info for only process ID 1

`kill <PID>` send a termination request to the process (SIGTERM = 15)

`kill -9 <PID>` force kill the process (SIGKILL = 9)

{{% notice tip %}}
`ps -p 1` is the first process (PID = 1) that runs on the system. It is nothing but **init**! Either Systemd or SysV.
{{% /notice %}}

`nice -n 15 <PID>` adjust _niceness_ value of a process (in range `[-20, 19]`; lesser the niceness, more resources will be allowed to be hogged by the process; only `sudo` users can assign a negative niceness to a process)

`renice -n 15 <PID>` reassigning niceness value; see nice value in `NI` field of the `top` or `ps` command output

run programs/commands with a niceness value set:
```sh
$ ls				# niceness = 0 (default)
$ nice ls			# niceness = 10
$ nice -n 1 ls		# niceness = 1
```

## Terminal Multiplexing
It is a technique used to create multiple terminals in a primary one. We can detach (a lot like `bg`), reattach, and split terminals.

`screen` launches the current terminal as a _"screen"_; press `Enter` and you'll notice no difference but we can press shortcuts now

`Ctrl + A` `D`: detach; create a new screen

`screen -ls` list all screens

`screen -r <screen_name>`: re-attach


`tmux` (newer and better, but often not pre-installed on distros)