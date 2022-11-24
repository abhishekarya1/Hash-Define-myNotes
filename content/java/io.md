+++
title = "I/O"
date =  2022-06-17T10:33:00+05:30
weight = 12
+++

**File**: Logical representational unit of actual system resources (an abstraction)

**Directory**: Collection of files and other directories

**File System**: Logical representation of **all** files and directories available in a system

**Path**: Represents location of a file or directory in the file system

**Root Directory**: The topmost directory of the system. In Windows, its `C:\` and in Linux its `/`.

**File Separator**: In Windows-based systems its `\` (backslash) and in Unix-based systems its `/` (forward slash).

```java
System.out.print(System.getProperty("file.separator"));		// prints "\" on Windows
```

```txt
absolute paths - C:\A\B\C\foo.text

relative paths - \B\foo.txt
				 .\foo.txt
				 ..\bar.txt

symbolic links - only supported by NIO.2 and not legacy IO
	if "a/b" and "z" have symbolic linking, both of the below are interchangeable:				 
	a/b/c/foo.txt
	z/c/foo.txt
```

## File and Path
They both represent file or directory on disk and are inter-convertible with each other. 

`File` comes from `java.io` package (_legacy_), and `Path` or `Paths` comes from `java.nio` package (_better_). 

```java
File fooFile1 = new File("/home/foo/data/bar.txt");
File fooFile2 = new File("/home/foo", "data/bar.txt");		// varargs supported

File foo = new File("/home/foo");
File fooFile3 = new File(foo, "data/bar.txt");

System.out.println(fooFile1.exists());	// to check if file exists on the disk
```

`Path` and `Paths` are interfaces and we use `static` methods to provide path. They are immutable just like `String`.
```java
// Path
Path fooPath1 = Path.of("/home/foo/data/bar.txt");
Path fooPath2 = Path.of("/home", "foo", "data", "bar.txt");		// varargs supported

// Paths
Path fooPath3 = Paths.get("/home/foo/data/bar.txt");
Path fooPath4 = Paths.get("/home", "foo", "data", "bar.txt");

System.out.println(Files.exists(fooPath1));		// checking existance with static method
```

Notice that `foo.txt` can be a file or a directory too, even though it has a file extension.

Also, `/`(forward slash) and `\` (backslash) are interchangeably useable and `\\` (double slashes) are replaced by single slash by the compiler.

### Conversion b/w File and Path
```java
File file = new File("foobar");
Path nowPath = file.toPath();
File backToFile = nowPath.toFile();
```

### Operating on Files and Paths
```java
// commonly used methods on File and Path(s)
isDirectory()
getName()
getAbsolutePath()
getParent()			// get absoulute path of the parent directory
length()			// size in bytes
lastModified()
listFiles()			// List<> of all files in the current directory

// in NIO.2 methods are called on "Files" static class 
```

## NIO.2 Path Operations

```java
Path path = Paths.get("/land/hippo/harry.happy");
System.out.println("The Path Name is: " + path);
for(int i = 0; i < path.getNameCount(); i++)
	System.out.println(" Element " + i + " is: " + path.getName(i));

/*
The Path Name is: /land/hippo/harry.happy
 Element 0 is: land
 Element 1 is: hippo
 Element 2 is: harry.happy
*/


// getting path vars (zero-indexed)
path.subpath(1, 2);		// hippo
path.subpath(1, 3);		// hippo/harry
path.subpath(4, 7); 	// IllegalArgumentException; invalid indices
```

### Resolve, Relativize, Normalize
**Resolve** - concatenate any path with a relative path or a string

`Path resolve(Path p)`

`Path resolve(String s)`

```java
Path path1 = Path.of("/cats/../panther");
Path path2 = Path.of("food");

System.out.println(path1.resolve(path2));

// Output: /cats/../panther/food


Path path3 = Path.of("/turkey/food");

System.out.println(path3.resolve("/tiger/cage"));

// Output: /tiger/cage
// no concat happened because input to resolve() method was absolute
```

**Relativize**: Make two paths relative to each other; both need to be absolute or both relative
```java
var path1 = Path.of("fish.txt");
var path2 = Path.of("friendly/birds.txt");

System.out.println(path1.relativize(path2));
System.out.println(path2.relativize(path1));

/* Output:

../friendly/birds.txt
../../fish.txt

*/


Path path1 = Paths.get("/primate/chimpanzee");		// absolute
Path path2 = Paths.get("bananas.txt");				// relative

path1.relativize(path2); // IllegalArgumentException
```

**Normalize**: remove unnecessary redundancies in the path
```java
var p1 = Path.of("./armadillo/../shells.txt");
var p2 = Path.of("foo/bar");
System.out.println(p1.normalize());   // shells.txt
System.out.println(p2.normalize());   // foo/bar (already normalized)
```

### File Operations with NIO
```txt
Files.createDirectory() 		-- mkdir
Files.createDirectories() 		-- mkdir -p
Files.copy() 					-- cp (creates shallow (non-recursive) copy just like in Unix)
Files.move() 					-- mv
Files.delete()					-- dir must be empty; error if non-existing
Files.deleteIfExists()			-- dir must be empty; returns true otherwise false
```
