+++
title = "Spring Boot 3.0"
date = 2023-05-11T19:09:00+05:30
weight = 16
+++

**Breaking Changes**:
1. Uses Spring Framework 6 and Spring Security 6 under the hood
2. Needs at least Java 17 (we can use `records` now for POJOs)
3. All the components marked `@Deprecated` in Spring Boot 2.x are removed from the code
4. Jump from Java EE to Jakarta EE9: `javax.*` packages are now `jakarta.*`.
5. URL pattern matching changed. URLs terminated with slash (`localhost:8080/foo/`) no longer redirect to non-terminating with slash (_"normal"_) ones (`localhost:8080/foo`). [link](/spring-boot/rest/#slash-terminated-urls-in-spring-boot-30)

**Additions/Improvements**:
1. Spring Native: Maven Build Plugin supports AoT image generation with GraalVM out-of-the-box, without the need for any third-party dependency
2. `ProblemDetail` response object for better error reporting
3. Improvements to Micrometer (`Observability` API): wraps around endpoint responses to observe and gather stats 
4. `@HttpExchange` (exactly like OpenFeign but without the need for any third-party dependency)

### References
- https://www.baeldung.com/spring-boot-3-spring-6-new
- Daily Code Buffer - https://www.youtube.com/watch?v=haVMaDiAGSw
- Java Techie - https://www.youtube.com/watch?v=4_jey1hfEw0
- Tech Primers - https://youtube.com/playlist?list=PLTyWtrsGknYfNg6DSidBAaYUMwpAd9ZqK