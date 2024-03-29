+++
title = "Devices & Boot Process"
date =  2022-05-02T20:49:00+05:30
weight = 2
+++

```txt
1 - BIOS
2 - Bootloader
3 - Kernel
4 - init
```
### 1 - BIOS
Basic Input Output System - It is a **Firmware** (b/w Hardware and Software) stored on an EEPROM chip. Identifies hardware, performs a basic sanity check i.e. POST (Power On Self Test), configures it, and invokes the Bootloader from disk. 

**Legacy BIOS**  - Expects bootloader to be stored in MBR, protective MBR in case of GPT.

**UEFI** (Unified Extensible Firmware Interface) - Created by Intel in 1998 as a successor of BIOS. Uses a specific disk partition for boot (EFI System Partition (ESP)) and uses FAT. On Linux it is located (logical) at `/boot/efi` and files are `.efi`. Stores both UEFI code and bootloader in ESP. 

UEFI can find Bootloader manually on all available ESP.

### 2 - Bootloader
It can be a two stage process (1st stage bootloader and 2nd stage bootloader).

Bootloader loads Kernel into memory with parameters that can be tweaked. It is configurable (unlike standardized BIOS or UEFI) so we can configure where to load Kernel from the disk.

**Partition table**: Some space is reserved on MBR or ESP that contains information about how the partitions are organized and where to load the bootloader from.

- **MBR** (Master Boot Record) - First sector on first partition of the disk (512 Bytes).

- **GPT** (GUID Partition Table) - Often used with UEFI as its formally defined in the UEFI spec. Can be stored throughout the drive. Better limits on size and no. of partitions than MBR. MBR allows upto 2TB and 4 partitions only. The first sector of a GPT disk is reserved for a "protective MBR" to make it possible to boot a BIOS-based machine.

Most popular bootloader on linux is **GRUB** (GRand Unified Bootloader). Others like LILO, SYSLINUX etc exists...

|  Boot Config | Bootloader Location  |
|---|---|
|  BIOS-MBR | MBR  |
|  BIOS-GPT | Protective MBR  |
|  UEFI-MBR | ESP  |
|  UEFI-GPT | ESP  |

_Reference_: [How grub2 works on a MBR partitioned disk and GPT partitioned disk?](https://superuser.com/a/1166518)

### 3 - Kernel
Kernel needs a temporary filesystem with core essential drivers to load other drivers. The temporary filesystem used was **initrd** (initial ram disk). Nowadays we use **initramfs**, which is simpler and safer.

Kernel stores all logs in a **kernel ring buffer** (self storing) that can be viewed after booting into the system with `dmesg` command.

**NOTE**: A kernel is also a program afterall! So, it is not uncommon to download and compile the kernel and configure it such that it appears in GRUB menu and we can boot into it specifying parameters too.

### 4 - init

Kernel locates `init` program and runs it. `init` initiates all other essential services on the system.

Three kinds of `init` on Linux - System V init (`sysv`), Upstart, **Systemd**.

The first process that runs is `init`:
```sh
$ ps -p 1		#process with PID 1 i.e. init
```

## Devices

### Sysfs (/sys)
A pseudo filesystem (logical fs). `/sys` differs from `/dev` since it is only concerned with viewing and managing the devices. 

Files in this directory aren't Nodes or Symbolic links, so we can't write to devices using those. 

Also, the devices listed here are not technology and vendor agnostic unlike `/dev`.

### udev (/dev)
Userspace `/dev` - All devices show up here as nodes/files. We can read or write to/from these files inorder to read/write to actual device.

```txt
SCSI Devices:
/dev/sda - first hard drive
/dev/sda1 - first partition of first hard drive
/dev/sdb - second hard drive

Other Devices:
/dev/null
/dev/random
/dev/stdin
/dev/stdout
/dev/stderr
```

```txt
Types of devices:
c - character	writes character by character
b - block		writes to device in blocks of fixed sizes 
p - pipe		channels output of one program to input of other
s - socket		always listening
```

### /proc
Every possible process related information is stored here by Kernel. Also, properties and settings related to the system.

```sh
# example
$ cat /proc/cpuinfo
```
### lspci, lsusb, lshw
Listing various devices and hardware info.

### Loadable Kernel Modules
Stored in `.ko` files (kernel object) which can then be loaded and removed from boot time loading.

```sh
$ lsmod		# list all modules

$ modinfo module_name	# show module info

$ insmod full_path_to_module	# load a module

$ modprobe module_name  	# same as above; but no full path needed here

$ rmmod module_name 	# unload a module
$ rmmod -f module_name	# force unload
```

If you need to load some modules every time your system boots, add their name to this file `/etc/modules`.
