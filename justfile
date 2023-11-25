default:
  @just --list --unsorted --justfile {{justfile()}}

branch := "main"
git-host := "https://github.com"
vim-plugin-dir := "nvim/pack/vendor"
vim-target := "start"

vim-submodule-add repo target=vim-target:
  git submodule add -b {{branch}} {{git-host / repo + ".git"}} {{vim-plugin-dir / target / file_name(repo)}}
  git commit -m "{{"added submodule " + repo}}"

[confirm]
vim-submodule-delete name target=vim-target:
  git submodule deinit {{vim-plugin-dir / target / name}}
  git rm {{vim-plugin-dir / target / name}}
  rm -rf {{".git/modules" / vim-plugin-dir / target / name}}
  git commit -m "{{"removed submodule " + name}}"

submodule-add repo target:
  git submodule add -b {{branch}} {{git-host / repo + ".git"}} {{target}}
  git commit -m "{{"added submodule " + repo}}"

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
