+++
title = "Jenkins"
date =  2022-10-20T13:16:00+05:30
weight = 5
pre = "<i class=\"devicon-jenkins-plain colored\"></i> "
+++

An open source **automation server** which enables developers around the world to reliably build, test, and deploy their software. It is written in Java.

Plugins are used for almost everything. It has a local filesystem on the server it runs and we can place files, JDK, etc.. on it just like a typical linux system.

Search bar isn't just a normal search. we can jump to specific pages using search instead of navigating via UI:
```txt
foobar 14						goto build#14 of foobar job
foobar last failed build		goto last failed build of foobar job
```

### Concepts
```txt
Controller/Master		assigns job stages to agents, stores configs, etc..				
Agent/Slave				executes specific stage(s), often runs on containers

Pipeline				build|test|scan|post-tasks (like a unix pipe)
Jobs, Stage, Step		steps are singular atomic commands - like "echo" 

Triggers				triggering jobs
```

Ref: https://www.jenkins.io/doc/book/glossary/

Connects to GitHub just like Heroku and Netlify, they use GitHub Auth, Jenkins uses Personal Token. We can also store plain credentials in Jenkins settings and use them instead of Github tokens.

### Jenkinsfile
a Groovy Script, executes shell commands (add it manually to code repo)

Ref: https://www.jenkins.io/doc/book/pipeline/jenkinsfile/#creating-a-jenkinsfile

### Jobs and Pipeline
```txt
Freestyle					any kind of singular task(s); can be chained too 
Pipeline					trigger builds for single branch
Multi-branch pipeline		trigger builds for multiple branches
```

**Triggers**: 
```txt
Build after		build after other projects are built
Poll 			Jenkins checks the repo for new commits
Push			push notification is sent from Git on a new commit, uses webooks on GitHub repo
Periodic		Jenkins builds repo at regular intervals; even if there are no new commits
```
Some pipeline steps can run in parallel too, each on a separate agent or all on the same one too.

**Paramerterized Jobs**: We can set environment variables and other parameters in the job while setting it up, and access those parameters in the Jenkinsfile to trigger conditional builds. To supply value to the parameter use "Build with Parameters" option from the left sidebar.

## Spinnaker
Jenkins can deploy to any public cloud provider but we will need plugins to do that. Also its not native to Kubernetes and deployment strategies, configs, and rollbacks may not be straightforward with Jenkins.

We have [Spinnaker](https://spinnaker.io/) that has first-class support for deploying to any public cloud service. It is also a pipeline which can be visualized and it is more suited for kubernetes deployments.

So the build artifacts (JAR) are often provided as input to the Spinnaker pipeline for continuous deployment (CD).

## References
- https://www.jenkins.io/doc/book/
- TechWorld with Nana - [YouTube](https://www.youtube.com/playlist?list=PLy7NrYWoggjw_LIiDK1LXdNN82uYuuuiC)
- Learn Jenkins! Complete Jenkins Course - Zero to Hero - [YouTube](https://youtu.be/6YZvp2GwT0A)