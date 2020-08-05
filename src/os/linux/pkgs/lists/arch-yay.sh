#!/usr/bin/env bash

INSTPKGS="aurvote-git bullshit visual-studio-code-bin command-not-found conky-lua-archers downgrade fontawesome.sty glxinfo hardcode-fixer-git hollywood i3-gaps-next-git mintstick-git nfc-eventd-git obmenu-generator oxy-neon pamac-aur polybar-git screenkey tageditor timeshift toilet tty-clock urxvt-resize-font-git wttr yad"

for i in $INSTPKGS; do
  yay -Sy --needed --noconfirm --cleanafter $i >/dev/null 2>&1
done
touch /etc/pacman/.srckeys
