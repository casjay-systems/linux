#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

srcdir="$(cd ../.. && pwd)"
customizedir="$(cd ../../customize && pwd)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_icons() {
if [ -L ~/.local/share/icons ]; then unlink ~/.local/share/icons ; fi
if [ -d ~/.local/share/icons ] && [ ! -L ~/.local/share/icons ]; then
 mv -f ~/.local/share/icons ~/.local/share/icons.old
fi

echo ""
if [ -d ~/.local/share/icons.old ]; then
    execute \
        "ln -sf $customizedir/icons ~/.local/share/icons && \
         rsync -aqh ~/.local/share/icons.old/* ~/.local/share/icons/ 2>/dev/null && \
         rm -Rf ~/.local/share/icons.old/ && \
         fc-cache -f ~/.local/share/icons/N.I.B./ && \
         fc-cache -f ~/.local/share/icons/Obsidian-Purple/" \
        "$customizedir/icons → ~/.local/share/icons"
else
    execute \
        "ln -sf $customizedir/icons ~/.local/share/icons && \
         fc-cache -f ~/.local/share/icons/N.I.B./ && \
         fc-cache -f ~/.local/share/icons/Obsidian-Purple/" \
        "$customizedir/icons → ~/.local/share/icons"
fi

echo ""
find ~/.local/share/icons/ -mindepth 1 -maxdepth 1 -type d | while read -r THEME; do
 if [ -f "$THEME/index.theme" ]; then
    execute \
        "gtk-update-icon-cache -f -q "$THEME"" \
        "Updating ICON cache"
 fi
done

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_themes() {

if [ -L ~/.local/share/themes ]; then unlink ~/.local/share/themes ; fi
if [ -d ~/.local/share/themes ] && [ ! -L ~/.local/share/themes ]; then
 mv -f ~/.local/share/themes ~/.local/share/themes.old
fi

echo ""
if [ -d ~/.local/share/themes.old ]; then
    execute \
        "ln -sf $customizedir/themes ~/.local/share/themes && \
         rsync -ahq ~/.local/share/themes.old/* ~/.local/share/themes/ 2>/dev/null && \
         rm -Rf ~/.local/share/themes.old/"
        "$customizedir/themes → ~/.local/share/themes"
else
    execute \
        "ln -sf $customizedir/themes ~/.local/share/themes" \
        "$customizedir/themes → ~/.local/share/themes"
fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_fonts() {

if [ -L ~/.local/share/fonts ]; then unlink ~/.local/share/fonts ; fi
if [ -d ~/.local/share/fonts ] && [ ! -L ~/.local/share/fonts ]; then
 mv -f ~/.local/share/fonts ~/.local/share/fonts.old
fi

echo ""
if [ -d ~/.local/share/fonts.old ]; then
    execute \
        "ln -sf $customizedir/fonts ~/.local/share/fonts && \
         rsync -ahq ~/.local/share/fonts.old/* ~/.local/share/fonts/ 2>/dev/null && \
         rm -Rf ~/.local/share/fonts.old/ && \
         fc-cache -f" \
        "$customizedir/fonts → ~/.local/share/fonts"

else
    execute \
        "ln -sf $customizedir/fonts ~/.local/share/fonts && \
         fc-cache -f" \
        "$customizedir/fonts → ~/.local/share/fonts"
fi

}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    create_icons

    create_themes

    create_fonts

}

main

