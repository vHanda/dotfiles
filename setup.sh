#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# vim
ln -s ${BASEDIR}/vimrc ~/.vimrc
# ln -s ${BASEDIR}/vim/ ~/.vim

# zsh
mkdir ~/.zsh
ln -s ${BASEDIR}/zshrc ~/.zshrc

ln -s ${BASEDIR}/gitconfig ~/.gitconfig
