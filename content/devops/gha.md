+++
title = "GitHub Actions"
date =  2024-07-26T12:00:00+05:30
weight = 6
pre = "<i class=\"devicon-githubactions-plain colored\"></i> "
+++

## Intro
A CI/CD pipeline solution much closely integrated with the GitHub platform (can see status in "Actions" tab, configure secrets in Repo settings or organization wide etc). 

## Components
**Workflows**: configurable automated process. Specified as Infrastructure-as-code YAML files stored in code repo path `.github/workflows`.

**Jobs**: a workflow is composed of multiple jobs that run on runners.

**Steps**: a job is composed of multiple steps (ex - a shell command).

**Events**: workflows can be triggered on an event (ex - push, issue), scheduled, calling REST API (call GitHub webhook), or manually.

**Runners**: they are server instances on which the workflow runs. Each runner can run a single job at a time. They can be GitHub hosted, self-hosted (_default_), or Large Runners (hosted and managed by GitHub as premium offering).

**Actions**: they are reusable application for GitHub Actions platform that performs a complex but frequently repeated task. We can write our own actions and publish them publically too.

## Features

### Parallel & Dependent Jobs
Jobs run in parallel independently by default and we can use `needs: another-job-name` in a job to specify dependency.

### Debugging & Skipping
Detailed debug logs are disabled by default. When we manually run jobs, we can enable it by ticking debug logging enabled, or we can set special variables (`ACTIONS_RUNNER_DEBUG`, `ACTIONS_STEP_DEBUG`) in "Settings -> Secret and Variables -> Actions" so that debug logs are shown for every run.

If we want to skip the workflow for a push completely, we can write `[no ci]` or `[skip ci]` in any commit message of that push and workflow won't be triggered if its configured for a push event.

### Secrets & Variables
Store secrets and variables in "Settings -> Secret and Variables" and we can access them in workflow YAML files using `${{ vars.FOOBAR }}` or `${{ secrets.MY_SECRET }}`.

Secrets are masked (hidden with Asterisks) if we try to echo them in the workflow.

## References
- https://github.com/abhishekarya1/gha-test/
- [Udemy Course](https://www.udemy.com/course/github-actions/)
- https://www.actionsbyexample.com/
- https://learnxinyminutes.com/docs/yaml/