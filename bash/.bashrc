# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# src: https://github.com/rwxrob/dot.git
_source_if() { [[ -r "$1" ]] && source "$1"; }

export GITUSER="Iodize13"
export GHREPOS="$HOME/github.com/$GITUSER"
export SCRIPTS="$HOME/.local/bin"
export HISTSIZE=2000
export HISTFILESIZE=2000
export UV_TOOL_BIN_DIR="$HOME/.local/bin"
export DVTM_PAGER="less -i -R"
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
# for dwm
# export _JAVA_AWT_WM_NONREPARENTING=1

append_prompt_command() {
    local cmd="$1"
    if [[ -n ${PROMPT_COMMAND:-} ]]; then
        PROMPT_COMMAND+=";${cmd}"
    else
        PROMPT_COMMAND="${cmd}"
    fi
}

append_prompt_command 'history -a'
append_prompt_command 'history -n'

pathappend() {
	declare arg
	for arg in "$@"; do
		test -d "$arg" || continue
		PATH=${PATH//":$arg:"/:}
		PATH=${PATH/#"$arg:"/}
		PATH=${PATH/%":$arg"/}
		export PATH="${PATH:+"$PATH:"}$arg"
	done
} && export -f pathappend

pathprepend() {
	for arg in "$@"; do
		test -d "$arg" || continue
		PATH=${PATH//:"$arg:"/:}
		PATH=${PATH/#"$arg:"/}
		PATH=${PATH/%":$arg"/}
		export PATH="$arg${PATH:+":${PATH}"}"
	done
} && export -f pathprepend

pathprepend \
    "$HOME/.local/bin" \
    "$HOME/go/bin" \
    "$HOME/.cargo/bin" \
    "$HOME/.bun/bin" \
    /usr/local/go/bin \
    /usr/local/opt/openjdk/bin \
    /usr/local/bin

pathappend \
    /usr/local/bin \
    /usr/local/sbin \
    /usr/local/games \
    /usr/games \
    /usr/sbin \
    /usr/bin \
    /sbin \
    /bin

export CDPATH=".:$GHREPOS:$HOME"

shopt -s autocd
shopt -s extglob cdspell
# unsetopt beep

[ -f "$HOME/profile" ] && source "$HOME/profile"

exitstatus()
{
    if [[ $? == 0 ]]; then
        echo ':)'
    else
        echo 'D:'
    fi
}

git_branch() {
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null) \
    || branch=$(git rev-parse --short HEAD 2>/dev/null) \
    || return
  echo "$branch"
}

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    GREEN="$(tput setaf 2)"
    MAGENTA="$(tput setaf 5)"
    RESET="$(tput sgr0)"
    PS1="\h ${GREEN}\w ${MAGENTA}\$(git_branch)${RESET}\n$(exitstatus) "

else
    PS1='\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
	dvtm*|xterm*|rxvt*)
		if [[ "$INSIDE_EMACS" != 'vterm' ]]; then
			append_prompt_command 'printf "\033]0;%s\007" "${PWD/$HOME/~}"'
		fi
		;;
	*)
		;;
esac

if [[ "$INSIDE_EMACS" = 'vterm' ]] \
    && [[ -n ${EMACS_VTERM_PATH} ]] \
    && [[ -f ${EMACS_VTERM_PATH}/etc/emacs-vterm-bash.sh ]]; then
	source ${EMACS_VTERM_PATH}/etc/emacs-vterm-bash.sh
fi

find_file() {
    vterm_cmd find-file "$(realpath "${@:-.}")"
}

# [[ $TERM != "screen" ]] && exec abduco -A my-session dvtm-status
# -- CP
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../../'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
# alias l=sl
# alias l='\ls -1a --color=auto'
alias ls="ls -a1 --color=auto"
alias l="ls"
alias grep='grep --color=auto'
alias t="task"
alias ta="task add"
alias sy="sudo systemctl"
alias vim=nvim
alias cp="cp -vi"
alias mv="mv -vi"
alias swapx="mv -v $HOME/.xinitrc $HOME/.temp.xinitrc && mv -v $HOME/.other.xinitrc $HOME/.xinitrc && mv -v $HOME/.temp.xinitrc $HOME/.other.xinitrc"
alias cl=clear
alias zed=zeditor
alias c='g++ -Wall -Wconversion -Wshadow -Wfatal-errors -g \
-std=c++13 -fsanitize=undefined,address -Wl,-z,stack-size=10000000 -I$HOME/github.com/Iodize13/competitive-programming/.template'
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
alias dvtm="abduco -A my-session dvtm-status"

cd() {
    # Call the actual builtin 'cd' with arguments, return if it fails
    builtin cd "$@" || return $?
    proj_root=$(git rev-parse --show-toplevel 2>/dev/null) || proj_root="$HOME"
    echo "${proj_root}/note.md" > /tmp/proj-note
}

mkcd() {
    mkdir -p "$1" && cd "$1"
}

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

# alias sudo=doas
# complete -cf doas
# Change this to default cp? yes
CP() {
    mkdir -p $(dirname "$2") && cp "$1" "$2"
}
# source https://www.baeldung.com/linux/create-destination-directory
# same with mkdir -p

# VIM() {
#     filename="${1##*/}"
#     extension="${filename##*.}"
#     if [ $extension = "cpp" ]; then
#         \vim $1
#     else
#         nvim $1
#     fi
# }

set-editor() {
	export EDITOR="$1"
	export VISUAL="$1"
	export GH_EDITOR="$1"
	export GIT_EDITOR="$1"
	export SYSTEMD_EDITOR="$1"
}
_have "vim" && set-editor vim
_have "nvim" && set-editor nvim

_source_if "$SCRIPTS/completion-cache"

cache_completion gh       "gh completion -s bash"
cache_completion glow     "glow completion bash"
cache_completion pandoc   "pandoc --bash-completion"
cache_completion kubectl  "kubectl completion bash"
cache_completion cnpg     "kubectl cnpg completion bash"
cache_completion helm     "helm completion bash"
cache_completion openspec "openspec completion generate bash"

_source_if "$HOME/.bash_work"

GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx

command -v fnm &> /dev/null && eval "$(fnm env --use-on-cd --shell bash)"
[[ "$INSIDE_EMACS" != *vterm* ]] && command -v toilet &> /dev/null && toilet -f Cybermedium --rainbow "It's just
earthly things."
command -v fzf &> /dev/null && eval "$(fzf --bash)"
bind -r '\C-t'
command -v direnv &> /dev/null && eval "$(direnv hook bash)"
[ -f /usr/share/git/completion/git-completion.bash ] && source /usr/share/git/completion/git-completion.bash
[ -f /opt/Xilinx/14.7/ISE_DS/settings64.sh ] && source /opt/Xilinx/14.7/ISE_DS/settings64.sh &> /dev/null
[ -f /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion
source "$HOME/.cargo/env"

# CP log: cp-log <minutes_today>
cp-log() { echo '{"date":"'"$(date -I)"'","cp_minutes":'"${1:?usage: cp-log <minutes>}"'}' >> ~/cp-log.jsonl; }

# CP time tracking: cp-start / cp-end
cp-start() { date +%s > /tmp/cp-start-"$USER"; echo "CP started at $(date +%H:%M)"; }
cp-end() {
  local start end mins
  start=$(cat /tmp/cp-start-"$USER" 2>/dev/null)
  if [[ -z "$start" ]]; then echo "No cp-start found"; return 1; fi
  end=$(date +%s)
  mins=$(( (end - start) / 60 ))
  echo '{"date":"'"$(date -I)"'","cp_minutes":'"$mins"'}' >> ~/cp-log.jsonl
  rm -f /tmp/cp-start-"$USER"
  echo "Logged ${mins} min CP. Total today: $(grep "\"$(date -I)\"" ~/cp-log.jsonl | grep -oP '"cp_minutes":\K\d+' | paste -sd+ | bc) min"
}

# Zellij: show running command as tab title, dir name otherwise
if [[ -n $ZELLIJ ]]; then
    _zellij_dir() { local d=$PWD; [[ $d == $HOME ]] && d="~" || d=${d##*/}; echo "$d"; }
    _zellij_tab() { command nohup zellij action rename-tab "$1" >/dev/null 2>&1; }
    # After each command → dir name
    PROMPT_COMMAND='_zellij_tab "$(_zellij_dir)"'
    # During command → the command itself
    trap '_zellij_tab "$BASH_COMMAND"' DEBUG
fi

# Qualiva worktree helpers (agentic multi-repo pattern)
source /home/ionize13/github.com/qualiva/worktree.sh

# >>> oh-my-opencode-slim background subagents >>>
export OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS=true
# <<< oh-my-opencode-slim background subagents <<<
