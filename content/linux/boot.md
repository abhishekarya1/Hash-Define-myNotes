+++
title = "Boot Process"
date =  2022-05-02T20:49:00+05:30
weight = 1
+++

```txt
1 - BIOS
2 - Bootloader
3 - Kernel
4 - init
```
### 1 - BIOS
**Firmware** - b/w Hardware and Software

**BIOS** (Basic Input Output System) - Firmware that identify's hardware, performs a basic sanity check (POST (Power On Self Test)), configures it, and connects to OS.

**UEFI** (Unified Extensible Firmware Interface) - Created by Intel in 1998 as a successor of BIOS. Uses a specific disk partition for boot (EFI System Partition (ESP)) and uses FAT. On Linux it is on `/boot/efi` and files are .efi.

Check `/sys/firmware/efi` to see if you are using a UEFI system or not.

### 2 - Bootloader

BIOS looks for Bootloader on disk. It can be a two stage process (1st stage bootloader and 2nd stage bootloader). Bootloader loads Kernel with parameters that can be tweaked.

**MBR** (Master Boot Record) - First 512 Bytes of first sector on first partition of Hard Disk

**GPT** (GUID Partition Table) - Often used with UEFI. Better limits on size and no. of partitions than MBR. MBR allows upto 2TB and 4 partitions only. The first sector of a GPT disk is reserved for a "protective MBR" to make it possible to boot a BIOS-based machine.

Most popular bootloader on linux is **GRUB**. Others like LILO, SYSLINUX etc exists... 

### 3 - Kernel
Kernel needs a temporary filesystem with core essential drivers to load other drivers. The temporary filesystem used was **initrd** (initial ram disk). Nowadays we use **initramfs**, no need to locate initrd.

### 4 - init

Kernel locates init program and runs it.

Three kinds of init on Linux - System V init (sysv), Upstart, **Systemd**.


## Devices

### Sysfs (/sys)
A pseudo filesystem (logical fs). /sys differs from /dev since here we are concerned with viewing and managing the devices. All files in this directory are not Nodes, so we can't write to devices using those. 

Also, the paths here are too long for the same device that /dev and are not technology and vendor agnostic unlike /dev.

### udev (/dev)
Userspace /dev - All devices show up here as nodes/files. We can read or write to/from these files.

```txt
SCSI Devices:
/dev/sda - first hard drive
/dev/sda1 - first partition of first hard drive
/dev/sdb - second hard dfive

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
Every possible process related information is stored here by Kernel.


### lsscsi, lspic, lsusb, lshw
Listing various devices

### dd
Reads data from one device and writes to another.

```txt
$ dd if=/path/source of=/dev/sdb bs=1024
$ dd if=/home/pete/backup.img of=/dev/sdb bs=1M count=2

only first 2M is copied in second command
```

### Loadable Kernel Modules
Stored in .ko files (kernel object) which can then be loaded and removed from boot time loading.

```txt
$ lsmod

$ insmod full_path_to_module

$ modprobe module_name

$ rmmod module_name
$ rmmod -f module_name
```

If you need to load some modules every time your system boots do one of the following:
- add their name to this file `/etc/modules`
- add their config files to the `/etc/modprobe.d/`
