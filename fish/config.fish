##
## Init file for fish
##

if not status is-interactive
    exit
end

set -l os (uname)

# setup some local directories
set --local DEV_DIR "$HOME/dev"
set --local TOOLS_DIR "$DEV_DIR/tools"
set --local BIN_DIR "$DEV_DIR/bin"
set --local LOCAL_BIN_DIR "$HOME/.local/bin"

if test "$os" = Darwin
	# set homebrew binary
	set BREW_BIN /opt/homebrew/bin/brew

	set --global --prepend --path fish_user_paths \
		"$($BREW_BIN --prefix coreutils)/libexec/gnubin" \
		"$($BREW_BIN --prefix)/sbin" \
		"$($BREW_BIN --prefix)/bin"
end

# prepend home-relative dirs and brew dirs to PATH. These have priority over system dirs
set --global --prepend --path fish_user_paths \
	"$BIN_DIR" \
	"$LOCAL_BIN_DIR" \

# initialize variables
set --global --export FZF_TMUX_OPTS -p 55%,60%
set --global --export FZF_DEFAULT_COMMAND 'fd . --hidden --exclude ".git"'

# set default editor
if command -q nvim
	set --global --export EDITOR nvim
else
	set --global --export EDITOR vim
end

# https://github.com/ajeetdsouza/zoxide
if command -q zoxide
  zoxide init --cmd j fish | source
end

# https://github.com/jdx/mise
if command -q mise
  if status is-interactive
    mise activate fish | source
  else
    mise activate fish --shims | source
  end
end

# start ssh-agent
if test -z (pgrep ssh-agent | string collect)
	eval (ssh-agent -c) >/dev/null
	set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
	set -Ux SSH_AGENT_PID $SSH_AGENT_PID
end

if test -f ~/.config/op/plugins.sh
  source ~/.config/op/plugins.sh
end

# source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
#
# if command -q direnv
#   eval "$(direnv hook fish)"
# end

# vim: sw=2 ts=2 et

