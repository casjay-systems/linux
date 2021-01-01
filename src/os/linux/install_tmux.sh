#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" &&
  . "../utils.sh"

srcdir="$(cd .. && pwd)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

setup_tmux() {
  if [ -f "$srcdir/config/tmux/install.sh" ]; then
    execute "$srcdir/config/tmux/install.sh" "Installing tmux: $srcdir/config/tmux/install.sh"

  elif [ -d "$srcdir/config/tmux" ]; then
    if [ -L ~/.tmux ]; then unlink ~/.tmux 2>/dev/null; fi
    if [ -d ~/.tmux ]; then rm -Rf -f ~/.tmux 2>/dev/null; fi

    execute \
      "ln -sf ~/.local/dotfiles/src/config/tmux ~/.tmux" \
      "$srcdir/config/tmux → ~/.tmux"

    execute \
      "ln -sf $srcdir/config/tmux/tmux.conf ~/.tmux.conf" \
      "$srcdir/config/tmux/tmux.conf → ~/.tmux.conf"
  else
    exit
  fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

setup_tmuxplugins() {
  if [ -d "$HOME/.local/share/tmux/tpm/tpm" ]; then
    execute \
      "git -C $HOME/.local/share/tmux/tpm/tpm pull -q" \
      "Updating tmux plugin manager"

    execute \
      "bash $HOME/.local/share/tmux/tpm/scripts/install_plugins.sh 2> /dev/null" \
      "Updating tmux plugins"
  else
    execute \
      "rm -Rf $HOME/.local/share/tmux/tpm && \
      git clone -q https://github.com/tmux-plugins/tpm $HOME/.local/share/tmux/tpm" \
      "https://github.com/tmux-plugins/tpm → $HOME/.local/share/tmux/tpm"

    execute \
      "bash -c $HOME/.local/share/tmux/tpm/scripts/install_plugins.sh" \
      "Installing tmux plugins → $HOME/.local/share/tmux/tpm"
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

  setup_tmux
  setup_tmuxplugins

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main
