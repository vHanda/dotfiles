for DOTFILE in `find ~/.dotfiles -maxdepth 1 -name '*.source' -type f`
do
  source "$DOTFILE"
done

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
