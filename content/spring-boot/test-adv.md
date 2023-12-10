+++
title = "Testing - Advanced"
date = 2023-05-29T22:50:00+05:30
weight = 12
+++

## Testcontainers
Used to write Integration or Repository tests.

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


**JDBC URL Short Form**: Just define a database JDBC URL like below and all container related stuff will be taken care of, no need for testcontainer related annotations too!
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

**How to populate container DB with data**:
- use Database Migration like Flyway to populate database container (name is misleading; its just runs `.sql` scripts to create schema, populate data, etc...) [[_clarification_](https://stackoverflow.com/questions/57602306/how-to-use-flyway-to-migrate-data-from-one-db-to-another-db), [_tutorial_](https://youtu.be/q5pfc_bFK-Y)]
- or use an init `.sql` file containing queries to populate container DB, this file is run automatically by Testcontainers dependency [[_link_](https://java.testcontainers.org/modules/databases/jdbc/#using-a-classpath-init-script)]
- or use an init Java method to populate [[_link_](https://java.testcontainers.org/modules/databases/jdbc/#using-an-init-function)]

https://www.testcontainers.org

## StepVerifier and TestPublisher
Writing tests for reactive services.

Maven dependency:
```xml
<dependency> 
	<groupId>io.projectreactor</groupId> 
	<artifactId>reactor-test</artifactId> 
	<scope>test</scope>     
	<version>3.2.3.RELEASE</version> 
</dependency>
```

```java
Flux<String> source = Flux.just("Apple", "Ball", "Cat", "Dog");

StepVerifier 
	.create(source) 
	.expectNext("Apple") 
	.expectNextMatches(name -> name.startsWith("B")) 
	.expectNext("Cat", "Dog") 
	.expectComplete()
	.verify();
```

```java
// create a source on the go with TestPublisher
final TestPublisher<String> testPublisher = TestPublisher 
											.<String>create() 
											.next("First", "Second", "Third")
											.complete();

// verify using StepVerifier
StepVerifier
	.create(testPublisher.flux()) 
	.expectNext("First") 
	.expectNext("Second", "Third") 
	.expectComplete()
	.verify();
```

https://www.baeldung.com/reactive-streams-step-verifier-test-publisher

## Awaitility
A small library to test async services; the status is obtained by a _Callable_ that polls our service at defined intervals (default 100ms) after a specified initial delay (default 100ms), it will poll for a max duration (default 10s) post which it will fail the test throwing `ConditionTimeoutException` 

```java
@Test public void updatesCustomerStatus() {
	// Publish an asynchronous message to a broker (e.g. RabbitMQ):
	messageBroker.publishMessage(updateCustomerStatusMessage); 

	// Awaitility lets you wait until the asynchronous operation completes:
	await().atMost(5, SECONDS).until(customerStatusIsUpdated());
```

https://www.baeldung.com/awaitility-testing

## WireMock and MockServer
Create and up a mock server that mimics an external API integration, instead of calling the real one (that may cost us money).

```java
// create mock server
@RegisterExtension
static WireMockExtension wireMockServer = WireMockExtension.newInstance()
		.options(wireMockConfig().dynamicPort())
		.build();

// set property to point to mock server instead of external API (GitHub in this case)
@DynamicPropertySource
static void configureProperties(DynamicPropertyRegistry registry) {
		registry.add("github.api.base-url", wireMockServer::baseUrl);
}


@Test
void shouldGetFailureResponseWhenGitHubApiFailed() throws Exception {
	String username = "abhishekarya1";

	// stub API call (path pattern matching)
	wireMockServer.stubFor(WireMock.get(urlMatching("/users/.*"))
		.willReturn(aResponse().withStatus(500)));

	// perform actual call using MockMvc
	String expectedError = "Fail to fetch github profile for " + username;
	this.mockMvc.perform(get("/api/users/{username}", username))
			.andExpect(status().is5xxServerError())
			.andExpect(jsonPath("$.message", is(expectedError)));
}
```

[MockServer](https://www.mock-server.com) is another library that is very similar to WireMock, has a slightly simpler syntax and can be loaded as a Testcontainer too.

## Playwright
Created by Microsoft for writing end-to-end tests; alternative to Selenium.

Calls our service as a browser agent - Chromium, Firefox, etc... loads the page and we can then specify which buttons user clicks, doing search from search bar, etc...

https://playwright.dev/java/docs/running-tests

## Gatling
Performance testing; written in Go, extremely fast but allows only HTTP requests

https://gatling.io

## References
- Java Testing Made Easy - Playlist - SivaLabs - [YouTube](https://youtube.com/playlist?list=PLuNxlOYbv61jtHHFHBOc9N7Dg5jn013ix)
- Integration Testing using Testcontainers - SivaLabs - [YouTube](https://youtu.be/osw9dz2ZhhQ)