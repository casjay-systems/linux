#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

srcdir="$(cd .. && pwd)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

setup_tmux() {

rm -Rf ~/.tmux.conf
if [ -L ~/.tmux ]; then unlink ~/.tmux 2>/dev/null; fi
if [ -d ~/.tmux ]; then rm -Rf -f ~/.tmux 2>/dev/null; fi

echo ""
    execute \
        "ln -sf ~/.local/dotfiles/src/config/tmux ~/.tmux" \
        "~/.local/dotfiles/src/config/tmux → ~/.tmux"

echo ""
    execute \
        "ln -sf $srcdir/config/tmux/tmux.conf ~/.tmux.conf" \
        "$srcdir/config/tmux/tmux.conf → ~/.tmux.conf"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

setup_tmuxplugins() {
if [ -d ~/.local/dotfiles/src/config/tmux/tmux/plugins/tpm ]; then

echo ""
     execute \
        "cd ~/.config/tmux/plugins/tpm && \
         git pull -q" \
        "Updating tmux plugin manager"
echo ""
     execute \
        "bash ~/.config/tmux/plugins/tpm/scripts/install_plugins.sh 2> /dev/null" \
        "Updating tmux plugins"
else

echo ""
     execute \
        "rm -Rf ~/.config/tmux/plugins/tpm && \
         git clone -q https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm" \
        "https://github.com/tmux-plugins/tpm → ~/.config/tmux/plugins/tpm"
echo ""
     execute \
        "bash ~/.config/tmux/plugins/tpm/scripts/install_plugins.sh" \
        "Installing tmux plugins → ~/.config/tmux/plugins"
fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


main() {

    setup_tmux

    setup_tmuxplugins

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main

