HISTFILE=~/.histfile
HISTSIZE=2000
SAVEHIST=2000
autoload -Uz compinit
compinit
setopt autocd extendedglob
unsetopt beep
bindkey -e

export TERMINAL=wezterm
export SYSTEMD_EDITOR=nvim
export EDITOR=nvim

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
    RESET="$(tput sgr0)"
    precmd() { print -rP "%m ${GREEN}%~${RESET}" }
    PS1="$(exitstatus) > "
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

f() {
    project="$HOME/github.com"

    if [[ -z "$1" ]]; then
        cd "$project/$(ls  "$project" | fzf)"
    elif [[ "$1" == "qw" ]]; then
        cd "$project/qualiva-space-web"
    elif [[ "$1" == "qc" ]]; then
        cd "$project/qualiva-space-core-service"
    fi
}

mkcd() {
    mkdir -p "$1" && cd "$1"
}

export PATH="$PATH:$HOME/.config/emacs/bin/"
export PATH="$HOME/.cache/.bun/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.local/share/gem/ruby/3.4.0/bin"
export PATH="$PATH:/home/ionize13/.local/bin"

command -v fnm &> /dev/null && eval "$(fnm env --use-on-cd --shell zsh)"
command -v toilet &> /dev/null && toilet -f Cybermedium --rainbow "It's just
earthly things."
command -v fzf &> /dev/null && source <(fzf --zsh)
# command -v direnv &> /dev/null && eval "$(direnv hook bash)"
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
