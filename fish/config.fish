# #
# # Init file for fish
# #

if not status is-interactive
    exit
end

# setup some local directories
set --local DEV_DIR "$HOME/dev"
set --local TOOLS_DIR "$DEV_DIR/tools"
set --local BIN_DIR "$DEV_DIR/bin"

# prepend homebrew to PATH
set --global --prepend --path fish_user_paths /opt/homebrew/bin

# https://github.com/asdf-vm/asdf
#if command -q brew
#	set --global --export ASDF_DATA_DIR "$TOOLS_DIR/asdf"
#	source (brew --prefix asdf)/libexec/asdf.fish
#end

# prepend home-relative dirs to PATH. These have priority over system dirs
set --global --prepend --path fish_user_paths \
	"$BIN_DIR" \
	"$HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin" \
	"$(brew --prefix coreutils)/libexec/gnubin" \
	"$(brew --prefix)/sbin" \
	"$(brew --prefix)/bin"

# initialize variables
set --global --export EDITOR nvim
set --global --export FZF_TMUX_OPTS -p 55%,60%
set --global --export FZF_DEFAULT_COMMAND 'fd . --hidden --exclude ".git"'

# NB: https://xwmx.github.io/nb
set --global --export NBRC_PATH "$HOME/.config/nb/nbrc"
set --global --export NB_MARKDOWN_TOOL "glow"

# https://starship.rs
if command -q starship
  starship init fish | source
end

# https://github.com/ajeetdsouza/zoxide
if command -q zoxide
  zoxide init --cmd j fish | source
end

# start ssh-agent
if test -z (pgrep ssh-agent | string collect)
	eval (ssh-agent -c) >/dev/null
	set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
	set -Ux SSH_AGENT_PID $SSH_AGENT_PID
end


## RTX SETUP
### https://github.com/jdx/rtx

rtx activate fish | source 
