+++
title = "Jenkins"
date =  2022-10-20T13:16:00+05:30
weight = 5
pre = "<i class=\"devicon-jenkins-plain colored\"></i> "
+++

It is a server used to automate and facilitate CI/CD

Glossary - Controller, Agent, Jobs, Stages, Steps, Pipeline

Connects to GitHub just like Heroku and Netlify, they use Auth, Jenkins uses Personal Token

Plugins are used for everything, can store Credentials and use them in specific jobs too instead of Github token

Jenkinsfile - a Groovy Script, executes shell commands (add it manually to repo)

----
Jobs 	- Freestyle
	- Single branch pipeline
	- Multi-branch pipeline

Search bar isn't just a normal search - "job_name 14" -- goto build 14 of job_name job
					"job_name last failed build"

----
Triggers - Poll, Push, Periodic

Continuous Delivery - manually deploy in prod
Continuous Deployment -  auto deploy to prod

----
Some pipeline steps can run in parallel too, each on a separate agent or on the same one too.