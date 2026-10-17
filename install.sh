#!/bin/sh
# Link dotfiles into $HOME with GNU stow. Safe to re-run (restows).
# Note: XDG_CONFIG_HOME=$HOME, so app configs live at ~/nvim, ~/yazi, ...
set -e
cd "$(dirname "$0")"
git submodule update --init
stow -v -R -t "$HOME" \
	applications bash bin config discord emacs kanata kitty nvim profile \
	sxhkd tmux vim wezterm xinit yazi zathura zed zsh

# System: cap hibernation image at 6GB (larger = slow hibernate on encrypted swap)
f=/etc/tmpfiles.d/hibernate-image-size.conf
line='w /sys/power/image_size - - - - 6442450944'
if [ "$(cat "$f" 2>/dev/null)" != "$line" ]; then
	echo "$line" | sudo tee "$f" >/dev/null
	sudo systemd-tmpfiles --create "$f"
fi
