#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" &&
  . "../utils.sh"

srcdir="$(cd .. && pwd)"
customizedir="$(cd $srcdir/../customize && pwd)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_icons() {
  setup() {
    ln -sf $customizedir/icons ~/.local/share/icons &&
      fc-cache -f ~/.local/share/icons/N.I.B./ &&
      fc-cache -f ~/.local/share/icons/Obsidian-Purple/
  }

  setup_old() {
    ln -sf $customizedir/icons ~/.local/share/icons &&
      rsync -aqh ~/.local/share/icons.old/* ~/.local/share/icons/ 2>/dev/null &&
      rm -Rf ~/.local/share/icons.old/ &&
      fc-cache -f ~/.local/share/icons/N.I.B./ &&
      fc-cache -f ~/.local/share/icons/Obsidian-Purple/
  }
  # - - - - - - - - - - - - - - -

  if [ -L ~/.local/share/icons ]; then unlink ~/.local/share/icons; fi
  if [ -d ~/.local/share/icons ] && [ ! -L ~/.local/share/icons ]; then
    mv -f ~/.local/share/icons ~/.local/share/icons.old
  fi

  if [ -d ~/.local/share/icons.old ]; then
    execute \
      "setup_old" \
      "$customizedir/icons → ~/.local/share/icons"
  else
    execute \
      "setup" \
      "$customizedir/icons → ~/.local/share/icons"
  fi

  find ~/.local/share/icons/ -mindepth 1 -maxdepth 1 -type d | while read -r THEME; do
    if [ -f "$THEME/index.theme" ]; then
      execute \
        "gtk-update-icon-cache -f -q $THEME" \
        "Updating ICON $THEME"
    fi
  done

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_themes() {
  setup() {
    ln -sf $customizedir/themes ~/.local/share/themes
  }

  setup_old() {
    ln -sf $customizedir/themes ~/.local/share/themes &&
      rsync -ahq ~/.local/share/themes.old/* ~/.local/share/themes/ 2>/dev/null &&
      rm -Rf ~/.local/share/themes.old/
  }
  # - - - - - - - - - - - - - - -

  if [ -L ~/.local/share/themes ]; then unlink ~/.local/share/themes; fi
  if [ -d ~/.local/share/themes ] && [ ! -L ~/.local/share/themes ]; then
    mv -f ~/.local/share/themes ~/.local/share/themes.old
  fi

  if [ -d ~/.local/share/themes.old ]; then
    execute \
      "setup_old" \
      "$customizedir/themes → ~/.local/share/themes"
  else
    execute \
      "setup" \
      "$customizedir/themes → ~/.local/share/themes"
  fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_fonts() {
  setup() {
    ln -sf $customizedir/fonts ~/.local/share/fonts &&
      fc-cache -f
  }
  setup_old() {
    ln -sf $customizedir/fonts ~/.local/share/fonts &&
      rsync -ahq ~/.local/share/fonts.old/* ~/.local/share/fonts/ 2>/dev/null &&
      rm -Rf ~/.local/share/fonts.old/ &&
      fc-cache -f
  }
  # - - - - - - - - - - - - - - -

  if [ -L ~/.local/share/fonts ]; then unlink ~/.local/share/fonts; fi
  if [ -d ~/.local/share/fonts ] && [ ! -L ~/.local/share/fonts ]; then
    mv -f ~/.local/share/fonts ~/.local/share/fonts.old
  fi

  if [ -d ~/.local/share/fonts.old ]; then
    execute \
      "setup_old" \
      "$customizedir/fonts → ~/.local/share/fonts"

  else
    execute \
      "setup" \
      "$customizedir/fonts → ~/.local/share/fonts"
  fi

}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

  create_themes
  create_fonts
  create_icons

}

main
