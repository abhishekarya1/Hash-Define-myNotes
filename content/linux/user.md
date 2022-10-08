+++
title = "User Mgmt & Permissions"
date =  2022-10-01T22:21:00+05:30
weight = 7
+++

## User Management
Every user is part of atleast one user group, it can be part of multiple groups at once too, but one of them will be a **primary group**. Every user has a **UID**, and every group has a **GID**.

`whoami` show username

`groups` show all groups current user is part of

`id` show UID, and GIDs for all groups current user is part of

**Important directories**:
- `/etc/sudoers` (file containing sudo users' info)
- `/etc/passwd` (conatains user info)
- `/etc/group` (contains group info)
- `/etc/shadow` (contains password details of users (encrypted))

`su <username>` (substitute user; root if blank) run commands as another user; need to provide password of the target user

`sudo` (superuser do) run command as root user; current user need to be added to `/etc/sudoers` beforehand

`useradd <username>` add a user

`userdel <username>` remove a user

`usermod -g groupname username` change user's primary group

`passwd <username>` change user password; if we are root, then we can change another user's password

## Permissions

```txt
r 	read
w 	write
x 	execute

- 	empty
```

### Understanding 
4 parts divided in groups of 3

```txt
d | rwx | r-x | r-x		  (file_type | owner user perm | owner group perm | other user perm)
```

_file_type_ above can be `-` (normal file) or `d` (directory). Other types can be - `l` (link), `b` (block), `p` (pipe), `c` (character), and `s` (socket).

### Changing
`chmod` (change mode) (`o` = other, `u` = user, `g` = group, `a` = all)
```txt
$ chomod u+r myfile 		adding r permission for the current user only
$ chmod ug+x myfile			adding x permission for the current user and for whole group
$ chmod +x myfile           adding x permission for the current user only
$ chmod a-r myfile 			removing r permission for all users, groups and others
$ chmod g=rx myfile 		sets rx in group permission and removes write permission


-R 		to recursively change permissions (for all files and dir inside a dir)
```

**Octal Codes**: 
```txt
$ chomod 755 myfile

(7 = 4+2+1 = user, 5 = 4+1 = group, 5 = other)

4: read permission
2: write permission
1: execute permission
0: empty permission
```

### Changing Ownership
A file or directory's ownership matters because the user and group permissions that are applied on it specify how the user and group that owns it, accesses it.

`chown <username> myfile`

`chgrp <groupname> myfile`

`chown <username>:<groupname> myfile` (combined form of the above two)