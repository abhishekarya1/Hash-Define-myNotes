+++
title = "GitHub Actions"
date =  2025-07-28T19:19:00+05:30
weight = 6
pre = "<i class=\"devicon-githubactions-plain colored\"></i> "
+++

## GHA Code Tricks
Inspiration - https://yossarian.net/til/category/github-actions/ (HN Post - https://news.ycombinator.com/item?id=43617493)
- conditional using || in runs-on
- secrets to env vars
- github-script@v7 action
- dynamic step name with ${{ }} 
- matrix "include" trick
- workflow_dispatch without default branch with on push trigger once
- raw github content URL
- all actions get checked out even if we use only one from a repo!
- dynamically create matrix with a JSON
- rerunning wf runs doesn't fetches and runs updated wf code!, but takes updated actions (and callable wf code; if ref remains same), can't change action amidst a workflow run (even if we push code before that action is called), we can also see frozen wf code for a run but it redirects to current code on clicking "Edit"
- no "shell" required for "run" in wf but required in action!
- fromJSON() - converts a JSON string to object (equiv to JSON.parse() in JS) | toJSON() - converts a JSON object to pretty-printed string (equiv to JSON.stringify() in JS)
- fromJSON() - only one time needed, then access from JSON using dots (https://github.com/UKGEPIC/devx-quality-gha-lib-poc/blob/6233b970fb0240f8c78dcdae0d1ef4ff90f7a48c/.github/workflows/hello-world.yml)
- env context (you set it in wf) vs vars context (OS and GHA Context variables)
- Lesser used contructs - defaults:, concurrency:
- progress bar and link at end trick
- cancelling workflows - depends on last job results (https://docs.github.com/en/actions/managing-workflow-runs-and-deployments/managing-workflow-runs/canceling-a-workflow) and thus may not always work. Marked with always() don't cancel!
- workflow_dispatch can only have a max of 10 input params, pass some of them as JSON to bypass (bad practice), workflow_call can have infinite input params
- scheduled workflow expects hardcoded inputs apparently (doesn't even take default from inputs params; use || upon use to specify defaults)
- dynamic matrix with 2 values (aka matrix on array of JSON objects) - https://github.com/UKGEPIC/engx-quality-platform/actions/runs/14573676935
https://github.com/UKGEPIC/GHA-Observability-2/blob/cee9c2b4254e40e8639c0b1102d519e472b3466e/.github/workflows/collect-results.yml
- strategy.job-index and strategy.job-total (strategy context)
- core.setOutput() works in Node action without declaring outputs in action.yml but not in composite action. (https://stackoverflow.com/questions/74448200/how-to-set-dynamically-outputs-variables-in-a-composite-action)
- required: true is not enforced in action.yml, but enforced in workflows!  (no warns either; silent!) (https://stackoverflow.com/questions/68804484/why-are-required-inputs-to-github-actions-not-enforced)
warn in annotations for additional inputs not in action.yml
error for required inputs not present and on additional inputs in wf!
- workflow_dispatch payload says invalid input on numbers passed without quotes, its valid JSON but apparently not allowed in JSON payload for wf_dispatch, put in "" to resolve
- workflow commands and summary annotations - https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/workflow-commands-for-github-actions#about-workflow-commands
- booleans are wonky (https://github.com/actions/runner/issues/1483). Work as expected in wf_call, idk in action or wf_dispatch.
- jobs dependent on other jobs (needs) gets skipped if parent skips! (use "&& always()" in condition to avoid) (https://stackoverflow.com/questions/69354003/github-action-job-fire-when-previous-job-skipped)
- continue-on-error on job level vs step level behaves diff when setting red/green icons - https://stackoverflow.com/questions/62045967/is-there-a-way-to-continue-on-error-while-still-getting-correct-feedback
- when using a job with matrix strategy, the matrix value(s) are auto appended to the job name in GH browser view... use matrix values explicitly in the job name to avoid this auto append (https://futurestud.io/tutorials/github-actions-customize-the-job-name)
- event based wf triggers like workflow_run don't have inputs
- read JSONSCHEMA for action.yml or workflow.yml to know more about possibilites
- Dump Context into JSON for inputs (https://stackoverflow.com/a/62805013)
- Workflows can't be segregated into directories, they have to live in .github/workflows

## OSS contribs
- https://www.npmjs.com/package/nightwatch-extended-junit-reporter
- https://github.com/SamhammerAG/TrxToHtml
- https://github.com/corentinmusard/otel-cicd-action
- GitHub Actions Docs
- Nightwatch.js Docs
- https://github.com/refined-github/refined-github
- Publish some useful GH Actions to Marketplace

## Vulnerabilities
- https://yossarian.net/til/post/actions-checkout-can-leak-github-credentials/
- https://snyk.io/blog/reconstructing-tj-actions-changed-files-github-actions-compromise/
- https://snyk.io/blog/exploring-vulnerabilities-github-actions/
