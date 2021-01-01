#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" &&
  . "../utils.sh"

srcdir="$(cd .. && pwd)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_vim() {
  if [ -f "$srcdir/config/vim/install.sh" ]; then
    execute "$srcdir/config/vim/install.sh" "Installing vim: $srcdir/config/vim/install.sh"
  elif [ -d "$srcdir/config/vim" ]; then
    rm -Rf ~/.vimrc
    if [ -L ~/.vim ]; then unlink ~/.vim 2>/dev/null; fi
    if [ -d ~/.vim ]; then rm -Rf -f ~/.vim 2>/dev/null; fi
    execute \
      "ln -sf ~/.config/vim ~/.vim" \
      "~/.config/vim/  → ~/.vim"
    execute \
      "ln -sf $srcdir/config/vim/vimrc ~/.vimrc" \
      "$srcdir/config/vim/vimrc  → ~/.vimrc"
  else
    exit
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_vimplugins() {
  if [ -d "$HOME/.local/share/vim/Vundle.vim/.git" ]; then
    execute \
      "git -C $HOME/.local/share/vim/Vundle.vim pull -q && \
      vim +PluginInstall +qall < /dev/null > /dev/null 2>&1" \
      "Updating Vundle and Plugins"
  else
    execute \
      "rm -Rf $HOME/.local/share/vim/Vundle.vim && \
      git clone -q https://github.com/VundleVim/Vundle.vim.git $HOME/.local/share/vim/Vundle.vim && \
      vim +PluginInstall +qall < /dev/null > /dev/null 2>&1" \
      "vim +PluginInstall +qall → $HOME/.local/share/vim/"
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

  install_vim
  install_vimplugins

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main
