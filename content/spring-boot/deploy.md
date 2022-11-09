+++
title = "Dockerize"
date = 2022-11-09T23:00:00+05:30
weight = 13
+++

Spring Boot docker images are large! Building with `jdk` as the base image, a Hello-World app reaches ~200MB easily.


### Dockerfile.layered
- use `jre` as the base image rather than `jdk`
- extract JAR and copy only selective layers into the image

```docker
# extract the JAR
FROM eclipse-temurin:17.0.4.1_1-jre as builder
WORKDIR extracted
ADD target/*.jar app.jar
RUN java -Djarmode=layertools -jar app.jar extract

# copy extracted layers to image
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
```
$ docker build -t foobar-service -f Dockerfile.layered .
```

### Spring Boot Maven Plugin
Run the below command and Maven plugin (added by default by Spring Initializr) takes care of layering as in above approach implicitly.
```
$ mvn spring-boot:build-image -Dspring-boot.build.image.imageName=abhishekarya1/myapp
```

### Jib
Configure Jib plugin and it will build and push the image to Dockerhub or store locally.

### GraalVM & Compression
A 1.5MB Java Container App? Yes you can! by Shaun Smith - Devoxx - [YouTube](https://youtu.be/6wYrAtngIVo)

## Docker Compose
Use Docker Compose to configure and run microservices together.

## References
- Dockerize Spring Boot - SivaLabs - [YouTube](https://youtu.be/5q4w-c2WUv0)
- Dockerize Spring Boot - Programming Techie - [YouTube](https://youtu.be/5_EXMJbhLY4)