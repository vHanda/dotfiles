alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'

# Color
alias grep='grep --color=auto'
alias ll='ls -lh'

# Convenient shortcuts
alias g='grep -i'
alias a='ag -i'


alias cls='printf "\033c"'
alias cat='bat --paging never --style=plain --wrap never'

function mk
    mkdir -p "$1" && cd "$1"
end

function rp
    set FROM $1
    set TO $2
    echo "Replacing $1 for $2"
    find . -type f -not -path './node_modules/*' -not -path '*/\.*' -exec sed -i -e s/$FROM/$TO/g {} \;
end


function yt
    youtube-dl "$1" -f 'bestvideo[ext!=webm][width<=2560]+bestaudio[ext!=webm]/best[ext!=webm]' --merge-output-format mp4
end

export EDITOR='vim'
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Auto call 'ls' after cd
# function chpwd() {
#     emulate -L zsh
#     ls --color=auto
# }

fish_add_path -p /usr/local/opt/coreutils/libexec/gnubin

alias cz=chezmoi