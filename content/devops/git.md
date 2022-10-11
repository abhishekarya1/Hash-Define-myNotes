+++
title = "Git"
date =  2020-11-28T15:05:03+05:30
weight = 2
pre = "<i class=\"devicon-git-plain colored\"></i> "
+++

## Version Control Systems
3 types of VCS (Version Control Systems):
- **Local** (Local): only on developer's machine
- **Centralized** (CVCS): only on a centralized remote repo
- **Distributed** (DVCS): entire change history is on every developer's machines as well as a remote repo

Git and Mercurial are the most popular DVCS.

GitHub and BitBucket are most popular tools and environment that use Git under the hood.

## Git - Basics
![stage of tracked files in git](https://i.imgur.com/insn8mY.png)

**States in Git** - Untracked (_new_ files), Modified, Staged, Committed

**Working Tree** - local version of the repository

Git tracks the changes using "snapshots" of files in repository. So if we want to see the contents of a repository at a given time in the past, we can just "checkout" to a commit and our **entire local folder will change** to how the repo files were at that point in time.

`.git` directory - a hidden directory in root of repository that contains info for git to work, like configs, etc...

`.gitignore` - optional file that contains rules for directory and files to be excluded from version control

**HEAD** - points to the latest commit in current branch; only one head is _active_ at a given time, though we can have mutiple heads present

## Git - Commands
### Help

```sh
# open locally stored HTML man page in browser
$ git help <subcommand>			
$ git <subcommand> --help

# view help doc in terminal
$ git <subcommand> -h 				
```

### Staging, Commiting, and Logs
```sh
$ git init

$ git status

# Staging (wildcards allowed)
$ git add <filenames/dirnames>

# Commiting
$ git commit -m "my first commit"

# combine add and commit; won't work if any new file was created and is still untracked
$ git commit -a -m "made changes to existing files only"

# Amending last commit (will overwrite a previous commit)
$ git commit --amend -m "forgot to add a file in repo"

# Pushing to remote (if remote is already set)
$ git push

# View Commit History
$ git log
# Show logs in an ASCII graph
$ git log --graph
```

All commits have a SHA-1 checksum hash. It is proven to **not** be collision resistant anymore but probabilty is really low. Use first few digits of the hash to uniquely identify a commit.

Use **shorthands** to refer to commits insted of actual hash:
```txt
HEAD 		latest commit in the current branch

HEAD^ 		parent of last commit in current branch
HEAD~ 		same as above

HEAD~1 		same as above
HEAD~2 		parent of parent of last commit in current branch
HEAD~n 	 	jump to nth commit from HEAD
```

### Undoing Stuff
Deleting all local commits till `commit_hash` (`commit_hash` not included). Default is `HEAD` when no `commit_hash` is specified in below commands.

When files are **not pushed** to remote yet:
```sh
# Undoing before staging = make file as-in latest commit (can use "git reset --hard" too)
$ git checkout <file/dir>

# Undoing after staging but before commiting = unstage and make file as-in latest commit (can use "git reset --hard" too)
$ git reset <file/dir>
$ git checkout <file/dir>

# Undoing after committing
# remove commits but don't unstage files
$ git reset --soft <commit_hash>

# remove commits and unstages files; default
$ git reset --mixed <commit_hash>

# remove commits, unstage files, and undo any file modifications since!
$ git reset --hard <commit_hash>


# a newer "restore" command is also an alternative of reset but its dangerous (avoid it!)
# default command is equivalent to reset --hard!
$ git restore <file/dir> 

# unstaging
$ git restore --staged <file/dir>
```

When files are **already pushed** to remote:
```sh
# Undoing Committed Changes = reverting
$ git revert HEAD
# or
$ git revert <hash> 
```

### Remote
Remote is nothing but a repository that's not on our system. We can specify which branch of remote we should push to, etc...

Default remote name is `origin`.

When working with a remote repository:
- Local branch = **Tracking branch**
- Remote branch = **Upstream branch**

```sh
# add remote
$ git remote add foobar <URL>

# list all remotes
$ git remote -v

# renaming remotes (change remote name from "origin" to "foobar")
$ git remote rename origin foobar

# remove remote
$ git remote remove foobar

# set upstream of "bar" to "foo"
$ git branch --set-upstream-to=origin/foo bar

# set current tracking branch's upstream branch; req only on first push to remote
$ git push --set-upstream origin foobar
$ git push -u origin foobar  # same as above

# show upstream info of all branches
$ git branch -vv

# pulling from a remote branch (if upstream isn't set)
$ git pull origin master

# pushing to a remote branch (if upstream isn't set)
$ git push origin master

# if upstream has been set, use normal ones
$ git pull
$ git push
```

### Alias
```sh
# Aliases can be set via terminal (using alias command) or by editing ".git/config": 
[alias]
  	co = commit
  	st = status
  	br = branch
  	hist = log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short

```

### Tags
Uniquely named points in Git.
```sh
# view all
$ git tag

# create new lightweight tag
$ git tag v2.0 -m "an optional message"

# create new annotated tag (better as it stores more info about creator)
$ git tag -a v2.0 -m "an optional message"

# remove
$ git tag -d v2.0
```

### Branching

Renaming and deleting branches isn't a good idea when working on a repo that multiple people are using.

```sh
# Create branch
$ git branch <branchname> 
# Checkout to that branch
$ git checkout <branchname>
# Combined
$ git checkout -b <brachname>

# Jump to another branch
$ git checkout foobar

# Goto previous branch
$ git checkout -

# View all local branches
$ git branch
# View all local and remote branches
$ git branch -a
# Deleting branches, we can't delete branch we're currently on (lol!)
$ git branch -d <branchname>
```
```sh
# Go to a previous commit (detached head state)
$ git checkout <hash>
```

Newer `git switch` command (as an alternative to `git checkout`):
```sh
# create a new branch, and checkout to it
$ git switch -c foobar

# jump to another branche
$ git switch master
```

### Merging

**Fast-forward merge**: if the commit we are merging can be just picked up and moved to our current position

**3-way merge**: find a common ancestor of the commit we're merging and current state and create a new commit merging the two histories together  (_merge commit_) (this leads to **merge conflicts**)

_Reference_: https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging

```sh
# goto foobar
$ git checkout foobar
# merge changes from master into foobar
$ git merge master

# alternatively, we can pull too 
$ git pull master
```

`git fetch` just brings the changes and doesn't apply them to files, `git merge` applies the changes onto the files. `git pull` is just fetch followed by merge.


**Merge Conflict** - If we make change to both the branch and master, both are different and Git can't choose which one to keep 
```sh
# resolve conflict manually and add, commit the files or abort the merge
$ git merge --abort

# merge strategy - biased merge with our/their changes only
$ git merge --strategy-option theirs
$ git merge --strategy-option ours

# use strategy on individual files/dirs
$ git checkout --theirs <file/dir>
$ git checkout --ours <file/dir>
```

### Stashing
```sh
# Stashing changes
$ git stash
# View all stashes (latest is stash@{0}, then stash@{1} and so on...)
$ git stash list
# Apply stash (apply but don't remove stash from list)
$ git stash apply stash@{0}
# git stash pop (apply stash and then remove it, if conflict then don't remove)
$ git stash pop stash@{2}
```

### GitHub
```sh
# Clone - download remote repository to local filesystem
$ git clone <repo_url>
```

### TBD
Rebasing

Submodules

Git Internals

RefLogs


## References
https://gitimmersion.com/

[Pro Git - Book](https://git-scm.com/book/en/v2) 

https://www.atlassian.com/git/tutorials

https://learnxinyminutes.com/docs/git/

https://www.packtpub.com/product/git-and-github-the-complete-git-and-github-course-video/9781800204003
 
Most detailed reference: [Docs](https://git-scm.com/doc)