+++
title = "Others"
date = 2023-12-11T14:20:00+05:30
weight = 17
+++

## Other Microservices Frameworks
In the order of popularity:
- [Quarkus](https://quarkus.io/) (by Red Hat)
- [Micronaut](https://micronaut.io/)
- [Helidon](https://helidon.io/) (by Oracle)
- [Vert.x](https://vertx.io/) (by Eclipse)

## Liquibase
Database schema change management tool. In simple words - a version control for DB schema changes. Vendor-agnostic (since we can write in XML, JSON, YAML) unlike Flyway (which only allows `.sql`).

- either run file using CLI client
- or add as Maven dependency to run at application startup

When we deploy our changes, Liquibase creates two tables in the database: `DATABASECHANGELOG` and `DATABASECHANGELOGLOCK`. The former stores detailed logs (id, author, desc, MD5 hash, changeset file name etc) and the latter ensures that only one instance of Liquibase is updating the database.

Each changelog file can contain multiple changesets (SQL queries or equivalent). We can have multiple changelog files as well in a hierarchy that makes sense to our use case.
```txt
/example/
	changelog-foo.xml
	changelog-bar.xml
```

Write changesets in changelog files in SQL, XML, JSON, or YAML. Example below shows `changelog-foo.xml`:
```xml
<include file="com/example/changelog-bar.xml"/>

<changeSet author="your.name" id="4">
    <addColumn tableName="person">
        <column name="nickname" type="varchar(30)"/>
    </addColumn>
</changeSet>
```

The optional `<include>` tag will make sure that Liquibase runs `changelog-bar.xml` first. Used to break down a big file into multiple smaller ones.

Must specify the root changelog file to run using Spring `application.properties` (shown below) or in `liquibase.properties` file (if using CLI client):
```txt
spring.liquibase.change-log=classpath:changelog-foo.xml
``` 

Liquibase will not run any changeset found to be exactly matching the schema in the database. Uses checksum of current changeset and data stored in `DATABASECHANGELOG` table to detect redundancies. Any error or ambiguity causes error in the console.

**References**:
- https://docs.liquibase.com/home.html
- [Using Liquibase with Spring Boot](https://contribute.liquibase.com/extensions-integrations/directory/integration-docs/springboot/springboot/)
- [Flyway and Liquibase - Video Demo](https://youtu.be/KjPlcXkk7xY)

## JOOQ (Object Oriented Querying)
Library that:
- generates Java classes from existing DB schema, and
- build type-safe SQL queries in its own DSL (that emulates SQL in Java)

It is like the opposite of ORMs like Hibernate, where we write code first and then represent DB schema with entity classes, after that database is created or modified. With Jooq, database is existing and we generate Java code using its schema.

When querying, Jooq DSL checks types at compile-time unlike JPQL in JPA.

Jooq works much "closely" to SQL and the DB vendor's dialect, so the reason to use Jooq is to leverage the full power of the database underneath, unlike JPA where the goal is to abstract as much database specific details as possible.

**References**: 
- https://www.baeldung.com/jooq-intro
- https://github.com/jOOQ/jOOQ

## Vaadin Framework
A web framework that allows to write UI code in pure Java! Based on _Web Component_ standard like React, Angular, etc. 

Vaadin offers many other tools too such as Hilla.

Hilla API: Integrates Spring Boot Java backends with reactive frontends implemented in TypeScript. Call Java service code directly from UI code in the browser!

**References**: 
- https://en.wikipedia.org/wiki/Vaadin
- https://hilla.dev

## jgitver
Automatic semantic versioning using Git tags, commits, and branches. No need to change application build version in `pom.xml` everytime as it shows changes (pollutes) in working-tree everytime we create a new version.

Upon `mvn install`, jgitver calculates the new version and writes it to the version info POM inside the generated JAR, and all other relevant spots.

Add to Maven as an extension plugin, or in Gradle as a dependency. Use `mvn validate` to check version calculation.

Link: https://jgitver.github.io

Demo: https://youtu.be/v5Kj0oZO-HM

## Pre-Deployment Scans
**Sonarqube** - code best practices, test coverage, etc

**Veracode** - OWASP security vulnerability

**Twistlock** - Docker container vulnerability

**Snyk** - OWASP security vulnerability

## Post-Deployment Monitoring
**AppDynamics** - performance monitoring

[Metrics & Distributed Logs](../log/#metrics)

