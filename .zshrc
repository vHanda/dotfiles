for DOTFILE in `find ~/.dotfiles -maxdepth 1 -type f`
do
  source "$DOTFILE"
done
