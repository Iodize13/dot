HISTFILE=~/.histfile
HISTSIZE=10000000
SAVEHIST=10000000
autoload -Uz compinit
compinit
setopt autocd extendedglob
unsetopt beep
bindkey -e

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
  print "$branch"
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
    GREEN=$'\033[38;2;80;250;123m'
    MAGENTA=$'\033[38;2;255;121;198m'
    RESET=$'\033[0m'
    precmd() { print -rP "%m ${GREEN}%~ ${MAGENTA}$(git_branch)${RESET}" }
    PS1="$(exitstatus) "
    
else
    PS1='%n@%m:%~\$ '
fi
unset color_prompt force_color_prompt


alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../../'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

alias ls="ls -a1 --color=auto"
alias l="ls"
alias grep='grep --color=auto'
alias cl=clear
alias cp="cp -vi"
alias mv="mv -vi"
alias sy="sudo systemctl"
alias vim=nvim

alias c='g++ -Wall -Wconversion -Wshadow -Wfatal-errors -g \
-std=c++20 -fsanitize=undefined,address -Wl,-z,stack-size=10000000 -I$HOME/github.com/competitive-programming/.template'
alias cc='g++ -Wall \
    -Wconversion \
    -Wfatal-errors \
    -Wshadow \
    -g \
    -std=c++20 \
    -DLOCAL \
    -fsanitize=undefined,address \
	-Wl,-z,stack-size=10000000'
alias gocp="cd $HOME/github.com/competitive-programming/CF"
alias swapx="mv -v $HOME/.xinitrc $HOME/.temp.xinitrc && mv -v $HOME/.other.xinitrc $HOME/.xinitrc && mv -v $HOME/.temp.xinitrc $HOME/.other.xinitrc"

cd() {
    # Call the actual builtin 'cd' with arguments, return if it fails
    builtin cd "$@" || return $?
    proj_root=$(git rev-parse --show-toplevel 2>/dev/null) || proj_root="$HOME"
    echo "${proj_root}/note.md" > /tmp/proj-note
}

f() {
    project="$HOME/github.com"

    cd "$project/$(ls  "$project" | fzf)"
}

mkcd() {
    mkdir -p "$1" && cd "$1"
}

# export GOPATH="$XDG_DATA_HOME/go"
export PATH="$PATH:$HOME/.config/emacs/bin/"
export PATH="$HOME/.bun/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.local/share/gem/ruby/3.4.0/bin"
export PATH="$PATH:$HOME/.local/bin"
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock

command -v fnm &> /dev/null && eval "$(fnm env --use-on-cd --version-file-strategy recursive --shell zsh)"
command -v toilet &> /dev/null && toilet -f Cybermedium --rainbow "It's just
earthly things."
command -v fzf &> /dev/null && source <(fzf --zsh)
command -v direnv &> /dev/null && eval "$(direnv hook zsh)"
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
