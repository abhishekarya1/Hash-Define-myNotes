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
Many beans are always created in all specific-kind of applications and we don't need to create those in Spring Boot explicitly as **it will look at the dependencies included and create those beans for us automatically** e.g. `jdbcTemplate` bean.

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