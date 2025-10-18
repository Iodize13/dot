#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
# userprofile=$HOME/.xprofile
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then

    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then

    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# if [ -f "$userprofile" ]; then
#     . "$userprofile"
# fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

sxhkd &
# $TERMINAL -e tmux &
$TERMINAL &

#--------------- wallpaper --------------------
# xwinwrap -g 1366x768 -ni -s -nf -b -un -argb -- gifview -w WID $HOME/wal/171450.gif -a &

# Invidious
# podman restart 94dfc4181e7f & podman restart babcd77d56b2 &
redshift -l 21.028382:105.853734 &
# autossh -M 10900 -fN -o "PubkeyAuthentication=yes" -o "StrictHostKeyChecking=false" -o "PasswordAuthentication=no" -o "ServerAliveInterval 60" -o "ServerAliveCountMax 3" -R iodize13.com:10022:localhost:22 ionize13@iodize13.com &
# xcompmgr &
# GTK_THEME=Adwaita:dark gvim &
brave &
setxkbmap -option caps:swapescape &
thunderbird &
xwallpaper --zoom $HOME/wal/hina-snow-white.jpg &
startlxde
# exec gnome-session
