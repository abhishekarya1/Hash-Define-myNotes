+++
title = "Libraries & Package Management"
date =  2022-09-21T00:21:00+05:30
weight = 5
+++

## Libraries

- **Static Linking**: Supplied as packaged with the software. Dependency management is difficult.
- **Dynamic Linking**: Shared libraries used by mutiple softwares. Centralised, better for upgrades. 

In Windows we have `DLL`s (Dynamic Linked Libraries), in Linux we have `libLIBNAME.so.VERSION` files. Ex - `libcurl.so.1.5.2`.

Storage directories: `/lib`, `/lib64`, `/usr/lib`, or `/usr/lib64`.

`ldd`: shows if a program is statically or dynamically linked, also lists all libraries that are linked to the program (if dynamic).

### Symbolic linking of libraries
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
**How to locate the libs?**: It is a common strategy to place libraries' paths in `/etc/ld.so.conf.d/*.conf` files, and a single config file `/etc/ld.so.conf` can include all those single `.conf` files.

Also, there exists a `ld.so.cache` file that contains symbolic links to all dynamically linked libraries on the system, so that we don't have to traverse `ld.so.config.d` everytime. 

Every software on the system reads this cache file to look for libraries. We use `ldconfig` command to manage this cache file.

```sh
ldconfig -p

# after editing the config file, run the command again to update the cache

ldconfig
```

### Lookup order for libraries
When a software needs a library, it looks it up in the following order:
1. LD_LIBRARY_PATH environment variable (env in which program is running)
2. Programs PATH
3. `etc/ld.so.conf` (which might load other libraries from `/etc/ld.so.cond.d`)
4. `/lib`, `/lib64`, `/usr/lib`, and `/usr/lib64`

---
## Package Management

**Package**: pre-compiled software

**Package management systems** exist to download, update, remove packages with CLI

**Repository**: Each distro has a pre-configured set of repositories from where it downloads the packages

In Debian based systems, packages are named as `NAME-VERSION-RELEASE_ARCHITECTURE.deb` and the sources list is stored in `/etc/apt/sources.list` file and `/etc/apt/sources.list.d/` directory.

### apt
Advanced Package Tool (APT)

```sh
apt-get update		# updates sources list only, no packages are updated

apt-get upgrade			# upgrade all installed packages

apt-get install package_1 package_2 package_3	# install; upgrade if already installed

apt-get install package_name=VERSION_NUMBER		# install specific version

apt-get remove pkg_name	# removing a package will not remove its dependencies and config files! (since it can be a shared dependency that maybe used by other programs) (also configs remain on the system)

apt-get purge pkg_name 	# remove a package and its config files

apt-get autoremove pkg_name	# remove unused dependencies of this package (dependencies that only this package used and no other package on the system uses) (doesn't remove config files)

apt-get autoremove	# remove all unused dependencies globally (for all packages)

apt search search_string	# search a package

apt show package	# get info about a package
```

### dpkg
The Debian Package Management System (dpkg) is used to perform low-level actions _on_ `.deb` packages. Show config, display status, show info, reconfigure, etc...

`apt` uses `dpkg` under the hood. Once apt downloads `.deb` package files, dpkg is used to perform actions on them.

### Other package managers
Debian based distros: apt, dpkg, aptitude

Red-Hat based: RPM (Red Hat Package Manager), YUM (Yellowdog Updater, Modified), DNF (Dandified Yum)

Arch based: Pacman

---
## Compression and Archival
Often times the programs in linux have a `.tar.gz` extension. 

`gzip` is a tool that can compress a _single_ file at a time.

`tar` is a tool that can create a archive containing multiple files.

If we combine those, we get a compressed tarball (`.tar.gz`). In order to extract the contents, we do the reverse, first unzip and then unpack.