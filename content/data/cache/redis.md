+++
title = "Redis"
date =  2022-07-03T07:53:00+05:30
weight = 2
pre = "<i class='devicon-redis-plain colored'></i> "
+++

## About
Redis, which stands for **Remote Dictionary Server**, is a fast, open source, in-memory, key-value data store.

Main features:
- _in-memory_ (everything is stored on RAM for faster access)
- stores data as _key-value_ so its _non-relational_


Over the time it has added more features and data structures and now it has grown to be a full fledged data store that supports:
- other data structures such as strings, hashes, lists, sets, etc..
- built in replication, scripting (stored procedures), transactions, etc..
- on-disk persistence

We can use Redis as a cache, broker, queue, stream, and even as a primary database!

_Reference_: https://redis.io/docs/about


## Data Structures
Redis has 5 data structures: `STRING`, `LIST`, `SET`, `HASH`, and `ZSET` (sorted set). 

### String
Although they are stored as string literal (`""`), we can perform:
- operations on substring
- increment/decrement if it has an `integer` or `float` value inside the string
```txt
key1: value1
key2: value2
...
```
```sh
SET name Abhishek 	# or "Abhishek"

GET name
> "Abhishek"

KEYS *				# specify pattern
> "name"

SET marks 56		# overwrites
GET marks
> "56"

GET foo 			# fetching non-existing key
> (nil)

DEL name			# deletion

--------------------------------------------------
# increment/decrement on integer and float
SET marks 99		# integer string
INCR marks
GET marks
> "100"

SET marks 99
INCRBY marks 3
GET marks
> "102"

SET marks 99.8		# float string
INCRBYFLOAT marks 1	# no INCR command for float
GET marks
> "100.8"

SET marks 99.8
INCRBYFLOAT marks 0.2
GET marks
> "100"
```

### Hash
Contains key-value pairs but inside another hashkey.

Terminology is a bit confusing here. hashkey (`key`), key(`field`), and value (`value`).
```txt
hash-key1{
	field1: value1
	field2: value2
	...
}

hash-key2{
	field1: value1
	...
}
```
```sh
HSET student name Abhishek
HSET student country India

HGET student name
> "Abhishek"

HLEN student		# no. of fields in a hash
> (integer) 2

HKEYS student		# list all keys
> 1) "name"
> 2) "country"

----------------------------------------------------------
# numeric related commands works the same as with String:
# HINCR - for integer only
# HINCRBY - for integer only
# HINCRBYFLOAT - for float only
```

### List & Set
```txt
list-key1{ 
	item1
	item2
	...
}

list-key2{ 
	item1
	...
}
```

`SET` are same as a `LIST` but duplicate items aren't allowed. On addition, Set returns `1` if element is present already, `0` otherwise.

### Sorted Set
`ZSET` store key-value pairs but in a sorted order. Key (`member`) and value (`score`). Score can only be of type `float`.

```txt
zset-key1{
	member1: score1
	member2: score2
	...
}

zset-key2{
	member1: score1
	...
}
```

The scores are sorted by numeric value in ascending order and correpsonding members are also sorted by virtue of that.

```txt
marks{
	dinesh: 13
	richard: 50.5
	gilfoyle: 98
}
```

## Commands

_Quick Searchable Reference:_ https://redis.io/commands

## Disk Persistence
Redis can also write data to secondary storage (disk).

Two strategies can be employed for this:
1. point-in-time dump: either when certain conditions are met (a number of writes in a given period) or when one of the two dump-to-disk commands is called
2. append-only file: it writes every command that alters data in Redis to disk as it happens (aka [Write-Ahead Logging](/db/rdbms/postgresql/#write-ahead-logging-wal))

We can always disable this persistence to use Redis as a pure in-memory cache.

## References
- https://redis.com/ebook/redis-in-action