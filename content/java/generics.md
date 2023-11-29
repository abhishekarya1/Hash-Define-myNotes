+++
title = "Generics"
date =  2022-05-27T15:04:00+05:30
weight = 9
+++

## Formal Type Parameter
`<T>` is called a **Formal Type Parameter** in generics.

```java
class Foo<T>{
    private T foo;
    private T bar;

    public void setFoo(T foo){
        this.foo = foo;
    }
}

Foo<Integer> obj = new Foo<>();
Foo<String> obj2 = new Foo<>();


// with two type params
class Foo<T, U>{
    private T foo;
    private U bar;

    public Foo(T foo, U bar){
        this.foo = foo;
        this.bar = bar;
    }
}

Foo<Integer, String> obj = new Foo<>(5, "foo");
Foo<String, Float> obj2 = new Foo<>("bar", 2.33);


// below works too; type inference via constructor call; not recommended
Foo obj3 = new Foo("test", 99);
```

## Inheritance and Generic Interfaces
Interfaces can be generic too.
```java
public interface Foo<T>{
    void foobar(T i);
}

// three ways to implement generic interfaces
class Bar implements Foo<Integer>{
    public void foobar(Integer i){ }
}

class Bar<U> implements Foo<U>{ 
    public void foobar(U i){ }
}


//old way, compiler warning, raw type
class Bar implements Foo{
    public void foobar(Object i){ }
}
```

Same holds for the inheriting `class`.
```java
class Foo<T>{

    T test(){ }
}

class Bar extends Foo<Integer>{    // either define here, propagate to child, or keep raw
    
    @Override
    Integer test(){ }
}
```

### Generic Records and Enums
```java
public record Foo<T, U>(T name, U age){ }
```

In the same way, `enum` can be generic too.

## Type Erasure
Type erasure ensures that no new classes are created for parameterized types. 

At compilation time: 
- type `T` becomes `Object`
- upper bound `<T extends Foobar>` converts to `Foobar`
- parameterized types like `List<String>` and `List<Integer>` both are converted to `List<Object>`

### Overloading and Overriding Generic Methods
**Overloading**: Type erasure can cause duplicate method issues. So a **check is done before type erasure** and compiler-error is raised if incompatible.

For this reason, we can't overload a generic method in child class that is inherited from a parent class.
```java
void foobar(List<Integer> arr)
void foobar(List<Float> arr)
// compiler error; they both will become "List arr" after type erasure if allowed (duplicate method)

void foobar(List<Integer> arr)
void foobar(ArrayList<Float> arr) 
// allowed since its normal overloading
```

**Overriding**: Compatibility is checked for both the return types and the method signature **before type erasure happens**.

