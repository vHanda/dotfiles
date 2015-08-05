# History
HISTFILE=~/.zsh/history
HISTSIZE=50000
SAVEHIST=100000

setopt inc_append_history # Shared History
# What does this do?
setopt notify

# Emacs mode
bindkey -e

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit
autoload -Uz promptinit
promptinit

setopt correct
export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r?$reset_color (Yes, No, Abort, Edit) "
#zmodload -a compinit
#zmodload -a promptinit

zmodload -a autocomplete
zmodload -a complist

autoload -U colors && colors

# End of lines added by compinstall

setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE

# Colored prompt
autoload -U promptinit
promptinit

# Auto start the x server
#if [[ -z $DISPLAY && $(tty) = /dev/tty1 ]]; then
#  exec startx
#fi

# Better History
#
#bindkey "^[[A" history-search-backward
#bindkey "^[[B" history-search-forward

#bindkey "^[[A" history-incremental-pattern-search-backward
#bindkey "^[[B" history-incremental-pattern-search-forward

# Custom Prompt
PROMPT='%m:%F{green}%~ $ %f%>:%{\e[0m% $}'
#RPROMPT="[%{$fg[yellow]%}%?%{$reset_color%}]"

# For KDE environment change
function cd() {
  # Use this for zsh (otherwise just "cd" doesn't work) :
  builtin cd $*
  _f=`findup .setup`
  if test -n "$_f" -a "$_lastf" != "$_f"; then
    echo "Loading KDE Developer Environment - $_f"
    _lastf="$_f"
    source $_f/my_setup
    source $_f/kde_setup
  fi
}

# Custom Aliases
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'

# Color
alias diff='colordiff'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias more='less'
alias ls='ls --color=auto'
alias ll='ls -lh'

# Convenient shortcuts
alias v='vim'
alias k='kwrite &> /dev/null'
alias g='grep -i'
alias a='ack -ir'

alias h='head'
alias t='tail'

# Git aliases
alias gs='git status'
alias gsf='git status --uno'
alias gd='git diff'
alias gdc='git diff --cached'
alias gl='git log'
alias ga='git add'
alias gb='git branch'
alias gbc='git branch -a --contains'
alias gap='git add -p'
alias gc='git commit -v'
alias gca='git commit --amend -v'
alias gsh='git show'
alias gss='git stash save'

alias c='xclip -selection clipboard'
alias kd='kdevelop'

function pb {
    URL=`pastebinit $@`
    echo $URL | c
    echo $URL
}

# Find alias
function f() {
    find -iname "*$@*"
    return $?
}

# Colored autocompletion for files
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors 'reply=( "=(#b)(*$VAR)(?)*=00=$color[green]=$color[bg-green]" )'
zstyle ':completion:*:*:*:*:hosts' list-colors '=*=30;41'
zstyle ':completion:*:*:*:*:users' list-colors '=*=$color[green]=$color[red]'

# For AUR
export EDITOR='vim'

# Ssh-agent
# This results in multiple copies of gpg and ssh-agent running
# eval $(ssh-agent)
# ssh-add ~/.ssh/id_rsa
# eval $(gpg-agent --daemon)

eval $(keychain --noask --eval --agents ssh -Q --quiet ~/.ssh/id_rsa)


# Zsh completion cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# tab completion for PID :D
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# Ignore case for 'ls' and stuff
setopt no_case_glob

# Ctrl-Left/Right
bindkey ';5D' emacs-backward-word
bindkey ';5C' emacs-forward-word

# vim style movement
#bindkey '^[j' up-line-or-search
bindkey '^[j' history-beginning-search-backward
#bindkey '^[k' down-line-or-search
bindkey '^[k' history-beginning-search-forward
bindkey '^[h' backward-char
bindkey '^[l' forward-char

# An improved backward search
bindkey "\C-r" history-incremental-pattern-search-backward

# Chromium + Tor
alias chromium-tor='chromium --proxy-server="socks://localhost:9050"'

# 256 color terminal
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
        export TERM='xterm-256color'
else
        export TERM='xterm-color'
fi

alias ws='watch -n 0.5 sensors'

# Auto call 'ls' after cd
function chpwd() {
    emulate -L zsh
    ls
}

# Annoying gdb copyright message
alias gdb='gdb -q'

# Ruby
export PATH=~/.gem/ruby/2.1.0/bin:$PATH

# Choose Qt version 5
QT_SELECT=5

# What is this bd thing?
alias bd=". bd -s"

# Rebuild PATH cache
zstyle ":completion:*:commands" rehash 1

# direnv
eval "$(direnv hook zsh)"

# Focus Writer
function journal() {
    touch ~/Documents/notes/`date +%Y-%m-%d`.txt
    focuswriter ~/Documents/notes/`date +%Y-%m-%d`.txt
}
