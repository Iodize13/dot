#!/bin/sh
# System files outside $HOME (needs root). Waterfox autoconfig is copied, not linked.
set -e
cd "$(dirname "$0")"
sudo ln -sf "$PWD/xorg/00-keyboard.conf" /etc/X11/xorg.conf.d/00-keyboard.conf
sudo install -m644 waterfox/waterfox.cfg /opt/waterfox/waterfox.cfg
sudo install -m644 waterfox/local-settings.js /opt/waterfox/defaults/pref/local-settings.js
