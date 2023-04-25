+++
title = "Modules"
date =  2022-05-31T06:00:00+05:30
weight = 10
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

### Types of Modules

All code on the classpath lives in an "unnamed" module and can access pretty much everything else, even other modules. Wheareas modules live on their own "named" module paths and we have to `require` or `export` them and describe dependencies on each other.

1. **Named**: name specified in `module-info.java` file, its on module path
2. **Automatic**: its a JAR file placed in module path, no `module-info.java` file, name specified in JAR's `META-INF/MANIFEST.MF` file by a property `Automatic-Module-Name: name_here`. If name isn't available from this property then Java creates the name by JAR's name by stripping version number, dashes (`-`), and any non-intermediate dot(`.`) characters. Ex - `test-app-1.0.2.jar` becomes `test-app`.
3. **Unnamed**: it is also a JAR file but in classpath with no need for a name, works like normal Java code, no packages are exposed to other modules unlike the above two

Code on the classpath can read from module path, but not vice-versa. Due to this reason the module path modules (named and automatic) are readable from everywhere but not unnamed ones as that isn't readable from other modules on the module path.

### Notes and Demo
If we're using a framework like Spring Boot with a build tool like Maven, we don't need to bother about modules as they are handled internally by Maven. We need to take care of the only when we are building via the command-line which is very rare in production env.

Oracle - Modules in JDK 9: https://youtu.be/22OW5t_Mbnk

A good demo video: https://youtu.be/89tplxrXJTU