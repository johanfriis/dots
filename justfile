default:
  @just --list --unsorted --justfile {{justfile()}}

# show the terminals colors
what-colors:
  msgcat --color=test

# See wezterm faq: https://wezfurlong.org/wezterm/faq.html#how-do-i-enable-undercurl-curly-underlines
# check terminal support for underline variations
print-underlines:
  printf "\x1b[58:2::235:111:146m\x1b[4:1msingle\x1b[4:2mdouble\x1b[4:3mcurly\x1b[4:4mdotted\x1b[4:5mdashed\x1b[0m\n"

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
