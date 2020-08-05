#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

srcdir="$(cd .. && pwd)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
create_bash_local() {
echo ""

    declare -r FILE_PATH="$HOME/.local/.config/bash.local"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ ! -e "$FILE_PATH" ] || [ -z "$FILE_PATH" ]; then
	mv -f $srcdir/bash/bash_local $FILE_PATH
    fi

    print_result $? "$FILE_PATH"
    rm -Rf $srcdir/bash/bash_local

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
create_zsh_local() {
echo ""

    declare -r FILE_PATH="$HOME/.local/.config/zsh.local"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ ! -e "$FILE_PATH" ]; then
        printf "" >> "$FILE_PATH"
    fi

    print_result $? "$FILE_PATH"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
create_fish_local() {
echo ""

    declare -r FILE_PATH="$HOME/.local/.config/fish.local"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ ! -e "$FILE_PATH" ]; then
        printf "" >> "$FILE_PATH"
    fi

    print_result $? "$FILE_PATH"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_tmux_local() {
echo ""

    declare -r FILE_PATH="$HOME/.local/.configs/tmux.local"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ ! -e "$FILE_PATH" ]; then
        printf "" >> "$FILE_PATH"
    fi

    print_result $? "$FILE_PATH"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_vimrc_local() {
echo ""

    declare -r FILE_PATH="$HOME/.local/.configs/vimrc.local"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ ! -e "$FILE_PATH" ]; then
        printf "" >> "$FILE_PATH"
    fi

    print_result $? "$FILE_PATH"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_gitconfig_local() {
echo ""

    declare -r FILE_PATH="$HOME/.local/.configs/gitconfig.local"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ ! -e "$FILE_PATH" ]; then
        printf "" >>"$FILE_PATH"

        print_result $? "$FILE_PATH"

    fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_screen_local() {
echo ""

    declare -r FILE_PATH="$HOME/.local/.configs/screen.local"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ ! -e "$FILE_PATH" ]; then
        printf "" >>"$FILE_PATH"

        print_result $? "$FILE_PATH"

    fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

remove_bash_server() {
PROFILERC=$(ls ~/.config/bash/profile/zz-*.bash 2> /dev/null | wc -l)
if [ "$PROFILERC" != "0" ]; then rm -Rf ~/.config/bash/profile/zz-* ; fi

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
