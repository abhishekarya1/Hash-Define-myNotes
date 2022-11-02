+++
title = "Docker"
date =  2022-02-13T20:14:03+05:30
weight = 3
pre = "<i class=\"devicon-docker-plain colored\"></i> "
+++

### Why?
VMs are bulky, take up more RAM and compute power, not easy to hop VMs too inorder to test.
Docker is a platform to run your apps in virtualized environments. Decoupled from and independent of base OS.

**Containers**: Lightweight standalone runtime environment having only parts of the “full” kernel. Ex - Docker, LXC, etc… Kernel is “trimmed down” and contains only libraries and tools required for a specfic use case.

![](https://i.imgur.com/prJGvDM.png)

_Reference_: [/linux/virtual/#virtualization](/linux/virtual/#virtualization)

### Pros and Cons
**Pros**:
- Containers much lightweight than hypervisors

- Easier to run and discard; take up less system resources

- Dependency bundling is effortless

**Cons**:
- Adds an extra layer of tooling


**What is Docker?** an open-source _**platform**_ for creating, deploying, and managing containers. It can run only on Linux, so Windows uses WSL, and MacOS uses a lighweight Linux VM to run it.

`Docker Platform - Orchestration -> Engine -> Runtime`

### Architecture
- **Docker CLI**: Client (`docker`) - communicates with Docker Daemon via REST API, thus client can be remote too
- **Docker Engine**: Docker Daemon (`dockerd`) -> Runtime (`containerd`, `runc`)
- **Docker Registry**: stores images 

**Image**: Blueprint on how to create a container 

**Container**: Live instance of an image

`Image = Code + Dockerfile`

Dockerfile specifies "recipe" on how to create image

**Open Container Initiative (Linux Foundation)**: Defines and standadizes runtime-spec and image-spec

### Commands
```txt
$ docker info
Display client and server system info

$ docker images
List all images in local filesystem

$ docker pull <image_tag>
Download an image to local filesystem

$ docker run <image_name>
Run an image (becomes container; runs and exits immediately by default)

Flags on run command: 
-it                             open "interactive terminal" on container inside the current terminal
--name foobar                   assign a unique name "foobar" to container, else a random name is automatically assigned  
--rm                            remove container after single run
-d                              detached from current terminal, start in background	
-P                              assign open ports of container to random port of host
-p <hostPort>:<contnrPort>      maps a port to host
-e env_var=VALUE                set environment variable in container

$ docker run -it <name> command
Run and execute command in container

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
List currently running containers

$ docker ps -a
List all containers currently running and ran previously

$ docker rm cont1 [cont2 ...]
Remove stopped containers

$ docker container prune
Remove all stopped containers

$ docker port <name>
View all open ports of container

$ docker rename oldName newName
Rename container

$ docker inspect <name>
Display info about a container or image

$ docker logs <name>
Displays console log of a running container
```

### Images

**Creating images**: 

From an existing container using commit:
```txt
$ docker commit [-m "message"] containerID tag
```

From a directory:
```txt
$ docker build [-t tag] <dir>

dir must contain a non-empty Dockerfile
```

**Image tags**:

- `-t <tag>` : specify a tag (_optional_ but default name is `<none>`), version number can be like 1.0.1 or "latest" (_default_) (**TAG** = `[username/]name:[version]`)

{{% notice note %}}
If we intend to pull/push it to **DockerHub**, then `username` in the tag **isn't optional**. The full repo name (`username/name`) must be Listed under `REPOSITORY` column in Docker CLI. Otherwise it will try to pull/push to `library/name` (Docker official repository) and end in failure. 
{{% /notice %}}

Multiple images can have same ID but different names if they're just copy of each other.

```txt
$ docker tag <source> <target>
Create a new image from source but with a different tag (both have same IDs)

$ docker rmi <name>
Remove image
```
{{% notice note %}}
Images (child) can be made from other images (base), so when we pull one image it is pulled layer-by-layer. Multiple images can use the same image so they share some layers.
{{% /notice %}}

**Deleting Images**:
 - We can't delete an image if some container is using it. (obviously!)
 - We can't delete a base image if some other child image derives from it. (obviously!)


### DockerHub
```txt
$ docker login
username isn't inferred in the below commands even after login

$ docker pull username/name[:version]		
$ docker push username/name[:version]	# version is implicitly assumed to be "latest" if its not specified
```

Registries are also provided by Azure, Google Cloud, AWS to store images for enterprise wide access only.

### Dockerfile

**ENTRYPOINT vs CMD vs RUN**
```yaml
CMD ["py", "main.py"]
# run this command as is i.e. "python main.py"
# there can only be one CMD in a Dockerfile, otherwise only the last one will execute

ENTRYPOINT ["py"]
# run python command on entry and get argument to this command from "docker run" command's arguments
i.e. $ docker run myapp main.py
# used to run containers as a standalone executable with command-line arguments and everything

RUN <command>
# run a command inside the container's shell

RUN ["py", "main.py"]
# run an executable inside the container

# RUN can execute multiple times but CMD or ENTRYPOINT runs only once in a Dockerfile
```
**ENTRYPOINT overrides CMD**:
If Dockerfile has the exact same CMD as ENTRYPOINT, then argument will be taken from ENTRYPOINT.

**Overriding Entrypoint of Dockerfile w/ terminal command flag**:
```txt
$ docker run --entrypoint foo myapp main.py

overrides entrypoint specified in Dockerfile to run "foo" executable in container
```

_Cheatsheet_: https://kapeli.com/cheat_sheets/Dockerfile.docset/Contents/Resources/Documents/index

_Sample_: https://github.com/abhishekarya1/docker-test-app/blob/master/Dockerfile

### Networking
- **Bridge network** (_default_): All containers share a single network (bridge) inside host's network (ports can be forwared to access app inside container)
- **None**: Every container as well as host are isolated (`--network=none`)
- **Host**: Host and all containers operate on same network (i.e. host's) (`--network=host`)

```txt
$ docker run --network=none foobar
Run a container on type of network

$ docker network ls
List all networks

$ docker network create --driver=bridge --subnet=182.18.0.0/16 --gateway=182.18.0.0 myNetworkName
Creates another network within the host network

$ docker run --network=myNetworkName foobar
Run a container on a specific network
```

When exposing port of container to host using `-p hostPort:containerPort` is not enough if app is listening on `localhost`. Make sure the the app is listening on `0.0.0.0` which means that it listens on every address available.

**Embedded DNS**: Docker host network also has a DNS subnetwork that always runs at `127.0.0.11`. It resolves `name <-> IP` mapping for containers.

- `inspect` a network to know network properties like subnet.
- `inspect` a container to identify network config.

### Storage
Data on a container is ephemerous. We often copy files to/from container and host.

```txt
$ docker cp CONTAINER_NAME:SOURCE_PATH TARGET_PATH
$ docker cp TARGET_PATH CONTAINER_NAME:SOURCE_PATH
```

**Volumes**: A storage space in the host filesystem which we can use to store data to-and-from the container, so that it persists even after container is stopped.

Volumes are stored in the host's filesystem in `/volumes/<volume_name>` dir in the following path:
```txt
/var/lib/docker
            |-- aufs
            |-- containers
            |-- images
            |-- volumes
```

```txt
$ docker volume create foobar

/var/lib/docker/foobar is created on host filesystem
```
1) **Volume mount** (if mounting from `var/lib/docker/volumes/foobar`) i.e. if a volume is to be mounted
```txt
$ docker run -v foobar:/location/inside/container containerName

Creates volume "foobar" if it doesn't exist, otherwise mount it
```
2) **Bind mount**: any directory can be bind
```txt
$ docker run -v /location/on/host /location/inside/container containerName

Copies host dir to container dir

$ docker run --mount type=bind source=/path/on/host target=/path/on/container containerName

Newer syntax for bind
```

### Docker Compose
Running multiple containers manually is repetitive and mundane. Specify everything in a `docker-compose.yaml` file and manage using `docker compose` commands.

We use `--link redis:redis` to add hostname `redis` to the container we are running so that it is resolvable. We need to link DB, mainApp, etc.. inorder for them to work in tandem (this way to link containers is _deprecated_)

**Commands**: run these in the same directory as the `docker-compose.yaml` file

```yaml
version: "2"

services:
    foo:                                # custom service name
        build: ./foo                    # build from "foo" dir
        command: python app.py          # override CMD and ENTRYPOINT from Dockerfile
        ports:
            - 8080:5000                 # host:container (port mapping)
        volumes:
            - ./foo/appdata:var/lib/data    # mounting volume
        environment:
            - NAME="John Doe"           # setting environment vars
        depends_on:     
            - bar                       # make sure "bar" is running already before "foo"
        links:
            - bar:database              # bar's hostname is "database" in foo
    bar:
        image: redis                    # base image
        ports:                          # declare port (EXPOSE)
            - 6279
```

```txt
$ docker compose build
build images of all containers in compose file

$ docker compose start
start the containers

$ docker compose stop
stop the containers

$ docker compose up -d
build and start in detached mode

$ docker compose down
stop and remove containers

$ docker compose ps
list containers

$ docker compose rm
remove containers

$ docker compose logs -f foo
see logs from container "foo"
```


### Container Orchestration
Creating multiple containers across multiple hosts, managing them, scaling up or down acc to load.

Ex - Docker swarm, Kubernetes (k8s), etc...

### References
- https://docs.docker.com/get-started/overview/
- https://docker-curriculum.com/
- Detailed cheatsheets - https://dockerlabs.collabnix.com/docker/cheatsheet/
- https://youtu.be/17Bl31rlnRM [KK]
- https://youtu.be/fqMOX6JJhGo [freeCodeCamp - Docker Tutorial for Beginners]
- https://youtu.be/kTp5xUtcalw [freeCodeCamp - Docker Containers and Kubernetes Fundamentals]
- https://youtu.be/OU6xOM0SE4o [Docker Networking Crash Course - Hussein Nasser]

**Practice**:
- https://kodekloud.com/p/docker-labs
- https://www.katacoda.com/courses/docker/playground