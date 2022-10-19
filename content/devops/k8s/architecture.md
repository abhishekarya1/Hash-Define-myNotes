+++
title = "Architecture"
date = 2022-02-20T23:18:30+05:30
weight = 1
+++

### Kubernetes (k8s)
Open-source **container orchestration** system for **automating** software deployment, **scaling**, and **management**.
Originally developed by Google, open-sourced in 2014, maintained by CNCF.

glossary: canary deployment, rolling-updates, load-balancing, fault-tolerance, service discovery, configuration management, self-healing.

Ref: https://kubernetes.io/docs/concepts/overview/what-is-kubernetes/

### Architecture
Ref: https://kubernetes.io/docs/concepts/overview/components/
![k8s](https://i.imgur.com/6HeWe9e.png)
<caption>Image: a k8s cluster</caption>

**Components**:

**kubectl** - we interact with this in CLI, its a tool
 
**Cluster**- collection of a control plane (Master in above image) and one or more worker nodes

**Control plane**:
- **API server** - exposes control plane to CLI and only component which interacts with worker nodes directly
- **etcd** - persistent key-value store contains cluster meta-data
- **scheduler** - assigns pods to nodes, just like a CPU scheduler
- **controller manager** - manages and maintains worker node, multiple controllers handle diff tasks, clubbed under one name. Functioning: Runs control loops (as in robotics) to continuously match the specified state to actual state of all the objects in the system.

**Node**:
- **kube-proxy** - contains networking info about containers on worker
- **kubelet** - it makes sure that containers are running in a pod
- **container runtime** - docker, containerd,  etc...

### Pod
Smallest unit deployable and manageable by k8s. It represents a running process on the cluster.
`Pod = container + unique IP + storage volumes`
Each worker node can have multiple pods and each pod can have multiple containers. Better to keep single container per pod. Gets it own IP address everytime it goes up.

### References
- https://kubernetes.io/docs/concepts/
