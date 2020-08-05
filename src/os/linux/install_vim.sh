#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

srcdir="$(cd .. && pwd)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_vim() {

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

rm -Rf ~/.vimrc
if [ -L ~/.vim ]; then unlink ~/.vim 2>/dev/null; fi
if [ -d ~/.vim ]; then rm -Rf -f ~/.vim 2>/dev/null; fi

echo ""
    execute \
       "ln -sf ~/.config/vim ~/.vim" \
        "~/.config/vim/  → ~/.vim"

echo ""
    execute \
       "ln -sf $srcdir/config/vim/vimrc ~/.vimrc" \
        "$srcdir/config/vim/vimrc  → ~/.vimrc"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ ! -d ~/.config/vim/bundle/Vundle.vim/.git ]; then
echo ""
    execute \
        "rm -Rf ~/.config/vim/bundle/Vundle.vim && \
         git clone -q https://github.com/VundleVim/Vundle.vim.git ~/.config/vim/bundle/Vundle.vim && \
         vim +PluginInstall +qall < /dev/null > /dev/null 2>&1" \
        "vim +PluginInstall +qall → ~/.config/vim/bundle/"

else
 echo ""
    execute \
        "cd ~/.config/vim/bundle/Vundle.vim && \
         git pull -q && \
         vim +PluginInstall +qall < /dev/null > /dev/null 2>&1" \
        "Updating Vundle and Plugins"
fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    install_vim

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main
