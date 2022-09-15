+++
title = "Disk & Filesystem"
date =  2022-09-15T23:23:00+05:30
weight = 3
+++

## Filesystem
Every directory in linux is a child of root (`/`) directory.

Filesystem Hierarchy Standard[^1][^2], maintained by the Linux Foundation: 

| Name  |  Functionality |
|---|---|
|  /bin |  binaries (commands) |
|  /sbin |  system binaries (system commands) |
|  /lib |  shared libraries for commands (bin & sbin) |
|  /boot |  files needed to boot the system |
|  /dev |  device nodes |
|  /sys | device info files |
|  /etc | editable text configuration files (`.conf`)  |
|  /home | contain user home folders  |
|  /var | variable files, keeps changing, logs & cache  |
|  /opt |  optional files |
|  /tmp | temporary files, can't persist between reboots  |
|  /proc | running process information in files  |
|  /media | removable drives like USB |
|  /mnt   | temporarily mounted filesystems |

The `/usr` directory is the most misunderstood. It is a **secondary hierarchy**, which means it can have all these directories listed above inside of it and store non-essential data in them. It can be used as a shared directory to store data shared by all users and can be called a "Universal System Resources".

_History_: In UNIX, `/usr` was a users directory (/usr/alice), but in GNU/Linux the user-specific directories goes in `/home` (/home/bob).

[^1]: Filesystem Hierarchy Standard - [Wikipedia](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard)
[^2]: Linux Directories Explained in 100 Seconds - Fireship [[YouTube]](https://youtu.be/42iQKuQodW4)

## Directory Shorthands

`/` root

`~` home dir (often home/johndoe)

`.` current dir

`..` parent dir

`-` previous dir 