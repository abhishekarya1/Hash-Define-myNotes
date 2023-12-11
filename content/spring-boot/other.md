+++
title = "Other Tools"
date = 2023-12-11T14:20:00+05:30
weight = 17
+++

## Liquibase
Database schema change management tool. In simple words - a version control for DB schema changes. Vendor-agnostic (since we can write in XML, JSON, YAML) unlike Flyway.

- either run scripts using CLI client (_recommended_)
- or add as Maven dependency to run at application startup

When we deploy our changes, Liquibase creates two tables in the database: `DATABASECHANGELOG` and `DATABASECHANGELOGLOCK`. The former stores detailed logs (id, author, desc, MD5 hash, changeset file name etc) and the latter ensures that only one instance of Liquibase is updating the database.

Each changelog file can contain multiple changesets (SQL queries or equivalent). We can have multiple changelog files as well in a hierarchy that makes sense to our use case. All changelog files will be executed by default.
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

The optional `<include>` tag will make sure that Liquibase runs `changelog-bar.xml` first. Used to break down a big file into multiple smaller ones. Specify a single master file to run using Spring properties:
```txt
spring.liquibase.change-log=classpath:changelog-foo.xml
```

Liquibase will not run any changeset found to be exactly matching the schema in the database. Uses `id` attribute of changeset to detect redundancy.

**References**:
- https://docs.liquibase.com/home.html
- [Using Liquibase with Spring Boot](https://contribute.liquibase.com/extensions-integrations/directory/integration-docs/springboot/springboot/)
- https://www.baeldung.com/liquibase-refactor-schema-of-java-app
- [Video Demo](https://youtu.be/GMEWzI34zmU)

## Pre-Deployment Scans
**Sonarqube** - code best practices, test coverage, etc

**Veracode** - OWASP security vulnerability

**Twistlock** - Docker container vulnerability

**Snyk** - OWASP security vulnerability


## Post-Deployment Monitoring
**AppDynamics** - performance monitoring

[Metrics & Distributed Logs](../log/#metrics)