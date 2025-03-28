+++
title = "Maven"
date = 2022-06-27T08:23:00+05:30
weight = 2
+++


## Maven
Build tool that can perform many tasks such as - defining project structure, dependency management, moving resources, and various build stages like validate, verify, test, package, install etc.

It also provides a variety of plugins to perform diff repetetive tasks.

Reference - https://maven.apache.org/guides/getting-started/index.html

## Installation
Three ways to use Maven:
- standalone
- IDE bundled
- maven wrapper

### Standalone
Download `.zip` and run from command-line in the project directory. 

Needs the `JAVA_HOME` environment variable pointing to a JDK installation, or have the `java` executable on the `PATH` variable. Also, add the `bin` dir to `PATH` in order to use `mvn` command from anywhere (_optional_).
```sh
$ mvn clean install
```

### IDE Bundled
Most IDEs like STS and IntelliJ bundle Maven standalone dir inside them. We just need to run goals using menu provided in the IDE, with zero prior installation and configuration.

### Maven Wrapper
A `mvnw` script file placed in the project root directory (besides the pom.xml). We can run maven goals in command-line directly using the script.
```sh
$ ./mvnw clean install
```

Requires `JAVA_HOME` environment variable configured in the system.

## Maven with Spring
### pom.xml
Project Object Model (POM)
```xml
<project>
	<modelVersion>4.0.0</modelVersion>
	
	<!-- Meta -->
	<groupId>com.example</groupId>
	<artifactId>demo</artifactId>
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

### Maven Lifecycle, Phases, and Goals

Each Maven command has a hierachy of operations it performs: 
- **Lifecycle**: `default`, `clean`, `site`
	- **Phases**: `validate`, `compile`, `test`, `package`, `verify`, `install`, `deploy`
		- **Goals**: more fine-tuned operations inside phases e.g. `mvn install install:install` or `mvn dependency:tree`

{{% notice note %}}
Running a phase also runs all its previous phases too implicitly before running the specified phase. Ex - install runs validate, compile, test, package, and verify.
{{% /notice %}}

Below are some of the most commonly used Maven Build Phases:
```sh
$ mvn compile	# compile using javac; classes placed in /target/classes dir
$ mvn test		# compile test and run them
$ mvn test-compile	# compile tests but don't execute them
$ mvn package	# generate JAR
$ mvn install	
# install the artifact (JAR) to userhome/.m2/repository after compile,test,etc.. for use as a dependency in other projects locally
$ mvn clean		# delete /target directory

$ mvn clean install  # chaining
```

We can also specify custom goals for a particular phase by specifying a `<plugin>` in the pom.xml.

References: https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html#a-build-lifecycle-is-made-up-of-phases

### Maven Dependency Scopes
Maven dependencies can be scoped to provide a much cleaner dependency inclusion (avoid dependency pollution) and optimized build and execution processes. Use `<scope>` tag to specify it (_optional_; `compile` is default when nothing is specified).

Most commonly used scopes are: `compile`, `runtime`, `test` (for starter-test dependencies), `import` (for BOM imports), etc.

Reference: https://www.baeldung.com/maven-dependency-scopes

### Surefire Plugin
The "Maven Surefire Plugin" enables us to run test with maven commands like `mvn test`. The `spring-boot-maven-plugin` added by default by the Spring Initializr takes care of this.

## Dependency Sources
### SNAPSHOT version
`SNAPSHOT` is the latest in the development branch, as soon as it goes to release, `SNAPSHOT` can be removed from the name.

Ex - `foobar-1.0-SNAPSHOT` is released as `foobar-1.0` and new development version becomes `foobar-1.1-SNAPSHOT` now.

### Maven Repositories
**Local repository**: `<userhome>/.m2/repository`, changeable in `settings.xml`.

**Remote repositories**: located on the web or a company's internal server (e.g. JFrog Artifactory). Configure them in `settings.xml` file.

**Central repository**: located on the public web provided by Apache Community (https://mvnrepository.com/)

## Starter Dependencies
**Facet-based dependencies**: Starter dependencies are named to specify the facet or kind of functionality they provide. Ex - `starter-web`, `starter-activemq`, `starter-batch`, `starter-cache`, etc...

Starter dependencies take their version from `spring-boot-starter-parent`'s parent `spring-boot-dependencies` which has `<dependencyManagement>` section and lists versions for every Spring internal dependency, and starters add those dependencies transitively under the hood to the project.

{{% notice note %}}
Transitively adding dependencies is slightly different from the whole "managed dependencies" (`<dependencyManagement>`) discussed below, since in that we need to explicitly declare `<dependencies>` in the project POM too since they aren't automatically added unlike starters.
{{% /notice %}}

We can also override starter's transitive dependencies by explicitly defining them in `<dependencies>` section and specifying the `<version>`. Maven takes the closest definition (_Dependency Mediation_) of a dependency, which is this one.
```xml
<dependency>
	<groupId>com.fasterxml.jackson.core</groupId>
	<artifactId>jackson-databind</artifactId>
	<version>2.4.3</version> <!-- override with version -->
