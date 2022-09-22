
sudo mkdir /etc/kmonad
sudo ln -s ~/.dotfiles/kmonad/config.kbd /etc/kmonad/config.kbd
sudo systemctl enable --now kmonad
