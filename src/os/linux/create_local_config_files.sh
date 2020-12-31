#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" &&
  . "../utils.sh"

srcdir="$(cd .. && pwd)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
create_bash_local() {
  declare -r FILE_PATH="$HOME/.config/local/bash.local"
  if [ ! -e "$FILE_PATH" ] || [ -z "$FILE_PATH" ]; then
    mv -f $srcdir/bash/bash_local $FILE_PATH
    print_result $? "$FILE_PATH"
    rm -Rf $srcdir/bash/bash_local
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
create_zsh_local() {
  declare -r FILE_PATH="$HOME/.config/local/zsh.local"
  if [ ! -e "$FILE_PATH" ]; then
    printf "" >>"$FILE_PATH"
    print_result $? "$FILE_PATH"
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
create_fish_local() {
  declare -r FILE_PATH="$HOME/.config/local/fish.local"
  if [ ! -e "$FILE_PATH" ]; then
    printf "" >>"$FILE_PATH"
  fi
  print_result $? "$FILE_PATH"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_tmux_local() {
  declare -r FILE_PATH="$HOME/.config/locals/tmux.local"
  if [ ! -e "$FILE_PATH" ]; then
    printf "" >>"$FILE_PATH"
    print_result $? "$FILE_PATH"
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_vimrc_local() {
  declare -r FILE_PATH="$HOME/.config/locals/vimrc.local"
  if [ ! -e "$FILE_PATH" ]; then
    printf "" >>"$FILE_PATH"
    print_result $? "$FILE_PATH"
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_gitconfig_local() {
  declare -r FILE_PATH="$HOME/.config/locals/gitconfig.local"
  if [ ! -e "$FILE_PATH" ]; then
    printf "" >>"$FILE_PATH"
    print_result $? "$FILE_PATH"
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_screen_local() {
  declare -r FILE_PATH="$HOME/.config/locals/screen.local"
  if [ ! -e "$FILE_PATH" ]; then
    printf "" >>"$FILE_PATH"
    print_result $? "$FILE_PATH"
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

remove_bash_server() {
  PROFILERC=$(ls ~/.config/bash/profile/zz-*.bash 2>/dev/null | wc -l)
  if [ "$PROFILERC" != "0" ]; then rm -Rf ~/.config/bash/profile/zz-*; fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

  create_bash_local
  create_zsh_local
  create_fish_local
  create_tmux_local
  create_vimrc_local
  create_gitconfig_local
  create_screen_local
  remove_bash_server

}

main

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
