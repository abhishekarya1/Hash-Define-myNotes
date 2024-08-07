+++
title = "Logging and Metrics"
date = 2022-11-09T12:29:00+05:30
weight = 4
+++

## Basics
Logging is available in Spring by default provided by **SLF4J** (Simple Logging Facade 4 Java) implemented by **Apache Logback**, successor to the infamous Log4j. We don't need any dependencies for these separately.

```java
// in Foobar.java

Logger log = LoggerFactory.getLogger(Foobar.class);

log.trace("A TRACE Message");
log.debug("A DEBUG Message");
log.info("An INFO Message");		// base level by default; this and all above this are shown
log.warn("A WARN Message");
log.error("An ERROR Message");

log.error("A Message with a value {}", valueVar);	// cleaner syntax with log

// we can use lombok too to avoid line 1 above
@Slf4j		// creates slf4j logger
// or
@CommonsLog	// creates Apache commons log

// logger variable is named "log"
```

Control logs using properties
```txt
# log level for the entire app
logging.level.root=TRACE

# package specific
logging.level.com.test.repository=INFO

# package specific for framework level logs
logging.level.org.springframework.web=debug
logging.level.org.hibernate=error

# group packages
logging.group.foobar=com.test.repository,com.test.service
logging.level.foobar=DEBUG

# log file (created in root dir by default)
logging.file.name=myapp.log
```

### MDC (Mapped Diagnostic Context)
MDC provides a way to enrich log messages with information that could be unavailable in the scope where the logging actually occurs but that can be indeed useful to better track the execution of the program.

What if we want to log _userId_ of every request coming in? We can do so by setting `MDC.put("userId", userId)` and accessing via log pattern so that userId is printed in every line in the console. It is thread-local too, which means it will only remember it for that particular request only.

_Reference_: https://www.youtube.com/watch?v=tmj6QphzAPo&t=1019s

### logback.xml and logback-spring.xml
We can use it to specify logging properties separate from application.properties file.

Old way is to use `logback.xml` and Spring will use that if it is present, otherwise the newer Logback Spring Extension (`logback-spring.xml`) is preferred.

## Metrics
### Prometheus and Grafana
Metrics collection and storage (Prometheus) and metrics and log visualization (Grafana).

Micrometer is the default facade provided by Spring for metrics, just like Slf4j for logs.

1. Expose the micrometer endpoint. `micrometer-registry-prometheus` dependency adds an endpoint `/actuator/prometheus` which lists all metrics for the app
2. The micrometer endpoint is configured in Prometheus running on a diff dedicated server
3. Input the Prometheus server IP in Grafana so that it can fetch data from it for visualization

```txt
SPRING BOOT APP <--polls-- PROMETHEUS <--polls-- GRAFANA
```

Config polling interval and other settings in a `Prometheus.yml` file on the Prometheus server. It has its own local time-series database to store metrics history.

We see logs in Grafana but _without_ the distributed tracing.

We can also configure metrics export to other dashboards and Time-Series DB like Datadog and Influx DB. As well as configure alerts to Slack etc using Web Hooks in case an anomaly is detected.

## Distributed Log Tracing
### Sleuth and Zipkin
We used **Zipkin** and **Sleuth** (_deprecated_) here inorder to trace logs for a request going through multiple services.

Zipkin server JAR is downloaded and runs separately. We need to include Zipkin client and Micrometer dependencies in services.
```xml
<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-sleuth-zipkin</artifactId>
</dependency>

<!-- below is deprecated; in Spring Boot 3.0, use Micrometer dependency -->
<dependency>
  <groupId>org.springframework.cloud</groupId>
  <artifactId>spring-cloud-starter-sleuth</artifactId>
</dependency>
```

```yaml
spring:
  application:
    name: USER-SERVICE
  zipkin:
    base-url: http://localhost:9411		# Zipkin server URL
```

**TraceId** - One ID for a request no matter how many services it calls

**SpanId** - This keeps changing for every service we call in the path while fulfilling a request

```sh
2022-06-20 11:18:54.720  INFO [DEPARTMENT-SERVICE,5ec01b4d1b55f35f,f3aeb60a7471c5af] 21340 --- [nio-9002-exec-1] o.a.c.c.C.[Tomcat].[localhost].[/]

# INFO [service-name, traceId, spanId]
```

We can also create out own Span IDs manually using methods from `spring-cloud-sleuth` (or `micrometer`) (in code).

### ELK Stack

```txt
Step 1 - Logstash 	    	pulls logs from the app
Step 2 - Elasticsearch  	filter logs (index)
Step 3 - Kibana         	UI dashboard
```

All three run on their own dedicated server separate from our Spring Boot app.

_Reference_: [ELK with Spring Boot Microservices - YouTube](https://youtu.be/QZbZDu1xAr8)

### Grafana Stack

```txt
Loki - Log Aggregation
Tempo - Distributed Tracing
Grafana - UI Dashboard
```

Use Prometheus for collecting metrics.

_Reference_: https://programmingtechie.com/2023/09/09/spring-boot3-observability-grafana-stack/

### Other tools
Splunk