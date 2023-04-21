+++
title = "Testing"
date = 2022-06-18T14:32:00+05:30
weight = 10
+++

## JUnit 4
JUnit4 is very different from JUnit5:
- it was very old (> 10 yrs) when JUnit5 was released
- not up-to-date with the latest testing patterns
- it is monolithic (only one JAR and has to be loaded all or none)

We cannot "plug and play" JUnit5 inplace of JUnit4 as they are very different from each other.


## JUnit 5 Architecture
{{<mermaid>}}
graph TB;
    A[Platform]
    A --> B(Jupiter API)
    A --> C(Vintage API)
    A --> D(3rd Party Extensions)
{{< /mermaid >}}

**Platform**: Contains test execution engine and below 3 APIs

- **Jupiter API**: for writing new tests

- **Vintage API**: for writing tests compatible with JUnit4

- **3rd Party Extensions**: for writing other kinds of tests 

## Writing Tests
```java

class FoobarTest{
	@Test
	void testFoobar(){
		// body
	}
}

// empty body of a test is a "PASS"!
// no news = good news
```

### Assertions
```java
// statically imported; most methods have an optional param which is a test failure message
assertEquals(expected, actual, "optional fail message");
assertNotEquals(expected, actual);
assertNull(expr);
assertNotNull(expr);
assertFalse(expr);
assertTrue(expr);

fail("optional fail message");

assertThrows(ArithmeticException.class, () -> foobar());	// here foobar() can throw exception

assertAll(
	() -> assertEquals(a, foo()),
	() -> assertNotNull(b),
	() -> assertTrue(xyz())
	);
```
_References_: https://junit.org/junit5/docs/current/api/org.junit.jupiter.api/org/junit/jupiter/api/Assertions.html

### Test Lifecycle Hooks
```java
// execute hook once before all tests (even before framework initializes the test class, that's why it has to be static)
@BeforeAll
static void testFun(){ }

// execute hook before each test
@BeforeEach
void testFun(){ }

// execute hook after each test
@AfterEach
void testFun(){ }

// execute hook once after all tests; has to be static
@AfterAll
static void testFun(){ }
```

### Test Instance
For each _@Test_, a new instance of the test class is created. Ramifications of this is that if we have a shared mutable instance variable placed in our test class, it can't share updated values (states) in between test runs. Its a good practice to make the tests self-contained and this is done to promote that behaviour.

If for some reason, we have to create an instance per class (once), we can do so:
```java
@TestInstance(TestInstance.Lifecycle.PER_CLASS)		// or Lifecycle.PER_METHOD (default)
class FoobarTest{
	// body
}

// we won't need to make the @BeforeAll and @AfterAll methods "static" now since there is only one instance
```

### Disabling Tests
```java
@Disabled		// skips running the test but shows in IDE upon run (greyed out)
void testFun(){ }
```

### Conditional Execution
```java
@EnabledOnOs(OS.LINUX)			// will disable test when run on a non-linux OS
@EnabledOnJre(JRE.JAVA_11)
@EnabledIf
@EnabledIfSystemProperty
@EnabledIfEnvironmentVariable

// corresponding @DisabledOn... and @DisabledIf for all of the above are available too
```

### Assumptions
If assumptions are wrong, test will be disabled mid-run. No failure, rather it will be disabled.
```java
assumeTrue(expr);

assumeFalse(expr);
```

### Nested Test Classes
Nested tests appear under submenu in IDE. If a nested test fails, every ancestor class also fails.

Tests in nested classes won't work without the _@Nested_ annotation. 

```java
class FoobarTest{
	
	@Nested
	class BarTest{		// nested class
		
		@Test
		void testBar(){ }
	}

	@Test
	void testFoo(){ }
}

// multiple levels of nesting is also allowed
```

Use display names for better readability.
```java
@DisplayName("Country tests")		// on a test class; can use on nested classes too
class CountryTests(){ }

@DisplayName("Check if country is Canada")		// on a test method
void testCanada(){ }
```

### Tagging Tests
We can tag tests and only selectively run tests with a particular tag.
```java
@Test
@Tag("Country")
void testCanada(){ }

// create a run configuration in the IDE to exclude or include selected tags from test execution
```

### Repeating Tests
```java
@RepeatedTest(3)		// runs test 3 times
void testFun(){ }

// everytime it passes a RepetitionInfo object to our test method
@RepeatedTest(RepetitionInfo repInfo)
void testFun(){ 
	repInfo.getTotalRepetitions();
	repInfo.getCurrentRepetition();
}
```

