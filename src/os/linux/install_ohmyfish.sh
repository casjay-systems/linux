#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

srcdir="$(cd .. && pwd)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

setup_fish() {
if [ -d ~/.config/fish/plugins/.git ]; then
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
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

setup_ohmyfish() {

if [ -d ~/.config/fish/plugins/.git ]; then
  echo ""
     execute \
        "cd ~/.config/fish/plugins && git pull -q >/dev/null 2>&1" \
        "Updating oh-my-fish"
else
  echo ""
     execute \
        "fish $HOME/.config/fish/omf-install --path=~/.config/fish/plugins --config=~/.config/fish/omf --noninteractive --yes" \
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
