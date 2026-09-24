#!/bin/sh

# Route GTK file dialogs through xdg-desktop-portal (yazi file picker)
export GTK_USE_PORTAL=1
export GDK_DEBUG=portals  # GTK4 equivalent
export QT_QPA_PLATFORMTHEME=xdgdesktopportal  # Qt6 -> portal file dialogs

usermodmap=$HOME/.Xmodmap
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

# if [ -f $sysresources ]; then
#
#     xrdb -merge $sysresources
#
# fi

[ -f "$HOME/.Xresources" ] && xrdb -merge "$HOME/.Xresources"

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

[ -f "$HOME/profile" ] && source "$HOME/profile"

systemctl --user import-environment DISPLAY XAUTHORITY

# (emacs --daemon '' && emacsclient -c) &
emacs --daemon=main &
sxhkd &
# Invidious
# podman restart 94dfc4181e7f & podman restart babcd77d56b2 &
redshift -l 21.028382:105.853734 &
# autossh -M 10900 -fN -o "PubkeyAuthentication=yes" -o "StrictHostKeyChecking=false" -o "PasswordAuthentication=no" -o "ServerAliveInterval 60" -o "ServerAliveCountMax 3" -R iodize13.com:10022:localhost:22 ionize13@iodize13.com &
# echo "$HOME/note.md" > /tmp/proj-note &
# ssh -N -L 5432:localhost:5432 -L 8333:localhost:8333 -L 19092:localhost:19092 -L 4317:localhost:4317 -L 6379:localhost:6379 -L 6380:localhost:6380 qualiva-dev &
xinput set-prop "PixArt Dell MS116 USB Optical Mouse" "libinput High Resolution Wheel Scroll Enabled" 0
setsid compton --blur-background --blur-strength 3 --no-fading-openclose --no-fading-destroyed-argb &
newlook &
dwmblocks &
easyeffects-autostart &
# setsid /usr/lib/zed/zed-editor &
# heidisql &
waterfox &
# discord &
# $TERMINAL -e tmux new-session -A -s main iamb &
nheko &
exec startdwm
