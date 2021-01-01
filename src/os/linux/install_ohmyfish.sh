#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" &&
  . "../utils.sh"

srcdir="$(cd .. && pwd)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

setup_fish() {
  unlink "$HOME/.config/fish" 2>/dev/null || rm -Rf $HOME/.config/fish 2>/dev/null
  if [ -f "$srcdir/config/fish/install.sh" ]; then
    execute "bash -c $srcdir/config/fish/install.sh" "Installing fish: $srcdir/config/fish/install.sh"
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
  fi

  if [ ! -d "$srcdir/config/fish/omf" ]; then
    execute \
      "curl -LSsq https://get.oh-my.fish -o $srcdir/config/fish/omf-install" \
      "Grabbing the oh-my-fish install script"
    execute \
      "fish $srcdir/config/fish/omf-install --path=-$HOME/.local/share/fish/oh-my-fish --config=$srcdir/config/fish/omf --noninteractive --yes" \
      "Installing oh-my-fish"
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

setup_fishplugins() {
  if [ -f "$srcdir/config/fish/plugins.fish" ]; then
    execute \
      "fish $srcdir/config/fish/plugins.fish 2>/dev/null" \
      "Installing fish plugins"
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

  setup_fish
  setup_ohmyfish
  setup_fishplugins

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main
