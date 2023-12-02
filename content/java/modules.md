+++
title = "Modules"
date =  2022-05-31T06:00:00+05:30
weight = 11
+++

## Modules
In Python, modules are `.py` files and we can put multiple such files into a folder having `__init__.py` file and call it a package.

In Java, multiple packages can be combined to form a module and such module must have a `module-info.java` file called Module Descriptor at its root directory.

Java 9 introduced JPMS (Java Platform Module System). Each module is created into a modular JAR. This allows data hiding for entire packages, while access modifiers allow data hiding on class level.

Modules follow naming conventions of packages and can have multiple periods (`.`), but no hyphens (`-`) are allowed.

```java
// module-info.java
module foo.bar{ }

// exports: exposing a package
module foo.bar{
	exports foo.bar.testpack;
}

// requires: using another module
module foo.bar{
	requires another.module;
}

// exports to: exposing a package to certain module only
module foo.bar{
	exports foo.bar.testpack to another.module;
}

// requires transitive: foo.bar requires newmod AND any module that requires (include) foo.bar will also automatically requires (include) newmod module
module foo.bar{
	requires transitive newmod;
}

// if requiresments don't exist then its a compiler error
// no two "requires/requires transitive" are allowed on same package name in the same module since its redundant


// opens: enables another module to call opened package via reflection
module foo.bar{
	opens foo.bar.testpack;
}
module foo.bar{
	opens foo.bar.testpack to another.module;
}

// open entire module
open module foo.bar.testpack { }
// no redundant open statements allowed inside now
```

Reference Code Link: https://github.com/boyarsky/sybex-1Z0-829-chapter-12, _Refer diagrams in Book too for clarity_

When we say we are exposing the packages to others means that only `public` members will be accessible along with `protected` ones if accessed from a subclass.

Most important module in Java is `java.base` which has Collection, Math, IO, concurrency, etc.. Other modules include `java.sql` (JDBC), `java.xml` (XML), `java.desktop` (AWT and Swing). It is automatically available to all modular applications and we need not write `require` for it explicitly. 

{{% notice info %}}
The Java team at Oracle took a huge job of making the JDK modular in version 9. The JDK used to be a monolith and they successfully separated every legacy packages into modules, making it modular since.
{{% /notice %}}

## Module Path vs Classpath
**Module Path** - It is a list of artifacts (JARs or bytecode folders) and directories that further contain artifacts.

```sh
# modules are in "app-jars" dir, initial module is "myModule"
$ java --module-path app-jars --module myModule
```

**Module Resolution**: Beginning with the initial module's name, Java will search the module path for it. If it finds it, it will check its `requires` directives to see what modules it needs and then repeats the process for them. The result of this process is the **Module Graph**.

Since Java 9, everything must be inside a module, so anything that is not on the module path, but on the **classpath** gets lumped into a single "unnamed module". This does not include unresolved modules.

Every resolved module is eventually put onto the _module graph_ along with the unnamed module.

## Types of Modules

1. **Named**: modules and modular JARs present on the module path and have a name specified in `module-info.java` file

2. **Automatic**: an automatic module is created for each "regular" JAR on the module path. Name specified in JAR's `META-INF/MANIFEST.MF` file by a property `Automatic-Module-Name: name_here`. If name isn't available from this property then Java creates the name by JAR's name by stripping version number, dashes (`-`), and any non-intermediate dot(`.`) characters. Ex - `test-app-1.0.2.jar` becomes `test-app` module.

3. **Unnamed**: stuff not on module-path but on the classpath gets lumped into an "unnamed module", this includes any modular JAR on the classpath as well! 

|   	|   Class Path	|   Module Path	|
|---	|---	|---	|
|  **Regular JAR** 	|   Unnamed Module	|  Automatic Module |
|  **Modular JAR** 	|   Unnamed Module	|  Named Module 	|

{{% notice note %}}
Unnamed module can read all exported packages in all modules (module path and unnamed). All packages of unnamed module are exposed since there is no `module-info.java` (module descriptor) present in it to retrict that. In case a modular JAR is placed into classpath, all restrictions imposed by its `module-info.class` loses value.

Named modules can't read unnamed module's contents, since there is no name to refer it with.

An automatic module has no module descriptor, hence they can read all other modules (even unnamed; `requires` is added implicitly for that). Also, anyone can read from the automatic modules provided they `requires` it in their module descriptor. This way, automatic modules act as a bridge from the module to the class path - its an explicit module on the module path but can read the unnamed module.
{{% /notice %}}

Use Case for Automatic Modules: place a legacy dependency JAR into the module path and it can access everything (unnamed and named) and everyone can read from it using `requires` it by name. Achieving modularity (sort of) with backwards compatibility.

## Notes and Demo
If we're using a framework like Spring Boot with a build tool like Maven, we don't need to bother about modules as they are handled internally by Maven. We need to take care of the only when we are building via the command-line which is very rare in production env.

Oracle - Modules in JDK 9: https://youtu.be/22OW5t_Mbnk

A good practical demo video on Basics: https://youtu.be/89tplxrXJTU

Another good video on Module types and Migration: https://youtu.be/6vb5EBY-4ww

Articles:
- https://dev.java/learn/modules/intro/
- https://dev.java/learn/modules/unnamed-module