</dependency>
```

We can also exclude some transitive dependencies using `<exclusions>` tag. 
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

### Version
We can:
- explicitly specify version directly in the `<dependency>` tag
- inherit version from parent (parent POM needs to have a `<dependencyManagement>` section); no `<version>` tag is specified in this case
- change parent's version with the `<xxx.version>` tag under `<properties>` section; only works if version is _externalized_ in parent POM and dependency is included in the child POM in `<dependencies>` section or transitively by some other dependency

Externalize dependency version and specify it in the properties tag:
```xml
<properties>
	<mockitoVersionValue>4.5.0</mockitoVersionValue>	<!-- notice here -->
</properties>

<dependencies>
	<groupId>org.mockito</groupId>
	<artifactId>mockito</artifactId>
	<version>${mockitoVersionValue}</version>	<!-- externalizing version to properties tag -->
</dependencies>
```

Change version by specifying another version in `<properties>` section of child POM if version is already externalized in the parent POM.
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
	<dependency>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-test</artifactId>	<!-- this adds Mockito transitively -->
		<scope>test</scope>
	</dependency>
</dependencies>
```

_Reference_: [SivaLabs - YouTube](https://youtu.be/2dPon1G5S-M)

{{% notice note %}}
This is why the Log4j vulnerability ([Log4Shell](https://en.wikipedia.org/wiki/Log4Shell)) was such a big deal. Spring starters and parent may have the vulnerable version depending on the Spring version we're using and it was added to our project transitively by some other dependency. We need to override it with the latest (fixed) version of Log4j in our respective POMs.
{{% /notice %}}

## Parent and dependencyManagement
The `spring-boot-starter-parent`'s parent `spring-boot-dependencies` specifies version for commonly used libraries with Spring and all the other starters.

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

A `<parent>` (more precisely `<dependencyManagement>`) is like only a "declaration" of dependencies, we have to "actually include" them by adding in `<dependencies>` section in child POM in a project and their version is inherited from the parent. We can override version in child POM too (see above section).

We often put `<dependencyManagement>` section and add its dependencies in the `<dependencies>` of the same POM, not much useful but cleaner.

### Multi-Module Maven Project
Multiple modules (projects) inside a single project, each having a different project inside it. All having the same `<groupID>` (_optional but good practice_).

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

**Advantages**: easier to manage dependencies and build plugins, builds all modules when build is triggered for the parent. Projects may still have to be run separately if we want to up the server.

### BOM
BOM (Bill Of Materials) is a POM which contains `<dependencyManagement>` section and is used to supply list of dependencies to other POMs.

There are 2 ways of using a BOM:
- as shown in the cases above, use a `<parent>` tag to **inherit** the BOM in the target POM and declare `<dependencies>` without version (_inherits build plugins and other settings too_)
- **import** the BOM in the target POM as shown below (_preferred way; only imports dependencies_):
```xml
<!-- Project POM -->
<project>
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.my</groupId>
    <artifactId>Test</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>Test</name>
    
    <!-- add this section to Project POM -->
    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>com.sample</groupId>
                <artifactId>sample-BOM</artifactId>
                <version>0.0.5-SNAPSHOT</version>
                <type>pom</type>
                <scope>import</scope>		<!-- notice here -->
            </dependency>
        </dependencies>
    </dependencyManagement>

    <dependencies>
    	<dependency>
    		<!-- add sample-BOM's individual dependencies to import -->
    	</dependency>
    </dependencies>
</project>
```

In complex projects we may need to import multiple BOMs and there is only one `<parent>` tag, so we import BOMs this way. After the import it acts just like parent and we still need to add required dependencies in the `<dependency>` sections.

{{% notice note %}}
Both the parent and the child have a `<dependencyManagement>` tag in the **import** mechanism.

A BOM can NOT be used as an explicit dependency; it MUST be either `<parent>` POM or imported in `<dependencyManagement>` section.
{{% /notice %}}

Advantage of using a BOM is that we can just update the inherited/imported BOM to the latest version and all of the dependencies listed in it will get updated for our project.

_Reference#1_: https://www.baeldung.com/spring-maven-bom

_Reference#2_: https://reflectoring.io/maven-bom

_Reference#3_: https://github.com/FasterXML/jackson-bom

_Reference#4_: https://maven.apache.org/guides/introduction/introduction-to-dependency-mechanism.html#Importing_Dependencies


## Maven Daemon (mvnd)
Maven builds can be slow. To make them faster Apache has created an alternative - `mvnd` built using GraalVM. So its faster and uses less memory than a traditional JVM startup.

It embeds Maven (so no need to install Maven separately), plus its replaceable with traditional Maven in existing projects.

The actual builds happen inside a long living background process, a.k.a. daemon, parallelly on multiple CPU cores. When we trigger a build
for the first time the `mvnd` daemon gets started, current build takes roughly the same time but subsequent builds will noticeably be much faster.

**Link**: https://github.com/apache/maven-mvnd

**Demo**: https://www.mastertheboss.com/jboss-frameworks/jboss-maven/introduction-to-maven-daemon-mvnd/

## Gradle
Modern, more declarative, and unlike Maven it supports [Monorepos](https://monorepo.tools).

Build script (`build.gradle`) is written either in Groovy or Kotlin. It is equivalent of pom.xml here.

`settings.gradle` defines project name and module relationships (in multi-module projects)

**Build Lifecycle Goals**: `clean`, `compile`, `test`, and `build` (equivalent to install goal in Maven)

[Reference Video](https://youtu.be/gKPMKRnnbXU)