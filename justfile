default:
  @just --list --unsorted --justfile {{justfile()}}

# show the terminals colors
what-colors:
  msgcat --color=test

branch := "main"
git-host := "https://github.com"

# add a submodule to the repo
submodule-add repo target:
  git submodule add -b {{branch}} {{git-host / repo + ".git"}} {{target}}
  git commit -m "{{"added submodule " + repo}}"

# delete a submodule from the repo
[confirm]
submodule-delete target:
  git submodule deinit {{target}}
  git rm {{target}}
  rm -rf {{".git/modules" / target}}
  git commit -m "{{"removed submodule " + target}}"
    
submodules-init:
  git submodule update --init --recursive

submodules-update:
  git submodule update --init --remote
