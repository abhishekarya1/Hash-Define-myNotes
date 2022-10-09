+++
title = "Other Tools"
date =  2022-09-29T15:13:00+05:30
weight = 7
+++

## ssh
`ssh` command is used to connect to a remote machine using Secure Shell Protocol (default port is 22)

```sh
# generate asymmetric key pair (default is RSA)
$ ssh-keygen

$ ssh user@server

# specify a diff port
$ ssh root@192.168.1.5 -p 998

# run a command on remote server
$ ssh root@192.168.1.5 'ls -la'
````

`scp` (Secure Copy) command is used to transfer files to-and-fro between the server and client.

## Compression and Archival

### Zipping
`gzip` creates compressed file with `.gz` extension. It can only compress a **single file or directory** at a time.

```sh
$ gzip myfile 

# recursive; use on directories
$ gzip -r mydir

# decompress
$ gzip -d myfile.gz
$ gunzip myfile.gz
```

Upon compression, the file is **moved** to the compressed file (`.gz`). And on uncompression, the comressed (`.gz`) file is **deleted**.

Other tools like `bzip2` and `xz` can also be used. They are not _recursive_ though so they can't compress directories unlike `gzip`.

### Looking inside
`gzcat`, `bzcat`, `xzcat`, `zcat`

Used to print compressed file's content onto the terminal without uncompressing them.

### Archiving
`tar` `cpio`

We can put multiple files in a single one (called "archive").
```sh
# create tarball 
$ tar -cf myfile.tar foofile barfile

# extract tarball
$ tar -xf myfile.tar

# filter (compress/uncompress) with gzip, bzip upon achival/unarchival automatically
-z -b

# show archive content
-t

# show extracted content names in terminal
-v 

# add files to existing archive
-r 
```

It can work with tapes and drives too, so we need to specify that we're archiving files or directories using the `-f` flag. So this goes everytime we use this command under normal circumstances.

It doesn't remove the original file or archive upon archival or extraction respectively, unlike compression (`gzip`, `bzip2`, `xz`) tools above.

## Hashing
`md5sum` `sha256sum` `sha512sum`

```sh
# generate MD5 hash and write to a file
$ md5sum foo.txt > mysumfile

# check hash from generated file against file
$ md5sum -c mysumfile
```

```txt
$ cat mysumfile
63a684f882686068b5182c7eab91d359c180cfa644daf64977725c6857ee4aaa *foo.txt
```