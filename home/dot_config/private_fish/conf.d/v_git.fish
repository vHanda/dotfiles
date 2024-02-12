
# Git aliases
alias gs='git status'
alias gd='git diff'
alias gdc='git diff --cached'
alias gl='git log --graph'
alias ga='git add'
alias gb='git branch'
alias gbc='git branch -a --contains'
alias gap='git add -p'
alias gc='git commit -v'
alias gca='git commit --amend -v'

function gp
    git push origin $(git branch --show-current)
end

function gpf
    git push origin $(git branch --show-current) --force-with-lease
end
