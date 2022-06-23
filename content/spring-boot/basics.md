+++
title = "Basics"
date = 2022-06-03T22:32:14+05:30
weight = 1
+++

## Spring
Spring framework offerred a lightweight alternative to Java Enterprise Edition (JEE or J2EE) and moved away from EJBs (Enterprise Java Beans) to Java components like POJOs (Plain Old Java Objects). 

Biggest features were - **Dependency Injection (DI)** and **Aspect-oriented programming (AOP)**.

But, Spring was heavy in terms of configuration. There was just too much configs. Spring 3.0 introduced Java based configs as an alternative to XML based configs but still there was too much config and redundancy. This lead to _development friction_.

## Spring Boot
Spring Boot is also a framework based on Spring which differs in below core aspects:
1. **Automatic Configuration**: common tasks are automatically handled by Spring Boot, like bean creation and component scanning
2. **Starter Dependencies**: transitive dependencies
3. **Spring Boot CLI**: unconventional way of developing (using Groovy) (much like Python's Flask)
4. **Actuator**: to look at internals of a spring boot application during runtime

### Automatic Configuration
Many beans are always created in all specific-kind of applications and we don't need to create those in Spring Boot explicitly as **it will look at the dependencies included and create those beans for us automatically** e.g. `jdbcTemplate` bean. All this happens at runtime (more specifically during application startup time).

### Starter Dependencies
If we include a dependency called `org.springframework.boot:spring-boot-starter-web` it will pull around 8-9 other dependencies that we need to build web apps. We also don't have to care about their versions, intercompatibility, and updates in future. 

### Spring Boot CLI
Optional component. Provides a way to run a Spring Boot app without a conventional Java project structure, imports and even the need for compilation. Groovy (a Java compatible scripting language) can be used too.

```sh
$ spring --version
$ spring shell		#for auto-completion using TAB
$ spring init
$ spring init -dweb,jpa,security --build gradle output_folder
$ spring init -dweb,jpa -p war	# packaging as WAR instead of JAR default
``` 

### Actuator
We can inspect internals of a Spring Boot app during runtime in two ways - by **provided API endpoints** or by **opening a secure shell (SSH) session into the application**. Have to include `spring-boot-starter-actuator` dependency for this to work.

### Other features
Build tool - Maven or Gradle (provides project structure and dependency management)

Server - Tomcat or Jetty (to deploy apps on a server)

## Spring Initializr
A web app used to generate a demo project for Spring Boot. The project name is always `demo`.

Ways to access -
1. Using [start.spring.io](https://start.spring.io/)
2. Using Initializr via IDE (uses internet connection)
3. Using Spring CLI's `spring init` command (uses internet connection)


## Project Structure
```txt
pom.xml
src/
	main/
		java/
			Foobar.java
		resources/
			application.properties
			static/
			templates/
	test/
		java/
			FoobarTest.java		
```

The _Foobar.java_ class is used for both **configuration** and **bootstrapping**.
```java
@SpringBootApplication				// configuration
public class Foobar {
public static void main(String[] args) {
	SpringApplication.run(Foobar.class, args);		// bootstrapping; passing object of current class
}
```

**@SpringBootApplication** - Introduced in Spring Boot 1.2. Includes 3 other annotaions:
1. _@Configuration_: Declare class as a configuration class so that Java or XML configs can be put inside it
2. _@ComponentScan_: Enables recursive auto-scanning of components like @Controller in the current package
3. _@EnableAutoConfiguration_: Auto-config magic of Spring Boot


## Maven
Build tool that can perform many tasks such as - defining project structure, configurations, dependencies, documentation, and various steps like validate, verify, test, build, etc... 

Reference - https://maven.apache.org/guides/getting-started/index.html

### pom.xml
Project Object Model (POM)
```xml
<project>
	<modelVersion>4.0.0</modelVersion>
	
	<!-- Meta -->
	<groupId>com.example</groupId>
	<artifactId>Demo</artifactId>
	<version>0.0.1-SNAPSHOT</version>
	<packaging>jar</packaging>
	
	<name>Demo</name>
	<description>Demo Description</description>

	<!-- Parent -->
	<parent>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-parent</artifactId>
		<version>2.7.0</version>	<!-- Spring Boot version -->
	</parent>

	<!-- Dependencies (<version> is implicit from <parent>) -->
	<dependencies> 
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-web</artifactId>
		</dependency>
	</dependencies>

	<!-- Properties -->
	<properties>
		<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
		<start-class>Demo.Application</start-class>
		<java.version>11</java.version>		<!-- Java version -->
	</properties>

	<!-- Build Plugins -->
	<build>
		<plugins>
			<plugin>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-maven-plugin</artifactId>
			</plugin>
		</plugins>
	</build>

</project>
```

### Maven Goals
```sh
$ mvn compile	# compile; classes placed in /target/classes
$ mvn test		# compile test and run them
$ mvn test-compile	#compile tests but don't execute them
$ mvn package	# generate JAR
$ mvn install	
# install the artifact (JAR) to userhome/.m2/repository after compile,test,etc.. for use as a dependency in other projects locally
$ mvn clean		# delete /target

$ mvn clean install  #chaining
```

References: https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html#a-build-lifecycle-is-made-up-of-phases

### SNAPSHOT version
`SNAPSHOT` is the latest in the development branch, as soon as it goes to release, `SNAPSHOT` can be removed from the name.

Ex - `foobar-1.0-SNAPSHOT` is released as `foobar-1.0` and new development version becomes `foobar-1.1-SNAPSHOT` now.

### Maven Repositories
**Local repository**: `userhome/.m2/repository`. We can change this in `settings.xml` file.

**Remote repositories**: located on the web or a company's internal server (e.g. JFrog Artifactory)

**Central repository**: located on the web provided by Apache Community (https://mvnrepository.com/)


## Starter Dependencies
**Facet-based dependencies**: Starter dependencies are named to specify the facet or kind of functionality they provide. Ex - `starter-web`, `starter-activemq`, `starter-batch`, `starter-cache`, etc...

We can also override version of transitive dependencies by specifying version in `<dependency>` and it won't be taken from `<parent>`.
```xml
<dependency>
	<groupId>com.fasterxml.jackson.core</groupId>
	<artifactId>jackson-databind</artifactId>
	<version>2.4.3</version> <!-- version override -->
</dependency>
```

We can also exclude including some transitive using `<exclusions>` tag. 

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-web</artifactId>

  <exclusions>
	 <exclusion>
		<groupId>com.fasterxml.jackson.core</groupId>	<!-- use only this line to remove entire group --> 
		<artifactId>jackson-databind</artifactId> <!-- add this line too to specfify a particular artifact to exclude -->
	 </exclusion>
  </exclusions>

</dependency>
```


## Configuration

### Auto-configurations
Spring Boot auto-configures beans based on - dependencies included (contents of classpath), properties defined, other beans created.

**Where are all the configuration classes & default beans stored?**

**Ans:** When you add Spring Boot to your application, there's a JAR file named `spring-boot-autoconfigure` that contains several configuration classes. Every one of these configuration classes is available on the application's classpath and has the opportunity to contribute to the configuration of your application.

This JAR has a pacakage `org.springframework.boot.autoconfigure` where all the _@Configuration_ classes are stored. These configuration classes use _@Conditional_ annotation to include beans.
```java
@ConditionalOnBean(name={"dataSource"})
@ConditionalOnBean(type={DataSource.class})
@ConditionalOnMissingBean(DataSource.class)

@ConditionalOnProperty
@ConditionalOnMissingBean
@ConditionalOnMissingClass
```

### Bean Configuration
We can define our own bean or use properties to ovveride the default one. Ex - `DataSource` bean below.
```java
// 1. define our own DataSource Bean
@Bean
public DataSource dataSource() {		// name doesn't matter; only return type does
	return new EmbeddedDatabaseBuilder().
	setName("AccountDB").build();
}
```
```yaml
# 2. customize default DatSource class with properties file

# Connection settings
spring.datasource.url=
spring.datasource.username=
spring.datasource.password=
spring.datasource.driver-class-name=

# Connection pool settings
spring.datasource.initial-size=
spring.datasource.max-active=
spring.datasource.max-idle=
spring.datasource.min-idle=

# web embedded server configuration
server.port=9000
server.address=192.168.11.21
server.session-timeout=1800
```

### Excluding Bean auto-configurations
```java
@EnableAutoConfiguration(exclude=DataSourceAutoConfiguration.class)
public class ApplicationConfiguration {
	// code
}
```

## Properties
We can set properties via command-line parameters, OS environment variables, `application.properties` file (or `.yml`) inorder of precedence.

If defined in `application.properties` file, they are searched in below order:
1. `/config` sub-directory of working directory
2. working directory
3. `config` package in the `classpath`
4. `classpath` root

This means that the `application.properties` in application classpath will be replaced by the one (if placed) inside `/config` directory. Also, `appliaction.yml` will take precedence over `application.properties` if both are available side-by-side in the same directory.


### Renaming properties file
```java
public static void main(String[] args) {
	System.setProperty("spring.config.name", "foobar");		// file is automatically named foobar.properties
	SpringApplication.run(MasteringSpringBootApplication.class, args);
}
```

### Custom Properties
```java
// POJO
@Component
@ConfigurationProperties(prefix="demo.ex")
public class Demo {
	private String foo;
	public void setFoo(String foo) {
		this.foo = foo;
	}
	public String getFoo() {
		return foo;
	}
}

// property
demo.ex.foo="Lorem Ipsum"

// we can now use getter and setter in other classes to use this POJO
```

We need to have _@EnableConfigurationProperties_ on any one configuration class inorder to use custom properties and that has already happened with Spring Boot's many default auto-config classes getting imported by default so we don't need to specify that explicitly.

### Profiles
If you set any properties in a profile-specific `application-{profile}.properties` will override the same properties set in an `application.properties` file if they both are in the same location.

We can load profiles as follows:
```bash
# setting the property in application.properties (default)
spring.profiles.active=dev

# or select a profile by executing the JAR with param
--spring.profiles.active=dev 
```

Notice that the default profile is always active. So when we run the app, it reads from `application.properties` (default) and then sees `spring.profiles.active=dev` and loads the dev profile **too**. So we can place common properties in default and dev exclusive properties in dev property file as both will be loaded on runtime. Any properties present in both will be overriden by dev's version.

We can have multiple profiles too active atop default profile.

When in production, we often specify profile from command-line and it has the same effect but no hardcoding in `application.properties`. This will work the same ass above loading both default and dev profiles.
```sh
$ java -jar foobar-0.0.1-SNAPSHOT.jar --spring.profiles.active=dev
``` 

We can also specify `@Profile("dev")` on classes and only if the specified profile is active, the class will be used otherwise it will be ignored and default config will be used for that class.

### Getting property values
```java
// property
foo.bar = "FoobarStr"

// in class code
@Value("${foo.bar}")
private String foobar;
```

Do note that the property that is being referred to in @Value tag must exist and corresponding profile loaded otherwise its a compiler-error. e.g. In the above case, `foo.bar` must exist in properties file and its profile must be loaded otherwise compiler-error.

So, its bad to keep properties exclusive to non-default profiles in our code as they will all fail when we load with default profile in future.

### YAML
```yaml
# properties
database.host=localhost
database.user=admin

# yaml
database:
	host: localhost
	user: admin
```

Multiple profiles in a single YAML file:
```yaml
# common to all profiles
database:
	host: localhost
	user: admin
---
# for dev profile
spring.profiles: dev
database:
	host: 1.1.1.1
	user: testuser
---
# for prod profile
spring.profiles: prod
database:
	host: 192.1.1.9
	user: user
```

### Logger
Logging is available in Spring by default provided by `slf4j` (Simple Logging Facade 4 Java) implemented by `Logback`, a successor to the infamous `log4j`. We don't need any dependencies for it separately.

```java
// in Foobar.java

Logger log = LoggerFactory.getLogger(Foobar.class);		// -- line 1

log.trace("A TRACE Message");
log.debug("A DEBUG Message");
log.info("An INFO Message");		// enabled by default
log.warn("A WARN Message");
log.error("An ERROR Message");

// we can use lombok too to avoid line 1 above
@Slf4j
// or
@CommonsLog
```

Control logs using properties
```txt
logging.level.root=TRACE

# package specific:
logging.level.com.test.repository=INFO

# package specific for framework level logs:
logging.level.org.springframework.web=debug
logging.level.org.hibernate=error
```