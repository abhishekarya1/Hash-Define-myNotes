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
Automatically logs into control plane
```

## Namespaces and Pods
```
$ kubectl cluster-info
$ kubectl get nodes
$ kubectl get pods
$ kubectl get namespaces		#alternatively, use "ns"
$ kubectl get pods --namespace=<ns_name>
Default namespace is "default"

Creating pods
$ kubectl run <pod_name> --image=<image_name>
pod/foobar created
creates a pod, plus a deployment

$ kubectl describe pod <name>

$ kubectl get pods -o wide
more info including IP addr of pod

$ kubectl delete pod <name>
```

### Monitoring
```
$ k logs <podName> -c <containerName> [--namespace=<nsName>]
Display logs from a specific container in a pod [in a specific namespace]

$ k get events
$ k get events --watch
Live streaming output

```

## Deployments
Active object status
```
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
`xxxx...` - ReplicaSet, every pod under this replicaset shares this hash
`yyyy...` - hash of individual pod

**Scaling**
```
$ k scale deployment <name> --replicas=5
$ k scale deployment <name> --replicas=3
```

## Addressing using Services
By default we will be able to access pods using their IP from inside their node. But we shouldn't rely on that.

_Solution_: Expose our deployment (all pods) to an IP:port that will be accessible inside node
```
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
```
$ k expose deployment <name> --type=NodePort --port=5000
we will get a random_port mapped, check which one is it using 'k get svc'
```
Access using `minikube ip:<random_port>` or `minikube service <service_name>` to open in browser directly from single command.

### LoadBalancer
When we deploy to cloud, this will assign a loadbalancer IP automatically, works just like NodePort.
```
$ k expose deployment <name> --type=LoadBalancer --port=5000
```

### Rolling Updates
Modify image and push to dockerhub.
```
$ k set image deployment <name> <name>=imageRepoName:version
$ k rollout status deployment <name>

```

### Minikube kubectl Dashboard
```
$ minikube dashboard
```

### Delete all resources
```
$ k delete all --all
```

### YAML: Declarative way to define objects
Fairly easy to understand and write. Use VSCode extension to generate and use the command below to apply to kubectl.

Reference: https://kubernetes.io/docs/reference/kubernetes-api/

```
$ k apply -f <name1>.yml [-f <name2>.yml] ...
f flag specifies the we want to use yaml "file"
```

Instead of finding the YAML file on filesystem, editing it and againd deploying, use below command to all of that stuff for you:
```
$ k edit pod/<name>
$ k edit deployment/<name>
$ k edit service/<name>
```

Combine multiple YAML files into one using `---` separator between them.

### Connecting two Services
We can specify URL as `http://foobar` inside our app and if we have a service named "foobar", it will be resolved to that service's cluster IP automatically! 😎

### Summary
Abstraction levels 
```
Containers - enter using 'docker exec -it <name> sh'
Pods - run, delete, (scaling is handled by deployments)
Node - enter using 'minikube ssh'
Cluster - 'minikube cluster-info'

Deployment - create, scale, set image
Service (No Params) -- exposing deployment, output = ClusterIP, access within cluster
Service (NodePort/LoadBalancer) -- exposing deployment, output = Random port to access deployment from outside cluster
```
### Practice
- https://play.instruqt.com/public/topics/getting-started-with-kubernetes
- https://youtu.be/d6WC5n9G_sM [freeCodeCamp]
