+++
title = "Tools"
date = 2022-11-03T19:00:00+05:30
weight = 3
+++

## Microservices Tools
- Registry and Discovery Server (Eureka)
- API Gateway (Zuul is deprecated; Spring Cloud Gateway API is latest)
- Config Server (GitHub)
- Circuit Breaker (Hystrix is deprecated; Resilience4j is latest)
- Distributed Logging & Tracing (Sleuth & Zipkin or ELK Stack)

_Reference_: https://javatechonline.com/microservices-architecture/#Common_Tools_Frameworks_with_Spring_Cloud


## Service Mesh
Manages everything about microservices in a cluster

**Takes care of** - service registry & discovery, gateway, load balancing, configs, log tracing & metrics, network policies and whitelisting, circuit breaking and retry, etc..

Traffic splitting & canary deployment (aka Rolling upgrades) are easier when we have a service mesh

**Motto** - separate all the above responsibilities from microservice to service mesh framework; that's why microservice don't have hefty code doing all the above (_Single Responsibility Principle_)

### Sidecar proxy
An app is injected and runs alongside our microservice in the same pod, the communication is done between proxy apps

### Istio
[Istio](https://istio.io/) extends Kubernetes to establish a service mesh.

![Istio architecture](https://i.imgur.com/YeeOz0M.png)

- Istio is configured in k8s YAML files, no need to change microservices code
- We just need to config in the control plane, proxies can even work without talking to the control plane
- Envoy proxies communicate using HTTP/2 and gRPC

### Istio Gateway
- Deployed as a service
- Ingress to our cluster from outside - acts as a Load Balancer too

Another famous service mesh implementation is - Hashicorp [Consul](https://www.consul.io/)

### References
- What is a service mesh? - [YouTube](https://youtu.be/QiXK0B9FhO0)
- Istio & Service Mesh - simply explained in 15 mins - [YouTube](https://youtu.be/16fgzklcF7Y)
- Service Mesh: Crash Course on ISTIO - [YouTube](https://youtu.be/Cn2LHqdHwXM)
- Service Mesh Architecture with Istio - [Baeldung](https://www.baeldung.com/ops/istio-service-mesh)