Collections are generic too, so the same rule applies here as periviously stated ([here](/java/coll/#collection-types-and-overriding))
```java
List<Number> foobar(){ }        // 1 

// overriding above method
List<String> foobar(){ }          // 2 - not allowed; generic type parameter <> must match exactly
List<Integer> foobar(){ }         // 3 - not allowed; generic type parameter <> must match exactly
ArrayList<Number> foobar(){ }     // allowed; ArrayList implements List (covariant); vice-versa not allowed
```
```txt
Q: Won't 1, 2, and 3 become same (List<Object> foobar) after type erasure? Overriding is valid then right?

A: No, return types' compatibility is checked before type erasure.
```

```java
void foobar(List<Number> list){ }          // 1 

// overriding above method
void foobar(List<String> list){ }          // 2 - not allowed; generic type parameter <> must match exactly
void foobar(List<Integer> list){ }         // 3 - not allowed; generic type parameter <> must match exactly
void foobar(ArrayList<Number> list){ }     // 4 - not allowed; signature must be the same in overriding
```

```txt
Q: Won't 1, 2, and 3 become same (void foobar(List<Object>)) after type erasure? Overriding is valid then right?

A: No, method signature types' compatibility is checked before type erasure.
```

## Limitations of Generics
1. Can't do `new T()`
2. Can't do `new T[10]`
3. Can't call `instanceof T` because of Type Erasure
4. Can't use primitive type with generics, instead we use wrapper classes
5. Can't use `static` variable as generic type, because the type is linked to the instance of the class

```java
class MyClass<T>{
    static T foobar;     // compiler-error; generics not allowed on static variables

    static <T> void foo(T m){ }  // allowed on static methods; since they can specify type during call
}
```

## Generic Methods
```java
//if method is not obtaining from its owner class/interface, we can specify in definition using <>
<T> void bar(T n){ }
static <T> void foo(T m){ }
public <T, U> int demo(T a, U b){ }

//invoking a generic method explicitly; compiler will figure out otherwise
// static methods
Box.<String>ship("package");
Box.<String[]>ship(args);

// instance methods
new Foo().<String>fun("A");
obj.<Integer>num(8);
```

```java
//if you declare a generic type on a method inside a generic class, it becomes independent of class's
class Foo<T>{
    <T> void bar(T t){  }
}

Foo<String> obj = new Foo<>();      // String
obj.bar(99);                        // Integer
```

## Bounded Type Parameters (Bounding without Wildcards)

**Class and Method level bounding without Wildcards**:
```java
class X <T extends Number> { }
public <U extends Number> void inspect(U u){  }

// multpile bounds
<T extends C1 & C2 & C3>
```

```java
// no <T super Number> exists for bounding without wildcards; it exists only for wildcard bounds

class X <T t> { }   // 1; becomes "Object t" after type erasure

class X <T extends Number> { }  // becomes "Number t" after type erasure

class X <T super Number> { }    // compiler-error; would become "Object t" after type erasure; so no point in writing this instead of 1
```

[Reference](http://www.angelikalanger.com/GenericsFAQ/FAQSections/TypeParameters.html#Why%20is%20there%20no%20lower%20bound%20for%20type%20parameters?:~:text=Again%2C%20the%20lower%20bound%20would%20have%20the%20same%20effect%20as%20%22no%20bound%22)

## Bounding with Wildcards
Often used with collections. Method argument level only, no class level bounding ([see below](#some-pitfalls-in-usage)). 

**Wildcards are checked and enforced at runtime unlike bounded type params which are resolved during compile-time (type erasure)**. Wildcards decide what types can be accepted as method parameter and not define an actual type `T`. This allows stuff like [PECS](#immutability-with-wildcards-pecs-rule).
```java
<?>               // unbounded
<? extends Class> // only those types which are subclasses of Class (upper bound) or Class itself
<? super Class>   // only those types which are superclasses of Class (lower bound) or Class itself
```
The `Class`  above can also refer to a Interface type. Also, `extends` is applicable for interface too here, meaning the same as `implements` in this context.

### Unbounded Wildcard
Java doesn't allow casts like `List<String>` to `List<Object>` since once its declared as a list of Objects, we can add elements of its subclass types also to it e.g. `Integer`, `Car`, `Dog` etc... So, such conversions aren't allowed therefore we can't use `List<Object>` as a common type. In short - their elements' types are related but not the Lists object themselves, so no cast is allowed.

```java
List<Integer> numbers = new ArrayList<>();
numbers.add(420);
List<Object> objects = numbers;     // compiler error; conversion not allowed
objects.add("four twenty");         // to prevent wrongly do this
```

```java
public static void printList(List<Object> list) {       // 1
    list.add(9);    // 2; because why not

    for (Object x: list)
        System.out.println(x);
}

public static void main(String[] args) {
    List<String> keywords = new ArrayList<>();
    keywords.add("java");
    printList(keywords);    // compiler error; not allowed because of 1 and to prevent wrongly doing 2
}
```

We need to use `<?>` for all such cases where we need to accept "any" type. Provides simpler syntax and in-built safety.
```java
List<?> keywords = new ArrayList<String>();
// we specified type as <String> otherwise <Object> would've been assigned by default so now we can only insert String into it
// also arr List will be logically immutable! (see below sections)

// a more practical example would be: 
public static void printList(List<?> list) {
    // can't add to list (immutable) so we're safe
    // list remains of only ONE type throughout i.e. supplied in method call

    for (Object x: list)
        System.out.println(x);
}

// we can pass any kind of list to it, and it prints it
```

### var vs. Unbounded Wildcard
```java
List<?> arr1 = new ArrayList<>();    // a List type reference; List<Object>
var arr2 = new ArrayList<>();        // an ArrayList type reference; ArrayList<Object>

// read: Anything
```

### Upper-bounded Wildcard
```java
List<? extends Foobar>      // we can pass any class/interface that extends Foobar, implements Foobar or Foobar ref variable itself

// read: Anything which extends Foobar
```

### Lower-bounded Wildcard
```java
List<? super Foobar>      // we can pass any class/interface that is supertype of Foobar, or Foobar ref variable itself

// read: Anything which is supertype of Foobar

// BEWARE: above applies to what we can pass to it without compiler-error. But we can only add elements that are of type 'Foobar' i.e. subclasses of Foobar and 'Foobar' itself but not its superclasses (very counter-intuitive; see example below)

// INTUITION: pass list of the type of any superclass of Foobar, then we can add Foobar and subclasses of Foobar as elements to that list. This isn't possible with upper-bounds since we can't get this kind of idea about the type of elements to add there because there is no lower bound on the type of list is receives.

// Isn't it the same as the uppor-bound then?
// No, classes it can add elements of are the exact same set as all the upper-bound classes, the diff is callable with supertypes, mutability and thus usage differs (see "PECS" section below)
```

Since this gives us mutable lists, surprises can happen here when inserting superclass and thier subclasses if above logic is not clear:
```java
public static void main(String[] args) {
    List<Exception> exceptions = new ArrayList<Exception>();
    exceptions.add(new Exception());        // we can always do this
    foo(exceptions);
}

static void foo(List<? super IOException> e){      // line 3
    e.add(new Exception());                 // line 4; compiler-error (tricky)
    e.add(new IOException());               // line 5
    e.add(new FileNotFoundException());     // line 6; tricky
    e.add(new SSLException("xyz"));         // line 7; tricky
}

/*
Line 3 references a List with lower-bound wildcard. It can accept any supertype of IOException or IOException itself.
Line 4 does not compile because Exception is not of type IOException (we can't add a supertype object to list).
Line 5 is fine. IOException can be added.
Line 6 is also fine. FileNotFoundException is a subclass of IOException and thus it is 'IOException' (we can add it).
Line 7 is fine! SSLException is a subclass of IOException and not related to FileNotFoundException, still they can be put into the same list because of <? super IOException> (we can add it).
*/
```

### Immutability with Wildcards (PECS Rule)
**Unbounds `<?>` and Upper-bounds `<? extends Thing>` make the list logically immutable, only removal of elements can be done**. This is applicable even when we call a method that has a bounded type in parameter, the List in called method will be immutable.
```java
List<?> list = new ArrayList<Integer>();
list.add(1);    // error

List<? extends Integer> list = new ArrayList<Integer>();
list.add(1);    // error

List<? super Integer> list = new ArrayList<Integer>();
list.add(1);    // valid; no error

void fooBar(List<?> ls){
    // List ls in immutable here because of unbound <?> type in parameter
}
```

This is a major reason to use Lower-bounds (`<? super Thing>`) when any other two could've worked just the same, but with the immutability issue.

**Reason**: When we use `List<? extends Thing>`, we can be assured that it will always return an object of type `Thing` i.e. each element will behave as `Thing`. We can't add add more or change existing elements because we cannot know at runtime which specific subtype of `Thing` the collection is holding and the element we are adding may not be convertible (subclass of) with the list's existing type.

In contrast, when we use `List<? super Thing>` we can be assured that whatever type is passed to it, it will be added without restrictions since list is of supertype. Here we don't care what is already in the list as long as it will allow a `Thing` (and its subclasses which are also a `Thing`) to be added. But there are no guarantees what type of object you may read from this list, since it may be any of the supertypes of `Thing` that was stored in the list prior to calling the method with lower bound, or two elements of diff types but both subclasses of `Thing` may exist in the same list.

If we need to produce and consume (removal only) both in the same method, use `List<?>` or `List<Thing>`, then list will be immutable in the called method ([see this](#unbounded-wildcard))

{{% notice tip %}}
**PECS** (Producer Extends Consumer Super): Whenever a method produces (returns/modifies) a type `T`, use `<? extends T>`, and when it consumes (adds element) a list of type `T`, use `<? super T>`. [Example](https://stackoverflow.com/a/2723538)
{{% /notice %}}


### Some Pitfalls in Usage
```java
// use type bounds only with methods and classes, not collections
public <T> void foobar(List<T extends Main> list) {  }
// invalid; generic type bound used for collection's type 


// use wildcards only with collections, not as class or method types
public <T> <? extends Main> void foobar(T t) {  }
// invalid; wildcard used as method's return type

// valid examples
public void foobar(List<? extends Main> list) {  }
public <T extends Main> void foobar(List<T> list) {  }      // same as above; but declares T type to be reused in method body
public <T> T first(List<? extends T> list) {   }
```