+++
title = "Exceptions"
date =  2022-05-15T09:38:00+05:30
weight = 7
+++

## Exception vs. Error
Exceptions and errors are deviant behaviour from the correct one. Exceptions can be **checked** (expected) or **unchecked** (not expected) and errors are usually non-recoverable JVM errors (not expected).

{{<mermaid>}}
graph TB;
    A[java.lang.Throwable]
    A --> B(java.lang.Exception)
    A --> C(java.lang.Error)
    B --> D(java.lang.RuntimeException) 
{{< /mermaid >}}

`java.lang.Throwable` parent class of all exceptions in Java.

**Checked Exceptions**: All subclasses of `java.lang.Exceptions` except `java.lang.RuntimeException`

**Unchecked Exceptions**: All subclasses of `java.lang.RuntimeException`

We can handle all of them with `catch` blocks but good practice not to handle or declare _unchecked exceptions_ and _errors_.

## Checked Exceptions
Java follows the principle of **handle or declare** when it comes to **checked exceptions**. So we either use `catch` blocks to handle or declare after containing method's signature.

### throw
Since exceptions are classes, always use `new` to throw.
```java
throw new SQLException();   // valid
throw SQLException();       // invalid
```

We can pass an optional message into exception's constructor.
```java
throw new SQlException("lorem ipsum dolor sit amet");
```

`throw` can lead to unreachable code causing compiler-error.

```java
try{
    throw new SQLException();
    System.out.println("Hello!")    // unreachable code, compiler error
}
```

### throws
**Method exception declaration**: Declare all expected (**Checked only**) exceptions in the declaration and no need to handle them inside that method. The parent method must also either declare or handle (aka **Propagation**).

```java
void foo() throws IOException{		// declare in calling method too
	bar();
}

void bar() throws IOException{ }

------------------------------------------------------------------

void foo(){         // no propagation req since we handled it inside method body
	try{
		bar();
	}
	catch(IOException e){ }			// catch in calling method (handle)
}

void bar() throws IOException{ }
```

```java
// we don't need to handle-or-declare Unchecked Exceptions or Errors

void fun(){         // no declaration or handling req
    throw new RuntimeException();
}
```
```java
// we can declare with "throws" even if method body doesn't throw the exception but we will need to handle or declare in calling method

void foo() throws IOException{ }

void bar() throws IOException{       // declare (propagate)
// try{         
    foo();
// }
// catch(IOException e){ }      // or handle
}
```

**Overriding**: An overriding method (subclass) can declare fewer exceptions than those already declared by the overriden method (superclass). In simple words, we can't add more **checked** exceptions to subclass method, **but can add unchecked ones and subclass of exception declared in superclass method**.
```java
class A{
	void foo() throws IOException{ }
}

class B extends A{
	void foo(){ }		// valid
}

------------------------------------------------------------------

class A{
	void foo() throws IOException{ }
}

class B extends A {
	voif foo() throws IOException, SQLException{ }		// invalid
}
``` 

Since the exceptions list are inherited by subclass, we can't add more because the overriden method can be called from parent reference and it won't expect the new error introduced in subclass method and catch can be written without it. 

Below security issue will ensue if we allow a subclass method to add exceptions to list during compile-time:

```java
class A{
	void foo(){ }
}

class B extends A {
	void foo() throws IOException{ }       // compiler-error; but lets suppose this is valid

    public static void main(String args[]){
        super.foo();		// no handling required; class A declared no exceptions so need to catch or declare any; this is a security lapse

        B obj = new B();
        obj.foo();		   // have to handle or declare IOException due to this line
    }
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

## Handling (try-catch-finally)
Each `try` must have atleast a single `catch` **OR** a `finally` block.

```java
try{	}
catch(Exception	e){	}   // exception must be getting thrown in the try block
finally{	}

------------------------

try{    }
catch(Exception e){ }   // exception must be getting thrown in the try block

------------------------

try{    }
finally{    }
```

If a **particular exception is never thrown in try block**, we can't write `catch` for it:
```java
try{ }                       // empty try block
catch(IOException e){       // compiler-error; Exception 'java.io.IOException' is never thrown in the corresponding try block
    System.out.println(e);
}

-----------------------------------------

try{ }
catch(Exception e){       // valid!
    System.out.println(e);
}
```

One `try` can have multiple `catch` blocks (beware of unreachable ones).

**catch block chaining**: Super class is allowed only after more specific ones because there may be exceptions to be caught that may not belong to subclass `catch` block but will be caught by superclass `catch` block.

```java
catch(IOException e){ }		// subclass
catch(Exception e){ }		// superclass; valid

catch(Exception e){ }		// superclass
catch(IOException e){ }		// unreachable code; compiler-error
```

**Multi-catch block**: Separated by `|` character, only a single object `e` of either. **It can't have related classes**.
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

We can open resources in try and they get destroyed after `try` gets over even if there is a `catch` block. This destruction takes place as soon as `try` gets over and any `finally` will execute after that. Also, **the resources are closed in the reverse order in which they were created**.

```java
try(var f = new File("my.txt"); var x = new File("foo.txt");){	}	// last semicolon is optional
// implicit finally; resources closed in reverse order of creation

catch(Exception e){	}	// optional catch

finally{ }      // optional finally too (both catch and finally need not be there unlike normal try)
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

## Suppressed Exceptions with try-with-resources
If two exceptions are thrown, one in `try` and the other in `close()` method following that, the first one is treated as a primary one while the second one is suppressed and put into a `Throwble[]` array accessible using `e.getSuppressed()`.
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
Any exception thrown in `finally` block will hide every other prior exceptions. This is a bad Java behaviour and exists only for backward compatibility.
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