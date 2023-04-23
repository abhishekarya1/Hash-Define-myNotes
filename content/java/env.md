+++
title = "Environment"
date =  2022-05-04T00:58:00+05:30
weight = 1
+++

## About

Java is both a programming language and a platform.

Created by James Gosling in 1995 at Sun Microsystems (now subsidiary of Oracle Corp). Java 1.0 released in 1996. Originally named "Greentalk", later "Oak" and later Java.

Conceptualised for creating browser animations and graphics in form of applets. Failed to entice programmers for that purpose, was clunky, complex, and security was horrible since user had to download applet code on their machine to run it.

Open-source, maintained by Oracle Corp. Releases are prolific since 2018, releases new versions twice per year! 

Last major update - Java 8 (2014)

LTS releases - Java 11, 18

Java has 4 platforms:
1. **Java SE** - Standard Edition (Standard language features)
2. **Java EE** - Enterprise Edition (Servlet, JSP, Web Services, EJB, JPA, etc...)
3. **Java ME** - Micro Edition (mobile applications, often clients of Java EE server) (subset of Java SE)
4. **Java FX** (rich internet applications, often clients of Java EE server)

[The Java Language Environment: A White Paper](https://www.stroustrup.com/1995_Java_whitepaper.pdf) - James Gosling, Sun (1996) ([web version](https://www.oracle.com/java/technologies/language-environment.html))
[Java Developer Productivity Report 2022 - YouTube](https://youtu.be/qG1TXxxZXjU)

## Components
### JRE
Java Runtime Environment (Libraries + JVM). Required to run Java applications. Libraries include JDBC, etc...

### JDK
Java Development Kit (Dev Tools + JRE).

```txt
Some tools that are available: 

java  	- interpreter
javac 	- compiler
javap 	- disassembler
jdb	  	- debugger
jar   	- archiver
javadoc - documentation generator
```

### JVM

`javac` compiler - generates object code (aka Byte code) in `.class` files.

Java Virtual Machine. Converts bytecode to native machine-specific code and runs (interprets) it.

JVM has to be written for the system for which it is to run on, so its **not platform independent**. The bytecode is machine architecture agnostic though since it always runs on JVM.

**JVM is multi-threaded** ofc since it allows thread execution with separate data areas (stacks, PC registers, native method stack) for each thread.

**Method and Heap areas share the same memory for multiple threads, the data stored here is not thread safe**. Stack, PC Register, and Native areas are different for each thread.

Must Read - https://www.freecodecamp.org/news/jvm-tutorial-java-virtual-machine-architecture-explained-for-beginners/

### JIT Compiler
**Interpreter ❤️ JIT Compiler** - The interpreter always interprets/runs the bytecode, and simultaneously the JIT compiler compiles some methods based on their invocation count threshold to _native machine code_ to be called directly by the interpreter. These methods are also called hotspots and are identified by the profiler inside the JIT compiler. 

_Reference_: [Highlight Link](https://www.eclipse.org/openj9/docs/jit/#:~:text=The%20JIT%20compiler%20doesn%27t,rather%20than%20interpreting%20it.)

JVM contains two conventional JIT-compilers: the **client compiler (C1)** and the **server compiler ("opto" or C2)**.

C1 is designed to run faster and produce less optimized code, while C2 takes a little more time to run but produces a better-optimized code. The client compiler is a better fit for desktop applications since we don't want to have long pauses for the JIT-compilation. The server compiler is better for long-running server applications that can spend more time on the compilation. Java uses both JIT compilers during the normal program execution.

The default strategy used by the HotSpot, called [tiered compilation](https://www.baeldung.com/jvm-tiered-compilation) is to compile the frequently called methods in the bytecode using C1 compiler and if the number of calls keep increasing, it uses the C2 compiler. 

C2 has been extremely optimized and produces code that can compete with C++ or be even faster. The server compiler itself is written in a specific dialect of C++. However, it comes with some issues. Due to possible segmentation faults in C++, it can cause the VM to crash. Also, no major improvements have been implemented in the compiler over the last several years. The code in C2 has become difficult to maintain, so we couldn't expect new major enhancements with the current design.

We have projects like [GraalVM](#graalvm) for new and better approaches to compiling Java code.

## Running 
### javac, java
```sh
$ javac Hello.java
$ java Hello

#OR -> if single file only (notice .java extension):
$ java Hello.java
```

### jshell
Tool to use Java via command line. Introduced in Java 9.

```sh
$ jshell

jshell> int a = 5;

jshell> /exit
```

## The JDK
Many open-source as well as proprietary JDK alternatives have popped up over the years. Most popular ones are OracleJDK, OpenJDK, and Amazon Corretto.

OpenJDK is developed by Oracle, OpenJDK, and the Java Community together. However, top-notch companies like Red Hat, Azul Systems, IBM, Apple Inc., and SAP AG also take an active part in its development.

OracleJDK is solely developed by the Oracle Corporation. It has some additional libraries and licence differences with OpenJDK.

Actually, OpenJDK is an official reference implementation of a Java SE since long time now. It means that it is the accepted official implementation of the Java specification and OracleJDK's as well as all other JDKs' build process is based on that of OpenJDK.

**HotSpot VM**: The default JVM's name! It was named at Sun Microsystems in 1999. 

### GraalVM
It is basically another hot and popular JDK project created by Oracle. It has the following components:
- HotSpot VM
- Graal JIT Compiler
- Ahead-of-time compilation (AOT) (Native image)
- Polyglot API (Truffle)
- many other dev tools...

**Features**:
- high-performance (_Graal compiler_) - resolves the C2 being old and unmaintainable problem
- create native platform executable eliminating the need for JVM (_AOT (Native Image)_)
- run Javascript, Python, Ruby, R, WASM, etc... on JVM! (_Truffle Language Implementation Framework_)

_Architecture_: https://www.graalvm.org/22.1/docs/introduction/

_Graal JIT Compiler_: https://www.baeldung.com/graal-java-jit-compiler

_Java Benchmarks_: https://www.phoronix.com/scan.php?page=article&item=java-openjdk-mid22


### JVM Languages
Many other languages can prodcue Bytecode that is runnable on JVM.

Popular ones are - Kotlin, Groovy, Scala, Clojure.

## References
- JavaNotesForProfessionals.pdf (Chapter 169, Appendix B)
- https://www.ibm.com/cloud/blog/jvm-vs-jre-vs-jdk