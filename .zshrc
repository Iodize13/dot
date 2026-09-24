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
alias v=nvim

alias c='g++ -Wall -Wconversion -Wshadow -Wfatal-errors -g \
-std=c++17 -fsanitize=undefined,address -Wl,-z,stack-size=10000000 -I$HOME/github.com/Iodize13/competitive-programming/.template'
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

# Run a command with a memory cap (default 2G) and CPU timeout (default 10s)
# so a buggy competitive-programming solution (infinite loop / unbounded
# allocation) can't swap the whole laptop to death. Usage: run ./a.out < in
# Uses a cgroup (systemd-run --scope) rather than `ulimit -v`, since ulimit -v
# caps virtual address space and breaks ASan (which reserves huge shadow
# memory ranges of virtual space that are never actually resident).
# MemorySwapMax=0 forces a real OOM-kill on hitting the cap instead of
# swapping to stay under it (swapping just reintroduces the slowdown).
run() {
    local mem=${RUN_MEM:-2G}
    local secs=${RUN_TIMEOUT:-10}
    local unit="cprun-$$-$RANDOM"
    timeout "$secs" systemd-run --user --scope -q --unit="$unit" \
        -p MemoryMax="$mem" -p MemorySwapMax=0 -- "$@"
    local rc=$?
    if [[ $rc -eq 124 ]]; then
        echo "[run] killed: exceeded ${secs}s timeout (RUN_TIMEOUT) -- program did not finish" >&2
    elif [[ $rc -eq 137 ]]; then
        local tries=0 oomed=""
        while [[ $tries -lt 10 ]]; do
            journalctl --user -u "${unit}.scope" --no-pager 2>/dev/null | grep -q oom-kill && { oomed=1; break; }
            sleep 0.1
            (( tries++ ))
        done
        if [[ -n $oomed ]]; then
            echo "[run] killed: exceeded ${mem} memory limit (RUN_MEM) -- program did not finish" >&2
        else
            echo "[run] killed by SIGKILL (not from timeout; memory-limit cause unconfirmed)" >&2
        fi
    fi
    return $rc
}

# export GOPATH="$XDG_DATA_HOME/go"

# /mnt/sdb is a failing drive (ext4 forced it emergency_ro after unrecoverable
# read errors). GOMODCACHE defaulted to $HOME/go/pkg/mod -> /mnt/sdb/go/pkg/mod,
# which made every `go build` crawl. GOENV also landed there because
# XDG_CONFIG_HOME is $HOME, so `go env -w` could not write. Pin both to sda5.
export GOENV="$HOME/.config/go/env"
export GOPATH="$HOME/.cache-local/go"          # was $HOME/go -> /mnt/sdb
export GOMODCACHE="$GOPATH/pkg/mod"            # also fixes $GOPATH/pkg/sumdb writes
export PATH="$PATH:$HOME/.config/emacs/bin/"
export PATH="$HOME/.bun/bin:$PATH"
export PATH="$HOME/.cache-local/go/bin:$HOME/go/bin:$PATH"
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

# Route GTK file dialogs through xdg-desktop-portal (yazi file picker)
export GTK_USE_PORTAL=1
export GDK_DEBUG=portals  # GTK4 equivalent
export QT_QPA_PLATFORMTHEME=xdgdesktopportal  # Qt6 -> portal file dialogs

# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit && compinit -C
# <<< grok installer <<<
