#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" &&
  . "../utils.sh"

srcdir="$(cd .. && pwd)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

setup_fish() {
  unlink "$HOME/.config/fish" 2>/dev/null || rm -Rf $HOME/.config/fish 2>/dev/null
  if [ -f "$srcdir/config/fish/install.sh" ]; then
    execute "$srcdir/config/fish/install.sh" "Installing fish"
  elif [ -d "$srcdir/config/fish" ]; then
    execute \
      "ln -sf $srcdir/config/fish ~/.config/" \
      "$srcdir/config/fish → ~/.config/fish"
  else
    exit
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

setup_ohmyfish() {
  if [ -d "$HOME/.local/share/fish/oh-my-fish/.git" ]; then
    execute \
      "git -C $HOME/.local/share/fish/oh-my-fish pull -q >/dev/null 2>&1" \
      "Updating oh-my-fish"
  else
    execute \
      "curl -LSsq https://get.oh-my.fish -o $HOME/.config/fish/omf-install \
      fish $HOME/.config/fish/omf-install --path=-$HOME/.local/share/fish/oh-my-fish --config=~/.config/fish/omf --noninteractive --yes" \
      "Installing oh-my-fish"
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

setup_fishplugins() {
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
