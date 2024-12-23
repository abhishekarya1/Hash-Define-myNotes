+++
title = "I/O"
date =  2022-06-17T10:33:00+05:30
weight = 13
+++

## Basics & Terminology
**File**: Logical representational unit of actual system resources (an abstraction)

**Directory**: Collection of files and other directories

**File System**: Logical representation of **all** files and directories available in a system

**Path**: Represents location of a file or directory in the file system

**Root Directory**: The topmost directory of the system. In Windows, its `C:\` and in Linux its `/`.

**File Separator**: In Windows-based systems its `\` (backslash) and in Unix-based systems its `/` (forward slash). But paths with both kinds of slashes work on Windows but Linux is strict about its slash (`/)`.

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

File foo = new File("foo.txt");    // relative paths start at classpath root
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

Also, `/`(forward slash) and `\` (backslash) are interchangeably usable and `\\` (double slashes) are replaced by single slash by the compiler.

### Conversion b/w File and Path
```java
File file = new File("foobar");
Path nowPath = file.toPath();
File backToFile = nowPath.toFile();
```

### Operating on Files and Paths
```java
// commonly used methods on File
isDirectory()
getName()
getAbsolutePath()
getParent()			// get absoulute path of the parent directory
length()			// size in bytes
lastModified()
listFiles()			// List<> of all files in the current directory
```

Similar instance methods are available with `Path` too:
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

### Reading File Contents
Plethora of ways exist to read files. One of the most efficient being using the `BufferedReader`:

```java
// reading a File using BufferedReader
String fileName = "foo.txt";
try (BufferedReader reader = new BufferedReader(new FileReader(fileName))) {
    String line;
    while ((line = reader.readLine()) != null) {
        System.out.println(line);
    }
} catch (IOException e) {
    System.err.println("Error reading file: " + e.getMessage());
}
```

{{% notice info %}}
Always close streams to avoid _resource leaks_ and _locks_ either manually or create them in try-with-resources block so that they auto close.
{{% /notice %}}


## NIO
`java.io` package has the legacy IO API.

`java.nio` (New IO) was introduced in Java 1.4 and solved many issues with legacy IO.

Java 7 revamped `java.nio.file` package, commonly known as the **NIO.2** package. Adopted asynchronous approach to non-blocking IO not supported in previous version of the `java.nio` package.

### NIO.2 Files Utility Class
The `Files` utility class exclusively of static methods that operate on files, directories, or other types of files represented by `Path`. It doesn't take `File` as input, only `Path`.
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

## IO Streams
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

{{% notice note %}}
The `Serializable` interface is a _Marker Interface_, it doesn't have any methods or members, its empty.
{{% /notice %}}

All Java primitives, wrapper classes, and the String class are serializable. 

The `ObjectInputStream` and `ObjectOutputStream` classes can be used to read and write a Serializable object from and to an I/O stream, respectively.

{{% notice info %}}
Instance members marked `transient` are not serialized/deserialized by default, they take `null` or `0` default values when serialized/deserialized.

Also, `static` members of the class aren't serialized either as Serialization is only for non-transient instance members.
{{% /notice %}}

### Make a class Serializable
1. must implement `java.io.Serializable` interface
2. must have all instance members implementing `Serializable` interface or be marked `transient` (or `static`)

### Custom Serialization
We can customize serialization of instance members e.g. change values, encode/decode at serialization and deserialization etc. by adding `writeObject` and `readObject` methods in the serialization/deserialization classes.

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Student implements Serializable {
    private static final long serialVersionUID = 1L;		// version metadata

    private int id;
    private transient String name;		// transient member

    // custom serialization logic
    private void writeObject(ObjectOutputStream oos) {
        oos.defaultWriteObject();		// serialize the non-transient fields
        oos.writeObject(name != null ? name.toUpperCase() : null);		// serialize the transient field
    }

    // custom deserialization logic
    private void readObject(ObjectInputStream ois) {
        ois.defaultReadObject();		// deserialize the non-transient fields
        name = (String) ois.readObject();		// deserialize the transient field
    }
}

```

Note that we can even serialize/deserialize `transient` members as well in the custom logic in the methods above!

**What's `serialVersionUID` in the code above**? It acts as a version control for the class being serialized and deserialized, so that the sender and receiver both know which version of the class was used to create byte stream. This field is `static` but it is serialized by Java (only exception to the rule!)

```java
// version 1
public class Student implements Serializable {
    private int id;
    private String name;
}

// version 2 - modified the class's code and added another instance member
public class Student implements Serializable {
    private int id;
    private String name;
    private int age;
}

/*
Problem:
sender serializes from version1 class and if the receiver deserializes the byte stream to Student POJO class for version2 the value of "age" will be 0 (default) as it didn't exist while serializing.

Solution:
Version both of them by adding the field "serialVersionUID" with diff version nums - "1L" and "2L" and then a "InvalidClassException" will be thrown because class versions being serialized from doesn't match with the class version being deserialized to.
*/
```

### Externalizable Interface

**Serializable vs Externalizable Interfaces**: a class extending `Serializable` interface can be serialized/deserialized to/from `ObjectInputStream`/`ObjectOutputStream`. It is a Marker Interface so it doesn't have any methods.

`Externalizable` is a sub-interface of `Serializable` and also used for the same purpose. It is not a marker interface though. 

It has two methods (that we **must** implement unlike `Serializable` interface) where we can specify our custom logic after/before serialization/deserialization.

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Book implements Externalizable {
    private String author;
    private String title;
    private int price;

    @Override
    public void writeExternal(ObjectOutputStream out) {
        out.writeObject(author);
        out.writeObject(title);
        out.writeInt(price);
    }

    @Override
    public void readExternal(ObjectInputStream in) {
        this.author = (String) in.readObject();
        this.title = (String) in.readObject();
        this.price = in.readInt();
    }
}
```

The difference is just that the `Serializable` interface has a default behavior (skips `transient` members) and that makes it optional for the programmer to provide custom logic for serialization/deserialization. But if we implement `Externalizable` interface, we must implement logic for serialization/deserialization.
