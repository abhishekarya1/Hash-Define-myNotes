+++
title = "Docker"
date =  2022-02-13T20:14:03+05:30
weight = 3
pre = "<i class=\"devicon-docker-plain colored\"></i> "
+++

### Why?
VMs are bulky, take up more RAM and compute power, not easy to hop VMs too inorder to test.
Docker is a platform to run your apps in virtualized environments. Decoupled from and independent of base OS.

### Pros and Cons
**Pros**:
Containers much lightweight than hypervisors
Easier to run and discard

**Cons**:
Adds extra layer, _"I gotta learn devops too now? aww mannn.."_

`Docker Platform - Orchestration -> Engine -> Runtime`

**Docker Architecture**:
- **Docker CLI**: Client -> ReST API
- **Docker Engine**: Docker Daemon -> Runtime (containerd, runc)
- **Docker Registry**

**Image**: Blueprint on how to create a container 

**Container**: Live instance of an image

`Image = Code + Dockerfile`

Dockerfile specifies "recipe" on how to create image

**Open Container Initiative (Linux Foundation)**: Defines and standadizes runtime-spec and image-spec

### Commands
```
$ docker images
List all images in local filesystem
Flags:
-q : only display IDs

$ docker pull <image_tag>
Download an image to local filesystem

$ docker run <image_name>
Run an image (becomes container)

Flags on run command: 
-it	: interactive terminal
-it containerName command : command to run on startup in container
--name foobar	: assign name "foobar" to container  
--rm : remove container after single run
-d	: detached from current terminal, start in background	
-P	: assign open ports of container to random port of host
-p hostPort:containerPort : Map ports to host
-e env_var=VAL: Set environment variable in container

$ docker exec -it <name> command
Execute command in a running container

$ docker stop <name or ID>
Stop a container sending SIGTERM
$ docker kill <name or ID>
Stop a container sending SIGKILL

$ docker start <name or ID>
Start a stopped container (run is different coz it recreates container, doesn't resume it)

$ docker ps
$ docker container ls
List all containers currently running

$ docker ps -a
List all containers currently running and ran previously

$ docker rm cont1 [cont2 ...]
Remove docker containers

$ docker container prune
Remove all stopped containers

Flags: -f can be used with rm and prune to force delete without prompt

$ docker port <name>
View all open ports of container

$ docker rename oldName newName
Rename container

$ docker inspect <name>
Display info about a container

$ docker log <name>
Displays console log of a container
```

### Images

{{% notice info %}}
Containers can have a name beside ID, but images always have a repo name (`username/foobar`). If no username is provided, it is assumend to be `foobar/foobar`.
{{% /notice %}}

**Creating images**: 

From an existing container using commit:
```txt
$ docker commit [-m "message"] containerID username/name:newVersion
```

From folder:
```txt
$ docker build [-t tag] <dir>
dir must contain Dockerfile
```
**Image tags**:
`-t tag` : specify reponame and tag (optional), version number can be like 1.0.1 or "latest" (tag = `username/name:version`)

{{% notice note %}}
If we intend to put it in DockerHub, then name must be `username/name`. Listed under `REPOSITORY` column in Docker CLI.

{{% /notice %}}

Multiple images can have same ID but different repo name since they are just copy of each other.

```txt
$ docker tag source target
Create taerget image from source but with a different tag.

$ docker rmi <name>
Remove image
```
**NOTE**: 
 - We can't delete an image if some container is using it. (obviously!)
 - We can't delete a base image if some other child image derives from it. (obviously!)

Images (child) can be made from other images (base), so when we pull one image it is pulled layer-by-layer. Multiple images can use the same image so they share same layer.

### DockerHub
```txt
$ docker login
username isn't inferred after login

$ docker pull username/name[:version]		
$ docker push username/name[:version]	#implicitly assumed to be name/name:<none> if no username and version is specified
```
When we do `docker pull ubuntu`, it fetches from `ubuntu/ubuntu` (see images section above).

### Dockerfile

**ENTRYPOINT vs CMD**
```yaml
CMD ["python", "main.py"]
Run this command as is i.e. "python main.py"

ENTRYPOINT ["python"]
Run python command on entry and get argument to this command from docker command
i.e. $ docker run myapp main.py
```
**Overriding Cmd with Entrypoint**:
If Dockerfile has same cmd as entrypoint, then argument will be taken from entrypoint.

**Overriding Entrypoint of Dockerfile w/ terminal command**:
```txt
$ docker --entrypoint foo myapp main.py
Overrides entrypoint specified in Dockerfile to "foo"
```

### Networking
**Bridge network**: All container share a single network (bridge) inside host network (default behavior) (ports can be forwared to access app inside container)
**None**: Isolated container and host (`--network=none`)
**Host**: Host and containers operate on same network (i.e. host's) (`--network=host`)

```txt
$ docker network ls
Lists all networks

$ docker network create --driver=bridge --subnet=182.18.0.0/16 --gateway=182.18.0.0 myNetworkName
Creates another network within the host network

$ docker run --network=myNetworkName foobar
Puts container on network
```

When exposing port of container to host using `-p hostPort:containerPort` is not enough if app is listening on `localhost`. Make sure the the app is listening on `0.0.0.0` which means that it listens on every address available.

**Embedded DNS**: Docker host network also has a DNS subnetwork that always runs at `127.0.0.11`. It resolves `name <-> IP` mapping for containers.

- `inspect` a network to know network properties like subnet.
- `inspect` a container to identify network config.

### Storage
We can copy files to/from container and host.

```txt
$ docker cp CONTAINER:SOURCE TARGET
$ docker cp TARGET CONTAINER:SOURCE

/var/lib/docker
|-- aufs
|-- containers
|-- images
|-- volumes
```
Reusability is a major design feature in Docker. Image are created layer-by-layer. Multiple images can use the same image so they share same layer.

**Volumes**:
```txt
$ docker volume create foobar
/var/lib/docker/foobar is created.
```
1) **Volume mount** (if mounting from var/lib/docker/volumes/...)
```txt
$ docker run -v foobar:/location/inside/container containerName
Creates foobar volume if it doesn't exist otherwise mount it.
```
2) **Bind mount**
```txt
$ docker run -v /location/on/host /location/inside/container containerName
Copies host dir to container dir.
```
Newer syntax for bind: `$ docker run --mount type=bind source=/path/on/host target=/path/on/container containerName`

### Docker Compose
Running multiple containers. Specify everything in a `YAML` file.

we use `--link` name:name to link a container we are running to `name` container. We need to link DB, mainApp, etc.. inorder for them to work in tandem.

https://youtu.be/fqMOX6JJhGo?t=5207

### Container Orchestration
Creating multiple containers across multiple hosts, managing them, scaling up or down acc to load.

Ex - Docker swarm, Kubernetes (k8s), etc...

### References
- https://docs.docker.com/get-started/overview/
- https://docker-curriculum.com/
- Detailed cheatsheet - https://dockerlabs.collabnix.com/docker/cheatsheet/
- Docker compose cheatsheet - https://devhints.io/docker-compose
- https://youtu.be/17Bl31rlnRM [KK]
- https://youtu.be/fqMOX6JJhGo [freeCodeCamp]

**Practice**:
- https://kodekloud.com/p/docker-labs
- https://www.katacoda.com/courses/docker/playground