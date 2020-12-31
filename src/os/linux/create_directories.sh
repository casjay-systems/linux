#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" &&
  . "../utils.sh"

srcdir="$(cd .. && pwd)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_directories() {
  echo ""
  declare -a DIRECTORIES=(
    "$HOME/Projects"
    "$HOME/.config"
    "$HOME/.config/local"
    "$HOME/.local/share/torrents"
  )

  for i in "${DIRECTORIES[@]}"; do
    mkd "$i"
  done

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

  create_directories

}

main
