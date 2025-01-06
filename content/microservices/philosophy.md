+++
title = "Philosophy"
date = 2022-06-19T11:54:00+05:30
weight = 2
+++

Netflix is one of the companies that successfully pivoted from its origins as a DVD rental service to fully embracing the cloud, during this transition they developed and refined microservices best practices, tools (Netflix OSS), and guidelines.

### Resources
https://microservices.io

https://martinfowler.com/articles/microservices.html

Mastering Chaos - A Netflix Guide to Microservices [[YouTube](https://youtu.be/CZ3wIuvmHeM)]

When To Use Microservices (And When Not To!) - Sam Newman & Martin Fowler [[YouTube](https://youtu.be/GBTdnfD6s5Q)]

### The 12-Factor App
Methodology to build scalable SaaS apps. Drafted by developers at Heroku and first presented in 2011.

Website: https://12factor.net

A good guide with visuals and short descriptions: https://www.redhat.com/architect/12-factor-app

In Spring Boot: https://www.baeldung.com/spring-boot-12-factor 

Some one-liners:
```txt
Codebase = version-controller text source code
Build = deployed codebase
Release = Build + Config
App is a stateless process
Strict separation of config from code
Explicitly declare dependencies
Keep development, staging, and production as similar as possible
Maximize robustness with fast startup and graceful shutdown, not dependent on any other processes
```

### Cloud-native Apps
1. Microservices pattern
2. 12 factor app guideline
3. API-based communication

Software in the 90s used to be designed for distribution on CDs, it was in stark contrast to cloud-native apps of today which allows for telemetry and rolling upgrades.