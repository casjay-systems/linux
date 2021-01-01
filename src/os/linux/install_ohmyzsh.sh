#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" &&
  . "../utils.sh"

srcdir="$(cd .. && pwd)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

setup_zsh() {
  if [ -f "$srcdir/config/zsh/install.sh" ]; then
    execute "$srcdir/config/zsh/install.sh" "Installing zsh: $srcdir/config/zsh/install.sh"
  elif [ -d "$srcdir/config/zsh" ]; then
    rm -Rf ~/.zshrc
    execute \
      "ln -sf $srcdir/config/zsh/zshrc ~/.zshrc" \
      "$srcdir/config/zsh/zshrc → ~/.zshrc"
  else
    exit
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

setup_omyzsh() {
  if [ -d "$HOME/.local/share/zsh/oh-my-zsh/.git" ]; then
    execute \
      "cd $HOME/.local/share/zsh/oh-my-zsh && git pull -q" \
      "Updating oh-my-zsh"

  else
    execute \
      "rm -Rf $HOME/.local/share/zsh/oh-my-zsh && \
      git clone -q https://github.com/robbyrussell/oh-my-zsh.git $HOME/.local/share/zsh/oh-my-zsh" \
      "https://github.com/robbyrussell/oh-my-zsh.git → $HOME/.local/share/zsh/oh-my-zsh"
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

setup_zsh9k() {
  if [ -d "$HOME/.local/share/zsh/oh-my-zsh/custom/themes/powerlevel9k/.git" ]; then
    execute \
      "cd $HOME/.local/share/zsh/oh-my-zsh/custom/themes/powerlevel9k && \
      git pull -q" \
      "Updating powerlevel9k "
  else
    execute \
      "rm -Rf $HOME/.local/share/zsh/oh-my-zsh/custom/themes/powerlevel9k && \
      git clone -q https://github.com/bhilburn/powerlevel9k.git $HOME/.local/share/zsh/oh-my-zsh/custom/themes/powerlevel9k" \
      "https://github.com/bhilburn/powerlevel9k.git → $HOME/.local/share/zsh/oh-my-zsh/custom/themes/powerlevel9k"
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

setup_zsh10k() {
  if [ -d "$HOME/.local/share/zsh/oh-my-zsh/custom/themes/powerlevel10k/.git" ]; then
    execute \
      "cd $HOME/.local/share/zsh/oh-my-zsh/custom/themes/powerlevel10k && \
      git pull -q" \
      "Updating powerlevel10k"
  else
    execute \
      "rm -Rf $HOME/.local/share/zsh/oh-my-zsh/custom/themes/powerlevel10k && \
      git clone -q https://github.com/romkatv/powerlevel10k.git $HOME/.local/share/zsh/oh-my-zsh/custom/themes/powerlevel10k" \
      "https://github.com/romkatv/powerlevel10k.git → $HOME/.local/share/zsh/oh-my-zsh/custom/themes/powerlevel10k"
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

  setup_zsh
  setup_omyzsh
  setup_zsh9k
  setup_zsh10k

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main
