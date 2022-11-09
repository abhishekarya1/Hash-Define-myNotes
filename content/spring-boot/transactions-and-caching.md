+++
title = "Transactions & Caching"
date = 2022-06-19T07:29:00+05:30
weight = 9
+++

## Transactions
In Spring, we use `@EnableTransactionManagement` on main class to enable transactions. In Spring Boot, it is enabled by default so no need for that annotation. 
```java
// To make a class or a method transactional
@Transactional

// if applied on a class, it adds the annotation to all public methods and ignore all others
// if applied on a method, if the method is not public, it is ignored

```
Make sure it is imported from `org.springbootframework.transaction` and not `javax.transaction`.

```java
@Transactional(rollbackFor = IOException.class)
class Foobar{

    @Transactional(rollbackFor = SQLException.class)   // override
    public void foo(){ }
}

// override order: interface, superclass, class, interface method, superclass method, and class method
```

### Properties
```java
// default behaviour is that it rolls back only for unchecked, RuntimeExceptions

@Transactional(rollbackFor = { SQLException.class })	// noRollbackFor

@Transactional(isolation = Isolation.READ_UNCOMMITED)

@Transactional(readOnly = true)		// serves as a hint that transaction doesn't perform any insert or updates; won't cause exceptions, just a hint so it doesn't lock resources

@Transactional(timeout = 5)		// transaction timeout in seconds

@Transactional(propagation = Propagation.REQUIRES_NEW)	// creates new transaction for each child method; REQUIRED is default
// others: REQUIRES_NEW, NESTED, MANDATORY, etc...

// logging
loggging.level.org.springframework.transaction=TRACE
```

Any methods that are called inside an annotated method will be covered in a _single_ transaction, this is called an "existing" transaction. This behaviour can be changed with `propagation=...` property in the annotation.
- `REQUIRED` (_default_) - if an existing transaction is active, use that; otherwise create a new one
- `REQUIRES_NEW` - create a new transaction regardless of existing one; suspend any active existing transaction
- `NESTED` - mark a savepoint here in the existing active transaction; if an active transaction doesn't exist, it works like REQUIRED
- `MANDATORY` - if an active transaction exists, use it; otherwise throw an exception

### Pitfalls
As discussed in the below section, _@Transactional_ on any method is ignored by Spring if the call isn't coming through the proxy.

All child methods of a method annotated (and called via proxy) will be covered covered under transaction, even non-public ones:
```java
class Foo{
    @Transactional
    public void foo(){
        bar();      // method call
    }

    private void bar(){ }       // will be covered under transaction
}

// foo() also must be called from outside the class or must have an existing active transaction
```

Transactional on any non-public method is ignored and won't create a new transaction but will use the existing active one, so **we can't create smaller independent transactions for non-public methods**:
```java
class Foo{
    @Transactional
    public void foo(){
        bar();      // method call
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)      // ignored; without compiler-errors
    private void bar(){ }       // will be covered under existing transaction
}
```

_@Transactional_ is only valid for calls to public method coming from another class only. Any `public` method called from within the class ignores the _@Transactional_ on it too:
```java
class Foo{
    @Transactional
    public void foo(){
        bar();      // method call
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)  // ignored if called from foo(); works when called from outside class Foo
    public void bar(){ }
}
```

**Exception Propagation**: Runtime exceptions need not be declared with `throws` but checked ones have to be declared. If a method propagates an exception (doesn't handle it), rollback will happen for it too if `rollbackFor` property specifies it.
```java
class Foo{
    @Transactional(rollbackFor = SQLException.class)    // rollback is becuase of exception propagation; not in the same transaction as bar()
    public void foo() throws SQLException {
        bar.fun2();      // external method call; unhandled exception
    }  
}


// another class
class Bar{
    @Transactional(rollbackFor = SQLException.class, propagation = Propagation.REQUIRES_NEW)    // new transaction
    public void fun2() throws SQLException{
        throw new SQLException();       // exception occurs here
    }
}
```

**Summary**: All method calls coming from within the same class ignore _@Transactional_ annotation on that method, no matter if the method is non-public or public.

### Proxy
The `@Transactional` annotation uses Spring proxy and transactional logic is injected before and after the running method. It means that **only external calls to methods that come in through the proxy are covered under transactions, any internal method calls are not transactional even if they're annotated!**. We can cover such `private` methods programmatically using `PlatformTransactionManager` and manually commiting or rolling back.

**Programmative Way** using `PlatformTransactionManager`:
```java
@Autowired
private PlatformTransactionManager transactionManager;

// inside the method
DefaultTransactionDefinition def = new DefaultTransactionDefinition();
// explicitly setting the transaction name is something that can only be done programmatically
def.setName("SomeTxName");
def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);

TransactionStatus status = transactionManager.getTransaction(def);
try {
    // execute your business logic here
}
catch (MyException ex) {
    transactionManager.rollback(status);
    throw ex;
}

transactionManager.commit(status);
```

### Isolation
```java
@Transactional(isolation = Isolation.DEFAULT)   // use DB provider's default level

// READ_UNCOMMITTED, READ_COMMITTED, REPEATABLE_READ, SERIALIZABLE
```
_Explanations_: [Isolation Notes](/db/rdbms/concepts/#issues)

---
## Caching
By default `spring-boot-starter-cache` will include support for EhCache. To be able to use Redis we need to add custom config class (1) or add `spring-boot-starter-data-redis` and then use properties file to customize it (2). For Ignite we can [create a custom config](https://medium.com/swlh/spring-cache-with-apache-ignite-def103cae35).

```yaml
# Redis cache config
spring.cache.type=redis
spring.redis.host=localhost
spring.redis.port=6379
```

Add `@EnableCaching` on main application class to enable caching in Spring Boot.

```java
// specify cache properties for whole class
@CacheConfig(cacheNames = "students")

// on methods
@Cacheable(cacheNames = "students")		// read
@CachePut		// insert
@CacheEvict		// delete

@Caching(evict = {@CacheEvict("phone_number"), @CacheEvict(value = "directory", key = "#student.id") })  // using same annotation multiple times
```

### Properties and Spring Expressions
```java
@Cacheable(value = "students", key = "#id")	// notice that value is not "key's value" but alias for "cacheNames" property only
Student getStudentName(Long id){	}

@Cacheable(value = "students", key = "#s.id")	// notice the expression
Long getStudentId(Student s){ }

@CacheEvict(value = "student", allEntries=true)		// evict all entries from cache

@Cacheable(value = "student", sync=true)		// sync the underlying method (for multi-threading)
```

### Conditional Caching
```java
// condition on input
@CachePut(value="addresses", condition = "#customer.name == 'Tom'")
public String getAddress(Customer customer) { }

// condition on output
@CachePut(value="addresses", unless = "#result.length() < 64")
public String getAddress(Customer customer) { }
```

### Storage in Cache
Spring will take care of storing in cache based on cache provider. Ex - In the above example, we specify `cacheName` as "students" and Redis will not neccessarily use the same name as-it-is to create keys, the name is often a combination of `cacheName` and various other stuff like student name and other fields whose fetching and decoding is taken care of implicitly.   

## References
- https://www.baeldung.com/transaction-configuration-with-jpa-and-spring
- https://www.baeldung.com/spring-transactional-propagation-isolation
- https://docs.spring.io/spring-framework/docs/4.2.x/spring-framework-reference/html/transaction.html
- https://www.marcobehler.com/guides/spring-transaction-management-transactional-in-depth
- https://www.journaldev.com/18141/spring-boot-redis-cache
- https://www.javatpoint.com/spring-boot-caching