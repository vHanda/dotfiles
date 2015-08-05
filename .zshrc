for DOTFILE in `find ~/.dotfiles -maxdepth 1 -type f`
do
  ZSHRC=~/.dotfiles/.zshrc
  if [[ "$DOTFILE" != "$ZSHRC" ]]; then
      source "$DOTFILE"
  fi
done
