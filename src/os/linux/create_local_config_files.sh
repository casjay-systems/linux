#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" &&
  . "../utils.sh"

srcdir="$(cd .. && pwd)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
create_bash_local() {
  declare -r FILE_PATH="$HOME/.config/local/bash.local"
  if [ ! -e "$FILE_PATH" ]; then
    printf "" >>"$FILE_PATH"
  fi
  print_result $? "$FILE_PATH"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
create_zsh_local() {
  declare -r FILE_PATH="$HOME/.config/local/zsh.local"
  if [ ! -e "$FILE_PATH" ]; then
    printf "" >>"$FILE_PATH"
  fi
  print_result $? "$FILE_PATH"
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
  declare -r FILE_PATH="$HOME/.config/local/tmux.local"
  if [ ! -e "$FILE_PATH" ]; then
    printf "" >>"$FILE_PATH"
  fi
  print_result $? "$FILE_PATH"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_vimrc_local() {
  declare -r FILE_PATH="$HOME/.config/local/vimrc.local"
  if [ ! -e "$FILE_PATH" ]; then
    printf "" >>"$FILE_PATH"
  fi
  print_result $? "$FILE_PATH"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_gitconfig_local() {
  declare -r FILE_PATH="$HOME/.config/local/gitconfig.local"
  if [ ! -e "$FILE_PATH" ]; then
    printf "" >>"$FILE_PATH"
  fi
  print_result $? "$FILE_PATH"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_screen_local() {
  declare -r FILE_PATH="$HOME/.config/local/screen.local"
  if [ ! -e "$FILE_PATH" ]; then
    printf "" >>"$FILE_PATH"
  fi
  print_result $? "$FILE_PATH"
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
