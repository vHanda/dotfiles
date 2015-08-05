for DOTFILE in `find ~/.dotfiles -maxdepth 1 -name '.*' -type f`
do
  source "$DOTFILE"
done
