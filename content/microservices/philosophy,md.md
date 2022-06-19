+++
title = "Philosophy"
date = 2022-06-19T11:54:00+05:30
weight = 2
+++

Netflix is one of the companies who have moved away successfully and entirely to cloud and in the process they leveraged and developed Microservices development best practices, tools (Netflix OSS), and guidelines.

### Resources
https://microservices.io

https://martinfowler.com/articles/microservices.html

Mastering Chaos - A Netflix Guide to Microservices [[YouTube](https://youtu.be/CZ3wIuvmHeM)]

### Microservices Tools
- Registry and Discovery Server (Eureka)
- Config Server (GitHub)
- Circuit Breaker (Hystrix is deprecated; Resilience4j is latest)
- Load Balancer (Feign Client)
- Logging & Tracing (Sleuth & Zipkin or ELK Stack)
-  API Gateway (Zuul is deprecated; Spring Cloud Gateway API is latest)

_Reference_: https://javatechonline.com/microservices-architecture/#Common_Tools_Frameworks_with_Spring_Cloud

### The 12-Factor App
Methodology to build scalable SaaS apps. Drafted by developers at Heroku and first presented in 2011.

Website: https://12factor.net

A good guide with visuals and short descriptions: https://www.redhat.com/architect/12-factor-app

In Spring Boot: https://www.baeldung.com/spring-boot-12-factor 