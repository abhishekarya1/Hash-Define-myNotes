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
``` 

### Actuator
We can inspect internals of a Spring Boot app during runtime in two ways - by **provided API endpoints** or by **opening a secure shell (SSH) session into the application**.

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

### Maven commands
```sh
$ mvn compile	# compile; classes placed in /target/classes
$ mvn test		# compile test and run them
$ mvn test-compile	#compile tests but don't execute them
$ mvn package	# generate JAR
$ mvn install	
# install the artifact (JAR) to userhome/.m2/repository after compile,test,etc.. for use as a dependency in other projects locally
$ mvn clean		# delete /target
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
			<groupId>com.fasterxml.jackson.core</groupId>
		</exclusion>
	</exclusions>

</dependency>
```


## Configuration

### Auto-configurations
Spring Boot auto-configures beans based on - dependencies included (contents of classpath), properties defined, other beans created.

**Where are all the configuration classes & default beans stored?**

**Ans:** When you add Spring Boot to your application, there's a JAR file named `spring-boot-autoconfigure` that contains several configuration classes. Every one of these configuration classes is available on the application's classpath and has the opportunity to contribute to the configuration of your application.

The auto-config JAR has many @Configuration classes that use @Conditional annotation to include beans.
```java
@ConditionalOnBean(name={"dataSource"})
@ConditionalOnBean(type={DataSource.class})
@ConditionalOnMissingBean(DataSource.class)

@ConditionalOnProperty
@ConditionalOnMissingBean
@ConditionalOnMissingClass
```

### Bean Configuration
We can define our own bean or use properties to customize default beans. Ex - `DataSource` bean below.
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
We can set properties via command-line parameters, OS environment variables, application.properties file (or .yml) inorder of precedence.

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
@ConfigurationProperties("demo.ex")
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

We can load profiles while running the JAR as follows:
```bash
# setting the property
spring.profiles.active=dev

# or select a profile by executing the JAR with param
-Dspring.profiles.active=dev 
```

We can also specify `@Profile("dev")` on configuration classes and only if the specified profile is active, the class will be used otherwise it will be ignored and default config will be used for that class.

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