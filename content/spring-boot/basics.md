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
If we include a dependency called `spring-boot-starter-web` it will pull around 8-9 other dependencies that we need to build web apps. We also don't have to care about their versions, compatibility, and updates in future. 

### Spring Boot CLI
Optional component. Provides a way to run a Spring Boot app without a conventional Java project structure, imports and even the need for compilation. Groovy (a Java compatible scripting language) can be used too.

```sh
$ spring --version
$ spring shell		#for auto-completion using TAB
$ spring init
$ spring init -dweb,jpa,security --build gradle output_folder # default is Maven
$ spring init -dweb,jpa -p war	# packaging as WAR instead of JAR default
``` 

### Actuator
We can inspect internals of a Spring Boot app during runtime in two ways - by exposing provided **web API endpoints** or by **opening a secure shell (SSH) session into the application**. 

We have to include `spring-boot-starter-actuator` dependency for this to work.

### Other features
Build tool - Maven or Gradle (provides project structure and dependency management)

Maven is rigid and redundant but reliable.

Gradle is modern but debugging issues can take time.

Web Server - Tomcat or Jetty (to deploy the app onto)

## Spring Initializr
A web app used to generate a demo project for Spring Boot. The project name is always `demo`.

Ways to access -
1. Using [start.spring.io](https://start.spring.io/)
2. Using Initializr via IDE (uses internet connection)
3. Using Spring CLI's `spring init` command (uses internet connection)


## Project Structure
```txt
pom.xml

src.main.java
			com.demo
				 DemoApplication.java
				 controller/
				 dto/
				 repository/impl
				 service/impl

src.main.resources/
			application.properties
			static/
			templates/

src.test.java
			com.demo
				  DemoApplicationTest.java
```

{{% notice note %}}
The `DemoApplication.java` scans only folders on its dir level as shown above. Manually specify package to scan using `@ComponentScan(basePackages = "com.*")` in main application Java file.
{{% /notice %}}

The _DemoApplication.java_ class has a `main()` method and it is used for both **configuration** and **bootstrapping**.
```java
@SpringBootApplication				// configuration
public class DemoApplication {
public static void main(String[] args) {
	SpringApplication.run(DemoApplication.class, args);		// bootstrapping; passing object of current class
}
```

**@SpringBootApplication** - Introduced in Spring Boot 1.2. Includes 3 other annotaions:
1. _@Configuration_: Declare class as a configuration class so that Java or XML configs can be put inside it
2. _@ComponentScan_: Enables recursive auto-scanning of components like @Controller in the current package
3. _@EnableAutoConfiguration_: Auto-config magic of Spring Boot

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
We can define our own bean or use properties to override the default one. Ex - `DataSource` bean below.
```java
// 1. define our own DataSource Bean in any @Configuration class, Spring Boot will automatically register it
@Bean
public AnotherClass myDataSource() {		// name doesn't matter; only return type does
	return new DataSource();
}

// Dependency Injection
@Bean
public DataSource myDataSource(AnotherClass cls) {		// Spring will automatically init AnotherClass Bean before this and use that to init DataSource here
	return new DataSource(cls);
}
```
```yaml
# 2. customize default DatSource class using properties

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

```txt
# define any custom property and use it
foo.bar=1337
```

### Externalize Properties
```txt
foo.bar=${FOOBAR}

first.name=Abhishek
foo.bar=My name is ${first.name}

# supplying a default
server.port=${port:8080}
```
```sh
# via command-line arg
java -jar demo-app.jar --FOOBAR=Abhishek

# via env variables
set FOOBAR=Abhishek
java -jar demo-app.jar

# we often configure helm charts in production to supply them
```

### Renaming properties file
```java
public static void main(String[] args) {
	System.setProperty("spring.config.name", "foobar");		// file is automatically named "foobar.properties"
	SpringApplication.run(MasteringSpringBootApplication.class, args);
}

// another way to do it via command line
$ java -jar myproject.jar --spring.config.name=foobar
```

### Properties to POJO
```java
// POJO
@Component
@ConfigurationProperties(prefix="demo")
public class Demo {
	private String foo;
	private String bar;

	public void setFoo(String foo) {
		this.foo = foo;
	}
	public String getFoo() {
		return foo;
	}

	public void setBar(String bar) {
		this.bar = bar;
	}
	public String getBar() {
		return bar;
	}
}

// property
demo.foo="Lorem"
demo.bar="Ipsum"

// we can now use getter and setter in other classes to use this POJO
// we can also have List, Map, or other POJOs inside ConfigurationProperties classes

// we can also use @ConfigurationProperties on record instead of a class; makes the code much shorter
@ConfigurationProperties(prefix="demo")
public record Demo (String foo, String bar){ }
```

We need to have _@EnableConfigurationProperties_ on any one configuration class inorder to use custom properties and that has already happened with Spring Boot's many default auto-config classes getting imported by default so we don't need to specify that explicitly.

_Reference_: https://www.baeldung.com/configuration-properties-in-spring-boot

### Profiles
If you set any properties in a profile-specific `application-{profile}.properties` will override the same properties set in an `application.properties` file.

We can load profiles as follows:
```sh
# 1. setting the property in application.properties (default)
spring.profiles.active=dev

# 2. or select a profile by executing the JAR with param
--spring.profiles.active=dev 

```
```xml
<!-- 3. or activating profile with POM -->
<plugins>
    <plugin>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-maven-plugin</artifactId>
        <configuration>
            <profiles>
                <profile>dev</profile>
            </profiles>
        </configuration>
    </plugin>
</plugins>
```

Notice that the default profile is always active. So when we run the app, it reads from `application.properties` (default) and then sees `spring.profiles.active=dev` and loads the dev profile **too**. So we can place common properties in default and dev exclusive properties in dev property file as both will be loaded on runtime. Any properties present in both will be overriden by dev's version.

We can have multiple profiles too active atop default profile.

When in production, we often specify profile from command-line and it has the same effect but no hardcoding in `application.properties`. This will work the same as above i.e. **loads both default and dev profiles**.
```sh
$ java -jar foobar-0.0.1-SNAPSHOT.jar --spring.profiles.active=dev
``` 

{{% notice tip %}}
The default profile (`application.properties`) is always loaded. Any other active profile(s) is loaded on top of it.
{{% /notice %}}

We can also specify `@Profile("dev")` or `"!dev"` on classes and only if the specified profile is active, the class will be used/run otherwise it will be ignored.

### Getting property values
```java
// property
foo.bar = "FoobarStr"

// in class code
@Value("${foo.bar}")
private String foobar;

@Value("${foo.bar: defaultStr}")	 // with a default value
private String foobar;

// we can't use @Value on a static variable, if we use, variable will be null at runtime
// we can directly use "${foo.bar}" at some limited places in our code
```

Do note that the property that is being referred to in `@Value` tag must exist and corresponding profile loaded otherwise its a compiler-error. e.g. In the above case, `foo.bar` must exist in properties file and its profile must be loaded otherwise compiler-error. We can provide default value to avoid compiler-error.

So, its bad to keep properties exclusive to non-default profiles in our code as they will all fail when we load with default profile in future.

### Property source
We can specify which property file to take values from using the _@PropertySource_ annotation.
```java
@PropertySource("classpath:foobar.properties")
public class foobarService{	 }

// note that we can't use YAML with this annotation out-of-the-box in Spring
```
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

## Running JARs
```sh
$ java -jar demo-app.jar --server.port=9090
$ java -Dserver.port=9090 -jar demo-app.jar
```