#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return




export TERMINAL=wezterm

# src: https://github.com/dylanaraps/clutter-home
export XDG_CONFIG_HOME=~
export XDG_DATA_HOME=~

exitstatus()
{
    if [[ $? == 0 ]]; then
        echo ':)'
    else
        echo 'D:'
    fi
}

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    GREEN="\[$(tput setaf 2)\]"
    RESET="\[$(tput sgr0)\]"
    PS1="\h ${GREEN}\w${RESET}\n$(exitstatus) > "
else
    PS1='\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt


# [[ $TERM != "screen" ]] && exec abduco -A my-session dvtm-status
# alias l=sl
# alias l='\ls -1a --color=auto'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias t="task"
alias ta="task add"
alias figma="figma-linux"

export PATH="$PATH:$HOME/.config/emacs/bin/"
export PATH="$HOME/.cache/.bun/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.local/share/gem/ruby/3.4.0/bin"

command -v fnm && eval "$(fnm env --use-on-cd --shell bash)"
command -v toilet && toilet -f Cybermedium --rainbow "It's just
earthly things."

shopt -s extglob cdspell

# Automatically added by the Guix install script.
if [ -n "$GUIX_ENVIRONMENT" ]; then
    if [[ $PS1 =~ (.*)"\\$" ]]; then
        PS1="${BASH_REMATCH[1]} [env]\\\$ "
    fi
fi

# set -o noclobber
# set -o vi

urlencode () {
	declare str="$*"
	declare encoded=""
	declare i c x
	for ((i=0; i<${#str}; i++)); do
		c=${str:$i:1}
		case "$c" in
			[-_.a-zA-Z0-9] ) x="$c" ;;
			* ) printf -v x '%%%02x' "'$c" ;;
		esac
		encoded+="$x"
	done
	echo "$encoded"
}

duck () {
	declare url=$(urlencode "$*")
	w3m -4 "https://duckduckgo.com/lite?q=$url"
}
alias "?"=duck

google () {
	declare url=$(urlencode "$*")
	w3m -4 "https://google.com/search?q=$url"
}
alias "??"=google
alias c='g++ -Wall -Wconversion -Wshadow -Wfatal-errors -g \
-std=c++20 -fsanitize=undefined,address -Wl,-z,stack-size=10000000 -I$HOME/github.com/competitive-programming/.template'

alias ccc='g++ -Wall \
    -Wconversion \
    -Wfatal-errors \
    -Wshadow \
    -g \
    -std=c++20 \
    -DLOCAL \
    -fsanitize=undefined,address \
	-Wl,-z,stack-size=10000000'
# 53686912'
# does the stack size actually correct?

# Created by `pipx` on 2024-11-18 07:21:38
export PATH="$PATH:/home/ionize13/.local/bin"

# pnpm
export PNPM_HOME="/home/ionize13/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
#
alias facebook=brave
export PATH="$PATH:/home/ionize13/.guix-profile/bin"
# export EMACSLOADPATH="/home/ionize13/.guix-profile/share/emacs/site-lisp"
export INFOPATH="/home/ionize13/.guix-profile/share/info"
# set -o vi
export PATH="$HOME/.local/pipx/venvs/meson/bin:$PATH"
# export EMACSLOADPATH=/usr/share/emacs/site-lisp
export SYSTEMD_EDITOR=nvim
export EDITOR=nvim
alias dvtm="abduco -A my-session dvtm-status"
alias cl=clear
alias bk="brillo -q -A 5"
alias bj="brillo -q -U 5"
alias pk="pactl set-sink-volume @DEFAULT_SINK@ +2%"
alias pj="pactl set-sink-volume @DEFAULT_SINK@ -2%"

export PROMPT_COMMAND="history -a; history -n"

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	dvtm*|xterm*|rxvt*)
		PROMPT_COMMAND='echo -ne "\033]0;${PWD/$HOME/~}\007"'
		;;
	*)
		;;
esac

# TERMINAL=kitty
alias gocp="cd $HOME/github.com/competitive-programming/CF"
# eval "$(fzf --bash)"
# alias nu="nmcli radio wifi off"
# alias nd="nmcli radio wifi off"
alias nf="nmcli radio wifi off"
alias cp="cp -vi"
alias mv="mv -vi"
alias swapx="mv -v $HOME/.xinitrc $HOME/.temp.xinitrc && mv -v $HOME/.other.xinitrc $HOME/.xinitrc && mv -v $HOME/.temp.xinitrc $HOME/.other.xinitrc"

export DVTM_PAGER="less -i -R"
# alias sudo=doas
# complete -cf doas
# Change this to default cp? yes
CP() {
    mkdir -p $(dirname "$2") && cp "$1" "$2"
}
# source https://www.baeldung.com/linux/create-destination-directory
# same with mkdir -p
#
# VIM() {
#     filename="${1##*/}"
#     extension="${filename##*.}"
#     if [ $extension = "cpp" ]; then
#         \vim $1
#     else
#         nvim $1
#     fi
# }

alias vim=nvim

# git() {
#     if [[ $@ == "add ." ]]; then
#         ./release-script remote
#         command git add .
#         ./release-script local
#     else
#         command git "$@"
#     fi
# }

export HISTSIZE=2000
export HISTFILESIZE=2000
mkcd='function _mkcd(){ mkdir -p "$1" && cd "$1"; }; _mkcd'

GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx


# -- CP
shopt -s autocd
# -- navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../../'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias l="ls -a1"
