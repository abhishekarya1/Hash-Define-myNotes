+++
title = "Libraries & Package Management"
date =  2022-09-21T00:21:00+05:30
weight = 4
+++

## Libraries

- **Static Linking**: Supplied as packaged with the software. Dependency management is difficult.
- **Dynamic Linking**: Shared libraries used by mutiple softwares. Centralised, better for upgrades. 

In Windows we have `DLL`s (Dynamic Linked Libraries), in Linux we have `libLIBNAME.so.VERSION` files. Ex - `libcurl.so.1.5.2`.

Storage directories: `/lib`, `/lib64`, `/usr/lib`, or `/usr/lib64`.

`ldd`: shows if a program is statically or dynamically linked, also lists all libraries that are linked to the program (if dynamic).

## Symbolically linked libraries
We often have one library pointing to another like `libudev.so.1 -> libudev.so.1.4.0`. So if a software uses the former, it will implicitly use the latter.

We can use `ls -l` to check symbolic links.

```txt
$ ls -la /lib/i386-linux-gnu/libudev.so.1
lrwxrwxrwx 1 root root    16 Nov 13 23:05 /lib/i386-linux-gnu/libudev.so.1 -> libudev.so.1.4.0
```

### Dynamic library configs and cache
```txt
$ cat /etc/ld.so.conf
include ld.so.conf.d/*.conf

$ ls /etc/ld.so.conf.d/
llvm13-x86_64.conf  pipewire-jack-x86_64.conf

$ cat /etc/ld.so.conf.d/llvm13-x86_64.conf
/usr/lib64/llvm13/lib
```

Its a common strategy to place config in `/etc/ld.so.conf.d/*.conf` files, and a single config file `/etc/ld.so.conf` can include all those single `.conf` files.


Also, there exists a `ld.so.cache` file that contains all the symbolic links for all dynamically linked libraries on the system. We use `ldconfig` command to list them.

```sh
ldconfig -p

# upon cache updation, run the command again

ldconfig
```

## Package Management