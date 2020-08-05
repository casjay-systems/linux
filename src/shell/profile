# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# export gpg tty
export GPG_TTY=$(tty)

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
    fi
fi

if [ ! -f ~/.Xdefaults ]; then
    touch ~/.Xdefaults
  else
    xrdb ~/.Xdefaults 2>/dev/null
fi

if [ ! -f ~/.Xresources ]; then
    touch ~/.Xresources
  else
    xrdb ~/.Xresources 2>/dev/null
    xrdb -merge ~/.Xresources 2>/dev/null
fi

if [ -f ~/.local/.configs/gitconfig.local ] && [ ! -f ~/.gitconfig ]; then
cp -f ~/.local/.configs/gitconfig.local ~/.gitconfig
fi

if [[ "$(python3 -V)" =~ "Python 3" ]]; then
export PATH="${PATH}:$(python3 -c 'import site; print(site.USER_BASE)')/bin"
elif -f [[ "$(python2 -V)" =~ "Python 2" ]]; then
export PATH="${PATH}:$(python -c 'import site; print(site.USER_BASE)')/bin"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

