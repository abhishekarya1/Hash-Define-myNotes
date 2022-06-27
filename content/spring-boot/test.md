+++
title = "Testing"
date = 2022-06-18T14:32:00+05:30
weight = 7
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

**Platform**: Contains test execution engine

**Jupiter API**: for writing new tests

**Vintage API**: for writing tests compatible with JUnit4

## Writing Tests
```java

class FoobarTest{
	@Test
	void testFoobar(){
		// body
	}
}

// empty body of a test is a "PASS"!
```

### Assertions
```java
// statically imported; most methods have a third optional param which is a test failure message
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
	() -> assertEquals(b, bar()),
	() -> assertEquals(c, xyz())
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

// execute hook once after all tests
@AfterAll
static void testFun(){ }
```

### Test Instance
For each _@Test_, a new instance of the test class is created. Ramifications of this is that if we have a shared instance variable placed in our test class, it can't share values in between test runs. Its a good practice to make the tests self-contained and this is done to promote that behaviour.

If for some reason, we have to create an instance per class (once), we can do so:
```java
@TestInstance(TestInstance.Lifecycle.PER_CLASS)		// or Lifecycle.PER_METHOD
class FoobarTest{
	// body
}

// we won't need to make the @BeforeAll and @AfterAll methods "static" now since there is only one instance
```

### Scaling Tests
```java
@Disabled		// skips running the test but shows in IDE
void testFun(){ }
```

### Conditional Execution
```java
@EnabledOnOs(OS.LINUX)			// will disable test when run on a non-linux OS
@EnabledOnJre(JRE.JAVA_11)
@EnabledIf
@EnabledIfSystemProperty
@EnabledIfEnvironmentVariable
```

When assumptions are false, test will be disabled mid-run.
```java
// static import
assumeTrue(expr);
```

### Nested Test Classes

Nested tests appear under submenu in IDE. If a nested test fails, every parent test class also fails.

```java
// nested class

class FoobarTest{
	
	@Nested
	class BarTest{		// nested class
		
		@Test
		void testBar(){ }
	}

	@Test
	void testFoo(){ }
}
```

Use display names for better readability.
```java
@DisplayName("Country tests")		// on a test class; can use on nested classes too
class CountryTests(){ }

@DisplayName("Check if country is Canada")		// on a test method
void testCanada(){ }
```

### Repeating Tests
```java
@RepeatedTest(n)		// runs test n times
void testFun(){ }

// everytime it passes a RepetitionInfo object to our test method
@RepeatedTest(RepetitionInfo repInfo)
void testFun(){ 
	repInfo.getTotalRepetitions();
	repInfo.getCurrentRepetition();
}
```

### Tagging Tests
We can tag tests and only selectively run tests with a particular tag.
```java
@Test
@Tag("Country")
void testCanada(){ }

// create a run configuration in the IDE to exclude or include selected tags from test execution
```

## Running Tests
The "Maven Surefire Plugin" enables us to run test with maven commands like `mvn test`. The `spring-boot-maven-plugin` added by default by the Spring Initializr takes care of this.


## Mockito
Framework to mock layers below the layer we want to test.


### Mocking
Any mocked object is `null` and has to be stubbed before using.
```java
// 1: using annotation
@Mock
Foobar foobar;

MockitoAnnotations.openMocks(this);		// enable annotation otherwise foobar will be null

// 2: programmatically
Foobar foobar = mock(Foobar.class)		// no need to enable with any other statement

// 3: use annotation without need to enable it if we add any of the below annotations on test class
@ExtendWith(SpringExtension.class)
@ExtendWith(MockitoExtension.class)
```

### InjectMocks
**@InjectMocks**: Injects mocks into the class and creates a _@Mock_ for the class.
```java
class Game {
    private Player player;
}

// in the GameTest class
@Mock
Player player;

@InjectMocks
Game game;		// since game requires player mock
```

### Spying
It actually calls the method and returns live data if not stubbed.
```java
// @Spy is used in the same way as @Mock

@Spy
Foobar foobar;

Foobar foobar = spy(Foobar.class)
```

### Stubbing
```java
when(repository.getStudentNameById(Mockito.anyLong())).thenReturn("John");
when(repository.getStudentNameById(Mockito.anyLong())).thenThrow(SQLException.class);

doReturn("John").when(repository).getStudentNameById(Mockito.anyLong());

System.out.println(repository.getStudentNameById(5));		// "John"
```

**Multiple call stubbing**: If we call a method multiple times from the class under test.
```java
when(repository.getStudentNameById(Mockito.anyLong())).thenReturn("John", "Maya", "Ram");
when(repository.getStudentNameById(Mockito.anyLong())).thenReturn("John").thenReturn("Maya").thenReturn("Ram");
```
**Stub void methods**:
```java
doNothing().when(itemRepository).saveItem();	// save() returns void
doThrow(SQLException.class).when(itemRepository).saveItem();	// save() returns void
```

### Behavior Verification
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

## References
- [Java Brains - YouTube](https://www.youtube.com/playlist?list=PLqq-6Pq4lTTa4ad5JISViSb2FVG8Vwa4o)
- [JUnit 5 - Official User Guide](https://junit.org/junit5/docs/current/user-guide/)
- [Dinesh Varyani - YouTube](https://youtube.com/playlist?list=PL6Zs6LgrJj3vy7yWpH9xb3Y0I_pAPrvCU)