+++
title = "GRUB & Systemd"
date =  2022-09-15T22:53:00+05:30
weight = 3
+++

## GRUB
GRUB (GRand Unified Bootloader): Configurable bootloader program.

Versions:
- GRUB Legacy (1999)
- GRUB2 (2005): A complete rewrite of the legacy GRUB.


We can configure and show a menu-based system where you can **choose which Kernel or chainloader to boot**. It is also possible to edit the menus on the fly or **give direct commands from a command line, all _before_ booting into a Kernel**.

![GRUB menu image](https://i.imgur.com/y9m7zcc.png)

We can also configure splash logo, colors, etc... of the GRUB menu.

And of course, we can change Kernel startup parameters like which `systemd.unit` to keep as target, which `initramfs` to use, etc...

The GRUB configuration is possible by editing files in `/etc/grub.d` directory.

---
## Systemd
Hated because: doesn't store logs in text files and violates UNIX principles of KISS (keep it simple stupid) since it does many things beyond what is sufficient for a single tool. Most distros today use it anyways!

Made around **units**. A unit can be a service, an action, a group of service enabling a certain functionality on the system (**target**), etc...

It is **goal-driven**. It acheives a goal by loading a target, which in turn can also have dependencies (other targets or services) that needs to be loaded, so those dependencies are also loaded before the goal is declared "acheived".

Use `systemctl` command to config units and `journalctl` command for logs.

## Runlevels and Boot Targets
System V - Runlevels: stages in which the system can go into. Ex - Shutdown, single-user mode, reboot, etc...

Systemd - Boot targets: units that we can start, stop, configure to start after each other, etc...

Some Systemd boot targets:
```
poweroff.target 	- shutdown system
rescue.target 		- single user mode
multi-user.target 	- multiuser with networking
graphical.target 	- multiuser with networking and GUI
reboot.target 		- restart

The default boot goal of default.target usually points to the graphical.target
```