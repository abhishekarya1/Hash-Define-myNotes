+++
title = "I/O"
date =  2022-06-17T10:33:00+05:30
weight = 12
+++

## Basics & Terminology
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

// in NIO.2 methods are called on "Files" static class and supplying path's instance to the method
```

## NIO
### NIO.2 Path Operations

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

### Operations on files
```txt
Files.createDirectory(p) 			-- mkdir
Files.createDirectories(p1, p2) 	-- mkdir -p
Files.copy(p1, p2) 					-- cp (creates shallow (non-recursive) copy just like in Unix)
Files.move(p1, p2) 					-- mv
Files.delete(p)						-- dir must be empty; error if non-existing
Files.deleteIfExists(p)				-- dir must be empty; returns true otherwise false
Files.isSameFile(p1, p2)			-- check if same file/dir; follows symlinks
Files.mismatch(p1, p2)				-- checks contents of two files like diff command
```
## I/O Streams
- **Byte Streams**: reads/writes as bytes (ends with `InputStream` and `OutputStream`)
- **Character Streams**: reads/writes as single chars (ends with `Reader` and `Writer`)

Besides this we can also divide streams into the following two categories based on their input:
- **Low-level Streams**: deals directly with raw data like array, file, or String. Ex - `FileInputStream` reads directly from file one byte at a time.
- **High-level Streams**: deals with other wrapper objects only. Ex - `BufferedReader` uses `FileReader` as input.

```java
FileInputStream
FileOutputStream
FileReader
FileWriter

// similarily for - BufferedInputStream, ObjectInputStream, etc...

// exceptions in naming
PrintStream
PrintWriter
```

Better way to deal with these are with NIO's `Files` helper class:
```java
String string = Files.readString(input);

Files.writeString(output, string);

byte[] bytes = Files.readAllBytes(input);

Files.write(output, bytes);

List<String> lines = Files.readAllLines(input);		// loads whole file in memory; returns a List; can lead to OutOfMemoryError

Stream<String> s = Files.lines(path);	// loads lazily; line-by-line processing; returns a Stream

var reader = Files.newBufferedReader(input);
var writer = Files.newBufferedWriter(output);
```

## Serializing Data

- **Serialization**: object to byte stream
- **De-serialization**: byte stream to object

A class is considered serializable if it implements the `java.io.Serializable` interface and contains instance members that are either serializable or marked `transient`. 

All Java primitives and the String class are serializable. 

The `ObjectInputStream` and `ObjectOutputStream` classes can be used to read and write a Serializable object from and to an I/O stream, respectively.

{{% notice info %}}
Instance members marked `transient` are not serialized/deserialized, they take `null` or `0` default values when serialized/deserialized.
{{% /notice %}}

**Make a class Serializable**:
1. must implement `java.io.Serializable` interface
2. must have all instance members as either `implements Serializable` or `transient`
