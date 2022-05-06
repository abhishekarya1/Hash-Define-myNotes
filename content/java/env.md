+++
title = "Environment"
date =  2022-05-04T00:58:00+05:30
weight = 1
+++

## About

Java is both a programming language and a platform.

Created by James Gosling at Sun Microsystems (now subsidiary of Oracle Corp). Java 1.0 released in 1996. Originally named "Greentalk", later "Oak" and later Java.

Conceptualised for creating browser animations and graphics in form of applets. Failed to entice programmers for that purpose, was clunky, complex, and security was horrible since user had to download applet code on their machine to run it.

Open-source, maintained by Oracle Corp. Releases are prolific since 2018, releases new versions twice per year! 

Last major update - Java 8 (2014)

LTS releases - Java 11, 18

Java has 4 platforms:
1. **Java SE** - Standard Edition (Standard language features)
2. **Java EE** - Enterprise Edition (Servlet, JSP, Web Services, EJB, JPA, etc...)
3. **Java ME** - Micro Edition (mobile applications, often clients of Java EE server) (subset of Java SE)
4. **Java FX** (rich internet applications, often clients of Java EE server)

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

javac - generates object code (aka Byte code) in `.class` files.

Java Virtual Machine. Converts bytecode to native machine-specific code and runs (interprets) it.

JVM has to be written for the system for which it is to run on, so its **not platform independent**. The bytecode is machine architecture agnostic though since it always runs on JVM.

**JVM is multi-threaded**

**Method and Heap areas share the same memory for multiple threads, the data stored here is not thread safe**. Stack, PC Register, and Native areas are different for each thread.

Very Imp - https://www.freecodecamp.org/news/jvm-tutorial-java-virtual-machine-architecture-explained-for-beginners/


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

## References
- JavaNotesForProfessionals.pdf (Chapter 169, Appendix B)
- https://www.ibm.com/cloud/blog/jvm-vs-jre-vs-jdk