---
## Mockito
Framework to **mock layers below the layer we want to test**.

### Mocking
Use _@Mock_ to mock objects. Every method call we make on mocks will return `null` or `[]` or `0` unless we stub its methods with (`when`-`then`).

Its just like a wireframe with all the method names, their return types, etc... available to it but can't run any logic inside of them. We use stubs to provide logic to Mocks.
```java
// 1: using annotation
@Mock
Foobar foobar;

MockitoAnnotations.openMocks(this);		// enable annotation otherwise foobar will be null

// 2: programmatically
Foobar foobar = mock(Foobar.class);		// no need to enable with any other statement

// 3: use annotation without need to enable it if we add any of the below annotations on test class
@ExtendWith(SpringExtension.class)
@ExtendWith(MockitoExtension.class)
```

### InjectMocks
If we create a _@Mock_ of a class that has other classes in it, then those included classes will be `null`. We should create _@Mock_ for each of the constituent classes and inject into the parent. 

**@InjectMocks**: Create a _@Mock_ and inject all other _@Mock_ in the current test class into it.
```java
// Game class
class Game {
    private Player player;
}

// GameTest class
@Mock
Player player;

@InjectMocks
Game game;		// since game requires player
```

### Spying
It actually calls the method and returns live data if not stubbed.
```java
// @Spy is used in the same way as @Mock

@Spy
Foobar foobar;

Foobar foobar = spy(Foobar.class);

// notice that if it not stubbed, this will actually call the method
```

### Stubbing
```java
when(repository.getStudentNameById(Mockito.anyLong())).thenReturn("John");


when(repository.getStudentNameById(Mockito.anyLong())).thenThrow(new IOException());	// method must "throws" this exception
when(repository.getStudentNameById(Mockito.anyLong())).thenThrow(IOException.class);


doReturn("John").when(repository).getStudentNameById(Mockito.anyLong());
```

**Multiple call stubbing**: Stubbing multiple calls of a method.
```java
when(repository.getStudentNameById(Mockito.anyLong())).thenReturn("John", "Maya", "Ram");
when(repository.getStudentNameById(Mockito.anyLong())).thenReturn("John").thenReturn("Maya").thenReturn("Ram");
```
**Stub void methods**: They will not run at all so no side-effects, will just do nothing.

We can't stub methods that return `void` with `then` methods, we have to use `do` methods for that.
```java
doNothing().when(itemRepository).saveItem();	// save() returns void

doThrow(new IOException()).when(itemRepository).saveItem();	// save() returns void; must "throws" this exception
doThrow(IOException.class).when(itemRepository).saveItem();
```

### Behaviour Verification
When a Mockito object is created, it remembers everything we do on it. Verification of calls happen in the order in which they are written.
```java
verify(repository).foobar("John");	// test fails if foobar() is never called with param "John"

verify(repository, times(1)).foobar("Maya");	// test fails if foobar() is not called 1 times with param "Maya"
verify(repository, atLeast(1)).foobar("Maya");	// test fails if foobar() is not called atleast 1 times with param "Maya"

verify(repository, never()).foobar("Ram");	// test fails if foobar() is never called with param "Ram"

verifyNoInteractions(repository);

// <put a verify statement here before verifying no more interactions>
verifyNoMoreInteractions(repository);
```

### Mockito Exceptions
Mockito can detect unneccessary stubbings and throws `UnnecessaryStubbingException` upon detection (strict stubbing).

If this exception is there, the stubbing is either redundant or unreachable.

Use `lenient()` on stub to disable strict stubbing.
```java
lenient().doNothing().when(itemRepository).saveItem();
```

### Limitations in Stubbing
We can't stub `private` methods as they aren't callable from our test class.

Usually we have a `public` method making calls to multiple private methods during test execution and we can't stub the output of those `private` methods with Mockito. We have other frameworks like PowerMock (or ReflectionTestUtils) to do such stuff, but we should really avoid that because we should focus on testing functional flow (a unit) rather than individual methods. 

## ReflectionTestUtils
Provided by Spring. Uses Java Reflection API internally to modify class under test at runtime. We can set fields, invoke methods, and even call `private` methods of an object.

_Guide_: https://www.baeldung.com/spring-reflection-test-utils


Bad way to do testing but comes in handy sometimes ;)

