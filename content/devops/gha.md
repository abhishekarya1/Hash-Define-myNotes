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

### Workflow Commands
Send commands like error messages to runner.

```yaml
run: echo "::error:: This message will be displayed in logs."

# error message with params
run: echo "::error title=foobar, file=app.js, line=2 :: This message will be displayed in logs."
# debug message (shows up only when debugging is enabled)
run: echo "::debug title=foobar, file=app.js, line=2 :: This message will be displayed in logs."

# grouping (shows up as a group in logs)
run: |
  echo "::group:: My group title"
  echo "Inside group"
  echo "::endgroup::"
```

### Shells and Working Directories
Ubuntu runner will use `bash` but Windows will use Powershell (`pwsh`).

We can add this at any level - workflow, job or step. Also optionally specify a working dir for the shell.
```yaml
default:
  run:
    shell: bash
    working-directory: /home/foo
```

We can also add `python` as shell and run python commands.

### GitHub Repo Contents

{{% notice info %}}
Repository contents are not copied over to the runner automatically! We've to setup cloned local repo manually using `git` commands, or use Actions.
{{% /notice %}}

## Actions
Actions are used as steps, and their output can be referenced in other steps as well.

```yaml
steps:
  - name: A step that runs an action
    uses: username/reponame@branch		# branch, commit_hash, or version
    id: greet						# custom unique id (optional)
    with:
  	  who-to-greet: Heisenberg		# action params (documented by action provider)

  - name: Another step that uses above action's output
  	run: echo "${{ steps.greet.outputs.time }}"		# output name (time) is documented by action provider
```

Therefore inorder to checkout to our repo code on the runner filesystem using Action we create a step as follows, notice that `name` for action steps is optional:

```yaml
steps:
  - name: List Files Before
    run: ls -a
  
  - uses: actions/checkout@v4

  - name: List Files After
    run: ls -a
```

## References
- https://github.com/abhishekarya1/gha-test/
- [Udemy Course](https://www.udemy.com/course/github-actions/)
- https://www.actionsbyexample.com/
- https://learnxinyminutes.com/docs/yaml/