#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

srcdir="$(cd .. && pwd)"
backups="~/.config/dotfiles/backups"
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
    print_in_purple "\n • Back up Files\n\n"

    local i=""
    local sourceFile=""
    local targetFile=""
    local skipQuestions=true

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    skip_questions "$@" \
        && skipQuestions=true

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


    for i in "${FILES_TO_SYMLINK[@]}"; do
        sourceFile="$srcdir/$i"
        targetFile="$HOME/.$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"
        nameFile="$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"

        if [ -f $targetFile ] && [ ! -L $targetFile ]; then

echo ""
            execute \
                 "mv -f $targetFile $backups/home/$nameFile 2>/dev/null || exit 0" \
                 "Backing up $targetFile  →  $backups/home/$nameFile"
        fi

    done

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

backup_confsymlinks() {
    print_in_purple "\n • Back up config Files\n\n"

    local i=""
    local sourceFile=""
    local targetFile=""
    local skipQuestions=true

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    skip_questions "$@" \
        && skipQuestions=true

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    for i in "${CONFFILES_TO_SYMLINK[@]}"; do
        sourceFile="$srcdir/config/$i"
        targetFile="$HOME/.config/$i"
        nameFile="$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"

        if [ -f $targetFile ] || [ -d $targetFile ] && [ ! -L $targetFile ]; then

echo ""
            execute \
                 "mv -f $targetFile $backups/configs/$nameFile 2>/dev/null || exit 0"
                 "Backing up $targetFile → $backups/configs/$nameFile"
        fi

    done

}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


create_symlinks() {
    print_in_purple "\n • Create symlinks\n\n"

    local i=""
    local sourceFile=""
    local targetFile=""
    local skipQuestions=true

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    skip_questions "$@" \
        && skipQuestions=true

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


    for i in "${FILES_TO_SYMLINK[@]}"; do
        sourceFile="$srcdir/$i"
        targetFile="$HOME/.$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"

        unlink -f $targetFile 2>/dev/null
        rm -Rf $targetFile 2>/dev/null

echo ""
            execute \
                "ln -fs $sourceFile $targetFile" \
                "$targetFile → $sourceFile"

    done

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_confsymlinks() {
    print_in_purple "\n • Create config symlinks\n\n"

    local i=""
    local sourceFile=""
    local targetFile=""
    local skipQuestions=true

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    skip_questions "$@" \
        && skipQuestions=true

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    for i in "${CONFFILES_TO_SYMLINK[@]}"; do
        sourceFile="$srcdir/config/$i"
        targetFile="$HOME/.config/$i"

        unlink -f $targetFile 2>/dev/null
        rm -Rf $targetFile 2>/dev/null

echo ""
            execute \
                "ln -fs $sourceFile $targetFile" \
                "$targetFile → $sourceFile"

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
