#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" &&
  . "../utils.sh"

srcdir="$(cd .. && pwd)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

setup_fish() {
  if [ -f "$HOME/.config/fish/install.sh" ]; then
    execute "$HOME/.config/fish/install.sh" "Installing fish"
  else
    if [ -d -$HOME/.local/share/fish/oh-my-fish/.git ]; then
      echo ""
      execute \
        "unlink ~/.config/fish && \
          rm -Rf ~/.config/fish && \
          ln -sf $srcdir/fish ~/.config/fish" \
        "$srcdir/fish → ~/.config/fish"
    else
      echo ""
      execute \
        "unlink ~/.config/fish && \
          rm -Rf ~/.config/fish && \
          ln -sf $srcdir/fish ~/.config/" \
        "$srcdir/fish → ~/.config/fish"
    fi
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

setup_ohmyfish() {

  if [ -d -$HOME/.local/share/fish/oh-my-fish/.git ]; then
    echo ""
    execute \
      "cd -$HOME/.local/share/fish/oh-my-fish && git pull -q >/dev/null 2>&1" \
      "Updating oh-my-fish"
  else
    echo ""
    execute \
      "fish $HOME/.config/fish/omf-install --path=-$HOME/.local/share/fish/oh-my-fish --config=~/.config/fish/omf --noninteractive --yes" \
      "Installing oh-my-fish"
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

setup_fishplugins() {
  echo ""
  execute \
    "fish $HOME/.config/fish/plugins.fish 2>/dev/null" \
    "Installing fish plugins"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

  setup_fish

  setup_ohmyfish

  setup_fishplugins

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main
