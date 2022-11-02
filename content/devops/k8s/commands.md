+++
title = "Commands"
date = 2022-02-20T23:18:30+05:30
weight = 2
+++

## Minikube
Single node cluster, the node acts as both control plane and worker simultaneously. Useful to test locally.
```txt
$ minikube status

$ minikube start [--driver=hyperv]
By default takes "docker" driver

$ minikube ip
Get IP addr of node (may not match control plane IP)

$ minikube ssh
Automatically logs into control plane/node

$ minikube dashboard
Open a kubernetes UI dashboard in the browser
```

## Namespaces and Pods
```txt
$ kubectl cluster-info
$ kubectl get nodes
$ kubectl get pods
$ kubectl get namespaces		#alternatively, use "ns"
$ kubectl get pods --namespace=<ns_name>
Default namespace is "default"

Creating pods
$ kubectl run <pod_name> --image=<image_name>
creates a pod, plus a deployment

$ kubectl describe pod <name>

$ kubectl get pods -o wide
more info including IP addr of pod

$ kubectl delete pod <name>
```

To execute commands on a container, ssh into the node and do `docker ps` to list all containers running within that node. We can then do `docker exec` to execute commands on a container.

### Monitoring
```txt
$ k logs <podName> -c <containerName> [--namespace=<nsName>]
Display logs from a specific container in a pod [in a specific namespace]

$ k get events
$ k get events --watch
Live streaming events from all pods
```

## Deployments
Active objects
```txt
$ alias k=kubectl

$ k create deployment <name> --image=<image_name>
$ k get deployments			#we can also use "deployment" or "deploy"
$ k describe deployment <name>
$ k delete deployment <name>
Deletes all associated pods and deployment
```
**ReplicaSet**: Manages all pods available in a deployment.

Both pod creation and replicaset are handled while we create deployments, we often do not need to manually create them.

`Name of pod = deploymentName-xxxx-yyyyy`

- `xxxx...` - ReplicaSet, every pod under this replicaset shares this hash

- `yyyy...` - hash of individual pod

**Scaling**
```txt
$ k scale deployment <name> --replicas=5
$ k scale deployment <name> --replicas=3
```

## Addressing using Services
By default we will be able to access pods using their IP from inside their node. But we shouldn't rely on that.

_Solution_: Expose our deployment (all pods) to an `ip:port` that will be accessible inside node
```txt
$ k expose deployment <name> --port=8080 --target-port=5000
port is our public port
target-port is pod port

$ k get services		#or use "svc"
we will have our deployment created into a service and assigned an IP (clusterIP) here

$ k describe svc <name>
```
**NOTE**: unlike the name suggests, ClusterIP is available only inside the cluster 

### NodePort
We can access a service using node's IP from outside if we expose a NodePort.
```txt
$ k expose deployment <name> --type=NodePort --port=5000
we will get a random_port mapped, check which one is it using 'k get svc'
```
Access using `<minikube_ip>:<random_port>` or `minikube service <service_name>` to open in browser directly from single command.

### LoadBalancer
When we deploy to cloud, this will assign a loadbalancer IP automatically, works just like NodePort.
```txt
$ k expose deployment <name> --type=LoadBalancer --port=5000
```

### Access a Service
```txt
$ minikube service <name>

will open the service url at exposed port in the browser
```

## Rolling Updates
```txt
$ k set image deployment <name> <img_name>=<newImageName:version>
$ k rollout status deployment <name>
```

## Delete all resources
```txt
$ k delete all --all
```

## YAML: Declarative way to define objects
Use VSCode extension to generate and use the command below to apply to kubectl.

Reference: https://kubernetes.io/docs/reference/kubernetes-api/

```txt
$ k apply -f foo.yml [-f bar.yml] ...

-f flag specifies that we want to use a yaml "file"

$ k delete -f foo.yml

will delete any object that this file specifies (even if it's running)
```

Instead of finding the YAML file on filesystem, editing it and again deploying, use below command to do all of that stuff for you:
```txt
$ k edit pod/<name>
$ k edit deployment/<name>
$ k edit service/<name>
```

Combine multiple YAML files into one using `---` separator between them.

### Connecting two Services
We can specify URL as `http://foobar` inside our app and if we have a service named "foobar", it will be resolved to that service's cluster IP automatically! 😎

An internal DNS is maintained by kubernetes which resolves hostnames.

### Summary
```txt
Containers - enter using 'docker exec -it <name> sh'
Pods - run, delete, (scaling is handled by deployments)
Node - enter using 'minikube ssh'
Cluster - 'minikube cluster-info'

Deployment - create, scale, set image (rolling-upgrade)
Service (No Params) -- exposing deployment, output = ClusterIP, access within cluster
Service (NodePort/LoadBalancer) -- exposing deployment, output = Random port to access deployment from outside cluster

Write object (deployment, svc, etc...) configs in YAML and "apply" it to create and "delete" it to delete any objects running that are based on the specified YAML file.
```
### Practice
- https://play.instruqt.com/public/topics/getting-started-with-kubernetes
- https://youtu.be/d6WC5n9G_sM [freeCodeCamp - Jan 19, 2022]
- https://youtu.be/kTp5xUtcalw [freeCodeCamp - Oct 12, 2022]

