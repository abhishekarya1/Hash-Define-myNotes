+++
title = "User Mgmt & Permissions"
date =  2022-10-01T22:21:00+05:30
weight = 7
+++

## User Management
Every user is part of atleast one user group, it can be part of multiple groups at once too. Every user has a _UID_, and every group has a _GID_.

**Important directories**:
- `/etc/sudoers` (file containing sudo users' info)
- `/etc/passwd` (conatains user info)
- `/etc/group` (contains group info)
- `/etc/shadow` (contains password details of users (encrypted))

`su <username>` (substitute user; root if blank) run commands as another user; need to provide password of the target user

`sudo` (superuser do) run command as root user; current user need to be added to `/etc/sudoers` beforehand

`sudo useradd <username>` add a user

`sudo userdel <username>` remove a user

`sudo usermod -g groupname username` change user's primary group

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
d | rwx | r-x | r-x		  (file_type | user perm | group perm | other user perm)
```

_file_type_ above can be `-` (file) or `d` (directory).

### Changing
`chmod` (change mode) (`o` = other, `u` = user, `g` = group, `a` = all)
```txt
$ chomod u+r myfile 		adding r permission for the current user only
$ chmod ug+x myfile			adding x permission for the current user and for whole group
$ chmod +x myfile           adding x permission for the current user only
$ chmod a-r myfile 			removing r permission for all users, groups and others
$ chmod g = rx myfile 		sets rx in group permission and removes write permission
```

**Numeric Format**: 
```txt
$ chomod 755 myfile

(7 = 4+2+1 = user, 5 = 4+1 = group, 5 = other)

4: read permission
2: write permission
1: execute permission
0: empty permission
```

### Changing Ownership

`sudo chown <username> myfile`
`sudo chgrp <groupname> myfile`

`sudo chown username:groupname myfile` (combined form of the above two)