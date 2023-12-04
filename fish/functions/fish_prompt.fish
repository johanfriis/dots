function fish_prompt
  show_path
  echo ""
  show_prefix
end

# use tput to move cursor before print
# this aligns right prompt with left
# see: https://github.com/fish-shell/fish-shell/issues/3476#issuecomment-256058730
function fish_right_prompt
  tput sc; tput cuu1; tput cuf 2

  show_git_branch

  tput rc
end

function show_prefix
  set --local prefix_color blue

  if test $status -ne 0
    set prefix_color red
  end

  set_color $prefix_color
  echo -en "❯ "
  set_color normal
end

function show_git_branch

  # never run in home
  if test (pwd) = $HOME
    return
  end

  set ref (command git symbolic-ref --short HEAD 2> /dev/null) || return

  set_color -o blue
  echo -ne " $ref"
end

function show_path
  set_color -o magenta
  echo -en (prompt_pwd)
end

function show_colors
  set_color -o white
  echo -en "white"
  set_color -o black
  echo -en "black"
  set_color -o blue
  echo -en "blue"
  set_color -o green
  echo -en "green"
  set_color -o red
  echo -en "red"
  set_color -o cyan
  echo -en "cyan"
  set_color -o magenta
  echo -en "magenta"
  set_color -o yellow
  echo -en "yellow"
end
