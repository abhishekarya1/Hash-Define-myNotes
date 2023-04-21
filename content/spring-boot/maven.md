+++
title = "Maven"
date = 2022-06-27T08:23:00+05:30
weight = 2
+++


## Maven
Build tool that can perform many tasks such as - defining project structure, dependency management, documentation, and various steps (build targets) like validate, verify, test, package, build, install etc... 

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
		<relativePath/> <!-- lookup parent from repository -->
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
$ mvn test-compile	# compile tests but don't execute them
$ mvn package	# generate JAR
$ mvn install	
# install the artifact (JAR) to userhome/.m2/repository after compile,test,etc.. for use as a dependency in other projects locally
$ mvn clean		# delete /target directory

$ mvn clean install  # chaining
```

References: https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html#a-build-lifecycle-is-made-up-of-phases

## Surefire Plugin
The "Maven Surefire Plugin" enables us to run test with maven commands like `mvn test`. The `spring-boot-maven-plugin` added by default by the Spring Initializr takes care of this.

## Maven Wrapper
A `mwnw` script file placed in the root of the directory besides the `pom.xml`. We can run maven goals using command line directly using this.
```
$ ./mwnw clean install
```

### SNAPSHOT version
`SNAPSHOT` is the latest in the development branch, as soon as it goes to release, `SNAPSHOT` can be removed from the name.

Ex - `foobar-1.0-SNAPSHOT` is released as `foobar-1.0` and new development version becomes `foobar-1.1-SNAPSHOT` now.

### Maven Repositories
**Local repository**: `<userhome>/.m2/repository`, changeable in `settings.xml`.

**Remote repositories**: located on the web or a company's internal server (e.g. JFrog Artifactory). Configure them in `settings.xml` file.

**Central repository**: located on the web provided by Apache Community (https://mvnrepository.com/)


## Starter Dependencies
**Facet-based dependencies**: Starter dependencies are named to specify the facet or kind of functionality they provide. Ex - `starter-web`, `starter-activemq`, `starter-batch`, `starter-cache`, etc...

We can also override the version of starter's transitive dependencies by defining them in `<dependencies>` section and explicitly specifying the version and it won't be taken from `<parent>`.
```xml
<dependency>
	<groupId>com.fasterxml.jackson.core</groupId>
	<artifactId>jackson-databind</artifactId>
	<version>2.4.3</version> <!-- version override -->
</dependency>
```

We can also exclude including some transitive dependencies using `<exclusions>` tag. 

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-web</artifactId>

  <exclusions>
	 <exclusion>
		<groupId>com.fasterxml.jackson.core</groupId>	<!-- use only this line to remove entire group --> 
		<artifactId>jackson-databind</artifactId> <!-- add this line too to specify a particular artifact to exclude -->
	 </exclusion>
  </exclusions>

</dependency>
```

## Parent and dependencyManagement
The `spring-boot-starter-parent` specifies version for commonly used libraries with Spring and all the other starters.

We can specify our own `<parent>` module having all of the dependencies we want to use and their versions in `<dependencyManagement>` section. Other project's POM can then point to this parent's POM and define the same dependencies in their respective POMs without version.

This is how the `spring-boot-starter-parent` works.

```txt
Creating a different module for parent POM:

 .
 |-- my-parent/pom.xml
 |-- my-child/pom.xml
 .
```

```xml
<!-- parent module's POM -->
<groupId>com.my</groupId>
<artifactId>my-parent</artifactId>
<version>1.0-SNAPSHOT</version>
<packaging>pom</packaging>	<!-- notice here -->

<!-- Spring Boot Parent -->
<parent>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-parent</artifactId>
	<version>2.7.0</version>
	<relativePath/>
</parent>

<!-- dependencyManagement Section -->
<dependencyManagement>
	<dependencies>
		<dependency>
			<groupId>junit</groupId>
			<artifactId>junit</artifactId>
			<version>5.0.0</version>
		</dependency>
	</dependencies>
</dependencyManagement>
``` 

```xml
<!-- project that inherits our custom parent's POM -->
<parent>
	<groupId>com.my</groupId>
	<artifactId>my-child</artifactId>
	<version>1.0-SNAPSHOT</version>
	<relativePath>../my-parent/pom.xml</relativePath>	<!-- optional if parent POM is one level above the current POM -->
</parent>

<dependencies>
	<dependency>
		<groupId>junit</groupId>
		<artifactId>junit</artifactId> <!-- no need to specify version here now -->
	</dependency>
</dependencies>
```

**Summary**: Define dependencies in `<dependencyManagement>` section in the parent module. Point to parent pom in child/project and add dependency to `<dependencies>` section without version, the version will be taken from the parent.

A `<parent>` (more precisely `<dependecyManagement>`) is like only a "declaration" of dependencies, we have to "actually include" them by adding in `<dependencies>` in child POM in a project and their `<version>` is inherited from the parent or we can override it by explicitly specifying it in the child POM.

{{% notice note %}}
This is why the Log4j vulnerability ([Log4Shell](https://en.wikipedia.org/wiki/Log4Shell)) was such a big deal. Spring starters and parent may have the vulnerable version depending on the Spring version we're using and we need to override with the latest (fixed) version of Log4j in our respective POMs.
{{% /notice %}}

### Version
We can also externalize dependency version to the properties tag.
```xml
<properties>
	<mockitoVersion>4.5.0</mockitoVersion>	<!-- notice here -->
</properties>

<dependencies>
	<groupId>org.mockito</groupId>
	<artifactId>mockito</artifactId>
	<version>${mockitoVersion}</version>	<!-- externalizing version to properties tag -->
</dependencies>
```
We can specify version directly in the `<dependency>` or leave the version to parent (if parent has `<dependencyManagement>`).

We can also include dependency by specifying only the version in `<properties>` section of child POM. No need to explicitly add dependency in `<dependencies>` section of the child/project POM if we do it this way.

```xml
<parent>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-parent</artifactId>
	<version>2.7.0</version>
</parent>

<properties>
	<mockito.version>4.5.0</mockito.version>	<!-- notice here -->
</properties>

<dependencies>
	<!-- empty -->
</dependencies>
```

**Summary**: One interesting case is when we can only specify version for a dependency in the `<properties>` section of child POM and that will include the dependency from the parent in child POM without the need to add it in the `<dependencies>` section!

This may be counter-intuitive because we're trying to avoid adding version with all this parent and dependencyManagement and here we only add version to include the whole dependency!

_Reference_: [SivaLabs - YouTube](https://youtu.be/2dPon1G5S-M)

### Maven Multi-Module Project
Multiple modules inside a single project, each having a different project inside it. All having the same `<groupID>`.

1. Place common `<dependencyManagement>` and `<build> <plugins>` in parent's POM
2. Add all `<modules> <module>` artifact ids in parent's POM
3. Add parent POM project as `<parent>` in all the modules (child)

```txt
Placing parent POM at root (one level above child POMs):

 . microservice-new
 | -- inventory-service/pom.xml
 | -- product-service/pom.xml
 | -- users-service/pom.xml
 |
 . -- pom.xml
```

**Advantages**: easier to manage dependencies & build plugins and Maven building together. Projects may still have to be run separately if we want to up the server.
