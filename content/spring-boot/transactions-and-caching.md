+++
title = "Transactions & Caching"
date = 2022-06-19T07:29:00+05:30
weight = 7
+++

## Transactions
In Spring, we use `@EnableTransactionManagement` on main class to enable transactions. In Spring Boot, it is enabled by default so no need for that annotation. 
```java
// To make a class or a method transactional
@Transactional

// default behaviour is that it rolls back only for unchecked, RuntimeExceptions
// also make sure it is imported from org.springbootframework and not javax.transaction
```

Any methods that are called from a method annotated will be covered in a _single_ transaction. This behaviour can be changed with `Propagation` property in the annotation.

### Properties
```java
@Transactional(rollbackFor = { SQLException.class })	// noRollbackFor

@Transactional(isolation = Isolation.READ_UNCOMMITED)

@Transactional(readOnly = true)		// serves as a hint that transaction doesn't perform any insert or updates; won't cause exceptions, just a hint

@Transactional(timeout = 5)		// transaction timeout in seconds

@Transactional(propagation = Propagation.REQUIRES_NEW)	// creates new transaction for each child method; PROPAGATION_REQUIRED is default

// logging
loggging.level.org.springframework.transaction=TRACE
```

### Proxy
The `@Transactional` annotation creates a proxy in the framework for the annotated method or class and injects transactional logic before and after the running method. It means that **only external calls to methods that come in through the proxy are covered under transactions, any `private` internal method calls are not transactional even if they're annotated!**. We can cover such `private` methods programmatically using `PlatformTransactionManager` and manually commiting or rolling back.

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

## Caching
By default `spring-boot-starter-cache` will include support for EhCache. To be able to use Redis we need to add custom config class or add `spring-boot-starter-data-redis` and then use properties file to customize it. For Ignite we can [create a custom config](https://medium.com/swlh/spring-cache-with-apache-ignite-def103cae35).

Add `@EnableCaching` on main application class to enable caching in Spring Boot.

```java
// specify cache name for whole class
@EnableCacheConfig(cacheNames = {"students"})
								("students")
								(value = "students")	

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
## References
- https://docs.spring.io/spring-framework/docs/4.2.x/spring-framework-reference/html/transaction.html
- https://www.marcobehler.com/guides/spring-transaction-management-transactional-in-depth
- https://www.journaldev.com/18141/spring-boot-redis-cache
- https://www.javatpoint.com/spring-boot-caching