+++
title = "Modules"
date =  2022-05-31T06:00:00+05:30
weight = 10
+++

## Modules
In Python, modules are `.py` files and we can put multiple such files into a folder having `__init__.py` file and call it a package.

In Java, multiple packages can be combined to form a module and such module must have a `module-info.java` file at its root.

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

// exports: exposing a package
module foo.bar{
	exports foo.bar.testpack;
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

Reference Code Link: https://github.com/boyarsky/sybex-1Z0-829-chapter-12

When we say we are exposing the packages to others means that only `public` members will be accessible along with `protected` ones if accessed from a subclass.

Most important module in Java is `java.base` which has Collection, Math, IO, concurrency, etc.. Other modules include `java.sql` (JDBC), `java.xml` (XML), `java.desktop` (AWT and Swing).

### Types of Modules
1. **Named**: name specified in `module-info.java` file
2. **Automatic**: no `module-info.java` file, name specified in JAR's `META-INF/MANIFEST.MF` file by a property `Automatic-Module-Name: name_here`. If name isn't available from this property then Java creates the name by JAR's name by stripping version number, dashes (`-`), and any non-intermediate dot(`.`) characters. Ex - `test-app-1.0.2.jar` becomes `test-app`.
3. **Unnamed**: classpath JARs with no need for a name, works like normal Java code, no packages are exposed to other modules unlike the abiove two

Code on the classpath can read from module path, but not vice-versa. Due to this reason the module path modules (named and automatic) are readable from everywhere but not unnamed ones as that isn't readable from other modules on the module path.