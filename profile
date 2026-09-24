#!/bin/sh

export TERMINAL=kitty

_have() { type "$1" &>/dev/null; }

set-editor() {
	export EDITOR="$1"
	export VISUAL="$1"
	export GH_EDITOR="$1"
	export GIT_EDITOR="$1"
	export SYSTEMD_EDITOR="$1"
}
_have "vim" && set-editor vim
_have "nvim" && set-editor nvim

# src: https://github.com/dylanaraps/clutter-home
export XDG_CONFIG_HOME=~
export XDG_DATA_HOME=~

export PATH="$HOME/.local/bin:$PATH"

# Named Emacs daemon (started in ~/.xinitrc); emacsclient picks this up automatically
export EMACS_SOCKET_NAME=main
