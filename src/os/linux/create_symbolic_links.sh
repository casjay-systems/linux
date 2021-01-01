#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" &&
  . "../utils.sh"

srcdir="$(cd .. && pwd)"
backups="$HOME/.config/dotfiles/backups"
mkdir -p "$backups/configs"
mkdir -p "$backups/home"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

declare -a FILES_TO_SYMLINK=(
  "config/xmonad"
  "config/bash/bash_logout"
  "config/bash/bash_profile"
  "config/bash/bashrc"
  "shell/curlrc"
  "shell/dircolors"
  "shell/inputrc"
  "shell/profile"
  "shell/Xresources"
  "shell/xscreensaver"
  "shell/face"
  "shell/gntrc"

)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

declare -a CONFFILES_TO_SYMLINK=(
  "bash"
  "Thunar"
  "awesome"
  "autostart"
  "filezilla"
  "gtk-2.0"
  "gtk-3.0"
  "geany"
  "filezilla"
  "fish"
  "fontconfig"
  "i3"
  "jgmenu"
  "neofetch"
  "nitrogen"
  "obmenu-generator"
  "openbox"
  "pavucontrol-qt"
  "plank"
  "polybar"
  "qtile"
  "remmina"
  "smplayer"
  "smtube"
  "terminology"
  "termite"
  "variety"
  "vifm"
  "xfce4"
  "mimeapps.list"
  "monitors.xml"
  "transmission-daemon"
  "zsh"
  "git"
  "spotifyd"
  "tmux"
  "vim"

)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

backup_symlinks() {
  local i=""
  local sourceFile=""
  local targetFile=""
  local skipQuestions=true

  skip_questions "$@" && skipQuestions=true

  for i in "${FILES_TO_SYMLINK[@]}"; do
    sourceFile="$srcdir/$i"
    targetFile="$HOME/.$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"
    nameFile="$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"

    if [ -f "$targetFile" ] && [ ! -L "$targetFile" ]; then
      execute \
        "mv -f $targetFile $backups/home/$nameFile" \
        "Backing up $targetFile  →  $backups/home/$nameFile"
    fi
  done
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

backup_confsymlinks() {
  local i=""
  local sourceFile=""
  local targetFile=""
  local skipQuestions=true

  skip_questions "$@" && skipQuestions=true

  for i in "${CONFFILES_TO_SYMLINK[@]}"; do
    sourceFile="$srcdir/config/$i"
    targetFile="$HOME/.config/$i"
    nameFile="$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"

    if [ -f $targetFile ] || [ -d $targetFile ] && [ ! -L $targetFile ] && [ ! -f $srcdir/config/$i/install.sh ]; then
      execute \
        "mv -f $targetFile $backups/configs/$nameFile" \
        "Backing up $targetFile → $backups/configs/$nameFile"
    fi
  done
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_symlinks() {
  print_in_purple "\n • Create file symlinks\n"
  local i=""
  local sourceFile=""
  local targetFile=""
  local skipQuestions=true
  skip_questions "$@" && skipQuestions=true

  for i in "${FILES_TO_SYMLINK[@]}"; do
    sourceFile="$srcdir/$i"
    targetFile="$HOME/.$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"
    if [ -e "$sourceFile" ]; then
      unlink -f $targetFile 2>/dev/null
      rm -Rf $targetFile 2>/dev/null
      execute \
        "ln -fs $sourceFile $targetFile" \
        "$targetFile → $sourceFile"
    fi
  done
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_confsymlinks() {
  print_in_purple "\n • Create config symlinks\n"
  local i=""
  local sourceFile=""
  local targetFile=""
  local skipQuestions=true
  skip_questions "$@" && skipQuestions=true

  for i in "${CONFFILES_TO_SYMLINK[@]}"; do
    sourceFile="$srcdir/config/$i"
    targetFile="$HOME/.config/$i"
    unlink -f $targetFile 2>/dev/null
    rm -Rf $targetFile 2>/dev/null
    if [ -e "$sourceFile" ]; then
      execute \
        "ln -fs $sourceFile $targetFile" \
        "$targetFile → $sourceFile"
    fi
  done
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

  backup_symlinks "$@"
  backup_confsymlinks "$@"
  create_symlinks "$@"
  create_confsymlinks "$@"

}

main "$@"
unset main backups
