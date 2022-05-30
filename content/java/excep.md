+++
title = "Exceptions"
date =  2022-05-15T09:38:00+05:30
weight = 7
+++

## Exceptions vs. Errors
Exceptions and errors are deviant behaviour from the correct one. Exceptions can be **checked** (expected) or **unchecked** (not expected) and errors are usually non-recoverable JVM errors.

{{<mermaid>}}
graph TB;
    A[java.lang.Throwable]
    A --> B(java.lang.Exception)
    A --> C(java.lang.Error)
    B --> D(java.lang.RuntimeException) 
{{< /mermaid >}}

`java.lang.Throwable` parent class of all exceptions in Java.

**Checked Exceptions**: All subclasses of `java.lang.Exceptions` except `java.lang.RuntimeException`

**Unchecked Exceptions**: `java.lang.RuntimeException`

We can handle all but good practice not to handle or declare _unchecked exceptions_ and _errors_.

## Checked Exceptions
Java follows the principle of **handle or declare** when it comes to checked exceptions. So we either use `catch` block to handle or declare in method.

### throws
**Method declaration**: Declare all expected exceptions in the declaration and no need to handle them inside that method. The parent method must also either declare or handle.

```java
void foo() throws IOException{		// declare in calling method
	bar();
}

void bar() throws IOException{ }

------------------------------------------------------------------

void foo(){
	try{
		bar();
	}
	catch(IOException e){ }			// catch in calling method
}

void bar() throws IOException{ }
```

**Overriding**: An overriding method (subclass) can declare fewer exceptions than those already declared by the overriden method (superclass). In simple words, we can't add more **checked** exceptions to subclass method, **but can add unchecked ones and subclass of exception declared in superclass method**.
```java
class A{
	void foo() throws IOException{ }
}

class B extends A{
	voif foo(){ }		// valid
}

------------------------------------------------------------------

class A{
	void foo() throws IOException{ }
}

class B extends A {
	voif foo() throws IOException, SQLException{ }		// invalid
}
``` 

Since the exceptions list are inherited by subclass, we can't add more because the overriden method can be called from parent reference and it won't expect the new error introduced in subclass method and catch can be written without it. **Overriding replaces method on both references but it's done at runtime** so it can't be identified at compile-time and below issue will not be flagged:

```java
class A{
	void foo(){ }
}

class B extends A {
	voif foo() throws IOException{ }
}

public static void main(String args[]){
A obj = new B();
obj.foo();		// valid; class A declared no exceptions so need to catch or declare any

B obj2 = new B();
obj2.foo();		// invalid; have to handle or declare IOExcpetion
}
```

### throw
Since exceptions are classes, alwways use `new` to throw.
```java
throw new SQLException();	// valid
throw SQLException();		// invalid
```

We can pass an optional message into exception's constructor.
```java
throw new SQlException("lorem ipsum dolor sit amet");
```

`throw` can lead to unreachable code causing compiler error.

```java
try{
	throw new SQLException();
	throw new IOException();	// unreachable code, compiler error
}
```

### Printing an exception
```java
catch (Exception e){
	System.out.println(e);
	System.out.println(e.getMessage());
	System.out.println(e.printStackTrace());
}
```

## Handling (try-catch)
`try` must have atleast a single `catch` or a `finally`.

One `try` can have multiple `catch` (beware of unreachable ones).

```java
try{	}
catch(Exception	e){	}
finally{	}
```

**catch block chaining**: Super class is allowed only after more specific ones because there may be exceptions to be caught that may not belong to subclass `catch` block but will be caught by superclass `catch` block.

```java
catch(IOException e){ }		// subclass
catch(Exception e){ }		// superclass; valid

catch(Exception e){ }		// superclass
catch(IOException e){ }		// unreachable code
```

**Multi-catch block**: Separated by `|` cahracter, only a single object `e` of either. Can't have related classes.
```java
catch(Exception1 | Exception2 | Exception3 e){	}
catch(FileNotFoundException | IOException e){	}	// invalid; FileNotFoundException is subclass of IOException
```

## finally
Executes once, always. Even when there is a `return` inside `try` or `catch`.
```java
class A{
    static int foo(){
      try{
          return 1;
      }
      catch(Exception e){
          return 2;
      }
      finally{
          return 3;
      }
    }
}

public class MyClass {
    public static void main(String args[]) {
      System.out.println(A.foo());				// prints 3
    }
}
```

**NOTE**: There is only one case when `finally` doesn't execute, that is when we use `System.exit()`.

## try-with-resources
```java
try(var f = new File("my.txt")){	}
```

We can open resources in try and they get destroyed after `try` gets over. This destruction takes place as soon as `try` gets over and any `finally` will execute after that. Also, **the resources are closed in the reverse order in which they were created**.

```java
try(var f = new File("my.txt"); var x = new File("foo.txt");){	}	// last semicolon is optional
// implicit finally; resources closed in reverse order of creation

catch(Exception e){	}	// optional catch unlike normal try

finally{ }
```

```java
try(var f = new File("my.txt"), var x = new File("foo.txt")){	}	// compiler-error; no comma for separator allowed
```

### Closeable and AutoCloseable
Only classes that implement `Closeable` and `AutoCloseable` can be used with `try-with-resources`. Only difference is that `Closeable`'s `close()` method declares `IOException` and `AutoCloseable`'s `close()` declares `Exception`.  

### Final Resources
Resources can be created outside `try` and used inside but they need to be final or effectively final. They are closed in the reverse order of declaration in try block though.
```java
final var f = new File("foo.txt");
var b = new File("bar.txt");

try(f; var l = new File("lorem.txt"); b){	}

/* closing order: 
	bar.txt
	lorem.txt
	foo.txt
*/
```

The above code fails if the resource `b` is not effectively final throughout the scope.
```java
final var f = new File("foo.txt");
var b = new File("bar.txt");

try(f; var l = new File("lorem.txt"); b){	}	// compiler-error

b = null;		// b modified; so not effectively final
```

## Suppressed Exceptions
If two exceptions are thrown, the first one is treated as a primary one while all others following it are suppressed and put into a `Throwble[]` array.
```java
class All implements AutoCloseable{
    public void close(){
        throw new NullPointerException("bar");
    }
}
public class MyClass {
    public static void main(String args[]) {
        try(var f = new All()){
            throw new ArithmeticException("foo");
        }
        catch(Exception e){
            System.out.println(e);
            for(Throwable t : e.getSuppressed())
                System.out.println(t.getMessage());
        }
    }
}

/*
java.lang.ArithmeticException: foo
bar
*/
```

Primary Exception - ArithmeticException ("foo")

Suppressed Exception(s) - NullPointerException ("bar") on `close()` method call after `try-with-resources`

### Lost Exceptions with finally
Any exception thrown in `fianlly` block will hide every other prior exceptions. This is a bad Java behaviour and exists only for backward compatibility.
```java
class All implements AutoCloseable{
    public void close(){
        throw new NullPointerException("bar");
    }
}
public class MyClass {
    public static void main(String args[]) {
        try(var f = new All()){
            throw new ArithmeticException("foo");
        }
        finally{throw new NullPointerException("lorem");}
    }
}

/*
Exception in thread "main" java.lang.NullPointerException: lorem
	at MyClass.main(MyClass.java:11)
*/
```