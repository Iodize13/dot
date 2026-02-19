#!/bin/sh

usermodmap=$HOME/.Xmodmap
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

# if [ -f $sysresources ]; then
#
#     xrdb -merge $sysresources
#
# fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

[ -f "$HOME/profile" ] && source "$HOME/profile"

emacs --daemon &
sxhkd &
# $TERMINAL -e tmux new-session -A -s main &
$TEMRINAL &

# Invidious
# podman restart 94dfc4181e7f & podman restart babcd77d56b2 &
redshift -l 21.028382:105.853734 &
# autossh -M 10900 -fN -o "PubkeyAuthentication=yes" -o "StrictHostKeyChecking=false" -o "PasswordAuthentication=no" -o "ServerAliveInterval 60" -o "ServerAliveCountMax 3" -R iodize13.com:10022:localhost:22 ionize13@iodize13.com &
brave &
setxkbmap -option caps:escape &
discord &
# setsid compton --blur-background &
setsid compton &
xwallpaper --zoom $HOME/wal/wallhaven-yqxzqx.jpg &
dwmblocks &
messenger &
# whoami > /home/ionize13/check-pwd.txt &
exec dwm