## AssertJ
A better way is to use AssertJ assertions (we need `assertj-core` Maven dependency to use them), rather than the built-in Spring Assertions.

We just need to remember `assertThat()` when using AssertJ library!
```java
assertThat(emailAddress).contains("@gmail.com");
assertThat(year).isLessThan(2023);
```

## Specialized Tests (aka Slice Tests)
###  Controller Test (WebMvcTest)

Makes calls to our controller endpoints, service layer to be mocked here.

Use only `@MockBean` with `@WebMvcTest` to mock service layer.

**NOTE**: `@MockBean` is a Spring annotation, not a Mockito one. It creates a Mock just like Mockito but actually goes ahead and replaces it with the actual Bean in the Spring Proxy. And we also need to stub it ofcourse using Mockito.

```java
@WebMvcTest(controllers = MyController.class)
public class MyControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private Service service;

    @Test
    public void testMyController() throws Exception {

    	when(service.fooBar(Mockito.any())).thenReturn("success");	//stub

        mockMvc.perform(MockMvcRequestBuilders.get("/api/v1"))		//mock http call
        .andExpect(status().isOk());
    
	}
}
```

### DataJpaTest
Sets up an in-memory H2 database and performs run tests using it. Modern way is to use Testcontainers.

```java
@DataJpaTest
public class JpaRepositoryTest {

    @Autowired
    private EntityManager entityManager;

    @Autowired
    private ProductRepository respository;

    @Test
    public void testRepo() {

        entityManager.persist(new Product(1, "Laptop", 50000));			// could've used "repository.save()" here; no need of EntityManager then
    
	}
}
```
---
## Integration Testing
Ups the server and run tests on it when we annotate the test class with _@SpringBootTest_ and use `MockMvc` to hit the enpoints.

No mocking to be done in this kind of test.

```java
@SpringBootTest				// default port = 8080
@AutoConfigureMockMvc
public class IntegrationTest{

	@Autowired
    private MockMvc mockMvc;		// test end-to-end by hitting controller endpoints

    @Test
    public void testMyController() throws Exception {

        mockMvc.perform(MockMvcRequestBuilders.get("/api/v1"))
        .andExpect(status().isOk());
	}
}
```

### Testcontainers
Used to write Integration tests, use Database Migration like Flyway to populate database container.

Create ephemeral external dependencies like databases, MQs, etc.. for test purposes. Pulls Docker images and runs containers for test scope & duration, needs Docker pre-installed on the system to work.

```java
@SpringBootTest	
@Testcontainers
public class MyTest{

	// Postgres specific code
	@Container
	static PostgreSQLContainer postgreSQLContainer = 
		new PostgreSQLContainer(DockerImageName.parse("postgres:14-alpine"));

	// alternatively, for any Docker image (recommended)
	@Container
	static GenericContainer sqlContainer = 
		new GenericContainer(DockerImageName.parse("postgres:14-alpine"));

	// db properties
	@DynamicPropertySource
	static void setProperties(DynamicPropertyRegistry registry){
		registry.add("spring.datasource.url", postgreSQLContainer::getJdbcUrl);
		registry.add("spring.datasource.username", postgreSQLContainer::getUsername);
		registry.add("spring.datasource.password", postgreSQLContainer::getPassword);
	}
}
```


**JDBC URL Short Form**: Just define a database JDBC URL like below and all container related stuff will be taken care of, no need for testcontainer realted annotations too!
```java
@SpringBootTest	
@TestPropertySource(properties = {
	"spring.datasource.url=jdbc:tc:postgresql:14-alpine/foobar_database"
})
public class MyTest{
		// tests
}
```

We can also externalize common container configs to another class too.

https://www.testcontainers.org

## References
- [Java Brains - YouTube](https://www.youtube.com/playlist?list=PLqq-6Pq4lTTa4ad5JISViSb2FVG8Vwa4o)
- [JUnit 5 - Official User Guide](https://junit.org/junit5/docs/current/user-guide/)
- [Dinesh Varyani - YouTube](https://youtube.com/playlist?list=PL6Zs6LgrJj3vy7yWpH9xb3Y0I_pAPrvCU)
- Spring Boot Microservices Project - Programming Techie - [YouTube](https://youtu.be/lh1oQHXVSc0?list=PLSVW22jAG8pBnhAdq9S8BpLnZ0_jVBj0c)
- Integration Testing using Testcontainers - SivaLabs - [YouTube](https://youtu.be/osw9dz2ZhhQ)