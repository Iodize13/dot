#!/bin/sh
# Link dotfiles into $HOME with GNU stow. Safe to re-run (restows).
# Note: XDG_CONFIG_HOME=$HOME, so app configs live at ~/nvim, ~/yazi, ...
set -e
cd "$(dirname "$0")"
git submodule update --init
stow -v -R -t "$HOME" \
	applications bash bin config discord emacs nvim profile \
	sxhkd tmux vim wezterm xinit yazi zathura zed zsh
