+++
title = "Filesystem & Disk"
date =  2022-09-15T23:23:00+05:30
weight = 3
+++

## Filesystem
Every directory in linux is a child of root (`/`) directory.

Filesystem Hierarchy Standard[^1] [^2] (FHS), maintained by the Linux Foundation: 

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

### Directory Shorthands

`/` root

`~` home dir (often home/johndoe)

`.` current dir

`..` parent dir

`-` previous dir 


## Disk Partitions
Physical disks are often partitioned logically in linux.

BIOS-MBR allows upto 4 patitions but extended partitions can be created to make more logical partitions.

```sh
---------------------------------------------------
| /sda1  |  /sda2 | | extended partition        | |
---------------------------------------------------

---------------------------------------------------
| /sda1  |  /sda2 | |  /sda3  |  /sda4  | /sda5 | |
---------------------------------------------------
``` 

`/sda3`, `/sda4`, and `/sda5` are part of the extended partition so we have a total of `5` partitions this way.

UEFI-GPT allows upto 128 partitions.


**Mounting**: Partitions can be **mounted on a directory** (`/tmp`, `/home`, etc...), it means that the directory path is a mountpoint to access the disk and whatever we write to/read from the mountpoint, it will use the partition.

| Size | Partition | Mounted at | 
|:---:|:---:|:---:|
|  1GB | /sda1  | /boot |
|  4GB | /sda2  | linux-swap |
|  10GB | /sda3  | /home |
|  985GB | /sda4  | / |


### Swap Partition
Used for **virtual memory** aka **paging**. There is a partition called `linux-swap` that can be created for this.

_Debian_: uses `linux-swap` partition

_Ubuntu, Windows_: saves paging data in a single file (**pagefile**)

_Fedora, Android_: uses **zram**: Sets aside temporary space on RAM itself and compresses & stores data there instead of the disk

There is no hard & fast rule for deciding on the swap partition size. You can choose any size but do note that swap is not a replacement for RAM as its much slower.


### Tools
- **CLI**: fdisk, parted, LVM
- **GUI**: gparted

LVM is a special one, it can create partitions across disks; we can extend and shrink partitions using space from other disks too.