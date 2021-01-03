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
  "misc"
  "bash"
  "Thunar"
  "filezilla"
  "geany"
  "fish"
  "fontconfig"
  "jgmenu"
  "neofetch"
  "nitrogen"
  "obmenu-generator"
  "pavucontrol-qt"
  "plank"
  "polybar"
  "terminology"
  "variety"
  "vifm"
  "mimeapps.list"
  "monitors.xml"
  "transmission-daemon"
  "zsh"
  "git"
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

    if [ -f "$targetFile" ] && [ ! -L "$targetFile" ] && [ -e "$sourceFile" ]; then
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

    if [ -f $targetFile ] || [ -d $targetFile ] && [ ! -L $targetFile ] && [ ! -f $srcdir/config/$i/install.sh ] && [ -e "$sourceFile" ]; then
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
      unlink $targetFile 2>/dev/null
      rm -Rf $targetFile 2>/dev/null
      execute \
        "ln -fs $sourceFile $targetFile" \
        "$targetFile → $sourceFile"
    fi
  done
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_confsymlinks() {
  setup() {
    ln -fs $sourceFile $targetFile
    if [ -f "$targetFile/install.sh" ]; then
      "$targetFile/install.sh"
    fi
  }

  print_in_purple "\n • Create config symlinks\n"
  local i=""
  local sourceFile=""
  local targetFile=""
  local skipQuestions=true
  skip_questions "$@" && skipQuestions=true

  for i in "${CONFFILES_TO_SYMLINK[@]}"; do
    sourceFile="$srcdir/config/$i"
    targetFile="$HOME/.config/$i"
    unlink $targetFile 2>/dev/null
    rm -Rf $targetFile 2>/dev/null
    if [ -e "$sourceFile" ]; then
      execute \
        "setup" \
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
