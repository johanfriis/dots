##
## Init file for fish
##

if not status is-interactive
    exit
end

# setup some local directories
set --local DEV_DIR "$HOME/dev"
set --local TOOLS_DIR "$DEV_DIR/tools"
set --local BIN_DIR "$DEV_DIR/bin"

# prepend homebrew to PATH
#set --global --prepend --path fish_user_paths /usr/local/bin

# prepend home-relative dirs to PATH. These have priority over system dirs
set --global --prepend --path fish_user_paths \
	"$BIN_DIR" \
	"$(brew --prefix coreutils)/libexec/gnubin" \
	"$(brew --prefix)/sbin" \
	"$(brew --prefix)/bin"

# initialize variables
set --global --export EDITOR nvim
set --global --export FZF_TMUX_OPTS -p 55%,60%
set --global --export FZF_DEFAULT_COMMAND 'fd . --hidden --exclude ".git"'
set --global --export DOTNET_CLI_TELEMETRY_OPTOUT 1
set --global --export MISE_USE_TOML 1

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

# vim: sw=2 ts=2 et

