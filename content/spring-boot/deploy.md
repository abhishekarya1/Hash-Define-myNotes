+++
title = "Dockerize"
date = 2022-11-09T23:00:00+05:30
weight = 14
+++

Spring Boot docker images are large! Building with `jdk` as the base image, a Hello-World app reaches \~200MB easily.

The so called "Fat" JARs are large because they contain many JDK libraries which may not be even required by the program runnning inside it.

{{% notice tip %}}
Use a `jre` as the base image rather than a `jdk`.
{{% /notice %}}

## Generating Docker Images
### 1. Remove Layers of JAR using Dockerfile
- extract JAR and copy only selective layers into the image

```docker
# add and extract the JAR to the /extracted dir inside the jre image
FROM eclipse-temurin:17.0.4.1_1-jre as builder
WORKDIR extracted
ADD target/*.jar app.jar
RUN java -Djarmode=layertools -jar app.jar extract

# selectively copy extracted layers to /application dir inside the jre image
FROM eclipse-temurin:17.0.4.1_1-jre
WORKDIR application
COPY --from=builder extracted/dependencies/ ./
COPY --from=builder extracted/spring-boot-loader/ ./
COPY --from=builder extracted/snapshot-dependencies/ ./
COPY --from=builder extracted/application/ ./
EXPOSE 8080
ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]
```

Build the image with:
```sh
$ docker build -t foobar-service -f Dockerfile.layered .
```

### 2. Maven Build Plugin
Run the below command and Maven build plugin (added by default by Spring Initializr) takes care of layering as in above approach implicitly.

```sh
$ mvn spring-boot:build-image -Dspring-boot.build.image.imageName=abhishekarya1/myapp
```

### 3. Google Jib Plugin
Configure Google's [Jib plugin](https://cloud.google.com/java/getting-started/jib) and it will build and push the image to Dockerhub or store it locally.

**It doesn't even need Docker to be installed on the machine!**

**It doesn't even need a Dockerfile to be present!** It is highly opinionated and auto-applies best practices when building the image.

## GraalVM & Compression
A 1.5MB Java Container App? Yes you can! by Shaun Smith - Devoxx - [YouTube](https://youtu.be/6wYrAtngIVo)

## Docker Compose
Use Docker Compose to configure and run microservices together.

## References
- Dockerize Spring Boot Application - SivaLabs - [YouTube](https://youtu.be/5q4w-c2WUv0)
- Dockerize Spring Boot Application - Programming Techie - [YouTube](https://youtu.be/5_EXMJbhLY4)
- Docker + Spring Boot: what you should know - [YouTube](https://youtu.be/APuEFmm8N_g)