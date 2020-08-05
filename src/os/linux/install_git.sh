#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" &&
    . "../utils.sh"

srcdir="$(cd .. && pwd)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_git() {

scho ""
    execute \
        "ln -sf $srcdir/config/git/gitconfig ~/.gitconfig" \
        "$srcdir/config/git/gitconfig  → ~/.gitconfig"

}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
install_ohmygit() {

    if [ ! -d ~/.config/git/plugins/.git ]; then

echo ""
        execute \
            "rm -Rf ~/.config/git/plugins/.git && \
             git clone https://github.com/arialdomartini/oh-my-git.git ~/.config/git/plugins" \
            "cloning oh-my-git → ~/.config/git/plugins"

    else
echo ""
        execute \
            "cd ~/.config/git/plugins && \
             git pull -q" \
            "Updating oh-my-git"

    fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
isInFile=$(cat ~/.config/local/bash.local | grep -c "oh-my-git")
if [ $isInFile -eq 0 ]; then

    declare -r CONFIGS="
# OH-MY-GIT

[ -f \"\$HOME/.config/git/plugins/prompt.sh\" ] \\
    && source \"\$HOME/.config/git/plugins/prompt.sh\"
"

echo ""
        execute \
            "printf '%s' '$CONFIGS' >> ~/.config/local/bash.local" \
            "Enabling oh-my-git in ~/.config/local/bash.local"
fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

        install_git

        install_ohmygit

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main
