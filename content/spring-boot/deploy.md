+++
title = "Dockerize"
date = 2022-11-09T23:00:00+05:30
weight = 14
+++

Spring Boot docker images are large! Building with `jdk` as the base image, a Hello-World app reaches \~200MB easily.

The so called "Fat" or "Uber" JARs are large because they contain many JDK libraries which may not be even required by the program runnning inside it.

{{% notice tip %}}
Use a `jre` as the base image rather than a `jdk`.
{{% /notice %}}

## Generating Docker Images
### 1. Split the JAR using Layered Dockerfile
- instead of adding the whole JAR to image, we split JAR contents into diff folders and then copy some folders selectively to a fresh new image

```docker
# add and extract the JAR to the /extracted dir inside the jre image
FROM eclipse-temurin:17.0.4.1_1-jre as builder
WORKDIR extracted
ADD target/*.jar app.jar
RUN java -Djarmode=layertools -jar app.jar extract

# take a fresh jre image and selectively copy extracted layers to /application dir inside it
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
Use Maven goal `spring-boot:build-image` goal provided by Maven build plugin (added by default by Spring Initializr) takes care of layering as in above approach implicitly.

- Needs Docker daemon installed and running on the system (via Docker Desktop, Docker CLI, Systemd, k8s etc). 
- Doesn't need a `Dockerfile` to be present in the app directory, it ignores it if present so be careful. The best practices of creating Spring Boot app images are applied automatically by Maven.

Specify image name and other properties in `pom.xml` or with mvn command (shown below)
```sh
$ mvn spring-boot:build-image -Dspring-boot.build.image.imageName=abhishekarya1/myapp
```

### 3. Google Jib Plugin
Configure Google's [Jib plugin](https://cloud.google.com/java/getting-started/jib) and it will build and push the image to Dockerhub or store it locally.

- Doesn't even need Docker to be installed on the machine!
- Doesn't even need a `Dockerfile` to be present! It is highly opinionated and auto-applies best practices when building the image.

## GraalVM Native Image
A 1.5MB Java Container App? Yes you can! by Shaun Smith - Devoxx - [YouTube](https://youtu.be/6wYrAtngIVo)

Reference: https://www.graalvm.org/latest/reference-manual/native-image/

## Deploy
### Dev Env - Docker Compose
Use [Docker Compose](https://docs.docker.com/compose/) to define and run multiple containerized microservices on a single machine using a single `docker-compose.yml` file.

### Prod Env - Docker Swarm and k8s
Use container orchestration tools like [Docker Swarm](https://docs.docker.com/engine/swarm/) or [Kubernetes](https://kubernetes.io/) (k8s) for:
- managing and deploying containers across a cluster of machines (and not only single machine unlike Docker Compose)
- deployment, scaling, networking, and monitoring of containers

## References
- Dockerize Spring Boot Application - SivaLabs - [YouTube](https://youtu.be/5q4w-c2WUv0)
- Dockerize Spring Boot Application - Programming Techie - [YouTube](https://youtu.be/5_EXMJbhLY4)
- Docker + Spring Boot: what you should know - [YouTube](https://youtu.be/APuEFmm8N_g)