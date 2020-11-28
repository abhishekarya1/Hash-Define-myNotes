+++
title = "Git"
date =  2020-11-28T15:05:03+05:30
weight = 1
+++

## Git SCM notes

### Basics
- Many platforms use Git VCS (version control system), some are GitHub, Bitbucket, etc.. 
https://www.geeksforgeeks.org/centralized-vs-distributed-version-control-which-one-should-we-choose/

### Glossary
- **Working Tree** - home directory structure
- `.git` - folder hidden in home directory that contains info for git to work, ex. config, etc...
- **States in Git** - Untracked, Modified, Staged, Commited
- **HEAD** - only one head is _active_ at a given time, though we can have mutiple heads.
### Git

```sh
# Setup
$ git config --global user.name "Your Name"
$ git config --global user.email "your_email@whatever.com"

# Setting line preferences (optional ofcourse)
$ git config --global core.autocrlf true
$ git config --global core.safecrlf true
```

```bash
$ git [command] --help


$ git init

$ git status

# Staging
$ git add <filename/dirname>

# Commiting
$ git commit -m "my first commit"

# combined (won't work if any new file was created and is still untracked)
$ git commit -am "made changes to existing files only"

# Amending Commits
$ git commit --amend -m "forgot to add email comment"
# the above will delete the previous commit and insert fresh one here

# Pushing to remote
$ git push

# History
$ git log

# Cutomize it!
$ git log --pretty=oneline
$ git log --pretty=oneline --max-count=2
$ git log --pretty=oneline --since='5 minutes ago'
$ git log --pretty=oneline --until='5 minutes ago'
$ git log --pretty=oneline --author=<your name>
$ git log --pretty=oneline --all

# Aliases can be set via terminal or via ".git/config" 
[alias]
  	co = checkout
  	ci = commit
  	st = status
  	br = branch
  	hist = log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short
  	type = cat-file -t
  	dump = cat-file -p

# Ignoring files - Any filename added to ".gitignore" will be exempted from vcs
$ echo "temp/" >> .gitignore
$ echo "private_key" >> .gitignore

# Show
$ git show <hash>
#shows data diff on commit

# Go to a previous commit, view hash in log, only a first few chars of the hash will do
$ git checkout <hash>
# Return to latest commit
$ git checkout master
# checkout deletes data from uncommited files but not for commited ones, as shown below

# Tags - specially named points in Git
# View all
$ git tag
# Set new
$ git tag v2-beta
# Jump to a previous tag
$ git checkout v1
# Remove a tag
$ git tag -d v2

# Undoing before staging = checkout file to latest commit
$ git checkout <file_to_undo>
# Undoing before commiting = reset HEAD to clear any staged changes, and checkout to latest commited version
$ git reset HEAD <file_to_undo>
$ git checkout <file_to_undo>
# Undoing Committed Changes = revert to  
$ git revert HEAD
# or
$ git revert <hash> 

# Deleting all commits till <hash>, <hash> not included
$ git reset --mixed <hash> (commits removed, also unstages files)
$ git reset --soft <hash> (not unstaged)
$ git reset --hard <hash> (files will be edited accordingly too)

# Moving Files = either use terminal command (mv) or git mv
$ git mv hello.py lib
# same as
$ mv hello.py ./lib

# Removing files = either use terminal command (rm) or git rm
$ git rm path/to/file/hello.py
# same as
$ rm path/to/file/hello.py

# Branching
# Create branch
$ git branch <branchname> 
# Checkout to that branch
$ git checkout <branchname>
# Combined
$ git checkout -b <brachname>
# Jump across branches
$ git checkout new-brach
$ git checkout master
# View all branches
$ git branch
# Deleting branches, we can't delete branch we're currently on
$ git branch -D <branchname>

# All commits including branch
$ git log --all
# ASCII graph
$ git log --graph

# Merging branches
# Fast-Forward Merge (if no commits happen on master after branch)
# 3-way Merge (if changes happen to branch as well as master simultaneously after branch, can lead to conflicts)
$ git checkout anotherBranch
$ git merge master

# Merge Conflict - If we make change to both the branch and master, both are different and git can't choose which one to keep 
# Refer: https://stackoverflow.com/questions/24852116/how-does-exactly-a-git-merge-conflict-happen
# Resolve conflict manually by editing the files or abort as follows, 
$ git merge --abort

# Rebase (the junction commit or base commit can be changed using rebase, default is rebasing to last commit on target branch)
$ git checkout anotherBranch
$ git rebase master

# GitHub
# Create repo in GitHub in browser
# Connect local repo to remote (git remote add <name_of_remote> <url>)
$ git remote add origin <https://github.com/user/repository.git>

# Pull (git pull <remote> <branch>)
$ git pull origin master
# or set upstream to avoid specifying origin master evrytime
$ git branch --set-upstream-to=origin/master master
# now we can use
$ git pull

# Push to remote (git push <name_of_remote> <branch name>)
$ git push origin master
# or
$ git push


# Collaborating
# Clone - Download remote repository to local filesystem.
$ git clone <https://github.com/user/repository.git>

# Fork - Create a linked remote copy.

# PR (Pull Request) - A request to a change that can be either merged or rejected.
$ 








```