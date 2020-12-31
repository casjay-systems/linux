#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" &&
  . "../utils.sh"

srcdir="$(cd .. && pwd)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_git() {
  if [ -f "$HOME/.config/git/install.sh" ]; then
    execute "$HOME/.config/git/install.sh" "Installing GIT"
  else
    echo ""
    execute \
      "ln -sf $srcdir/config/git/gitconfig ~/.gitconfig" \
      "$srcdir/config/git/gitconfig  → ~/.gitconfig"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_ohmygit() {

  if [ ! -d "$HOME/.local/share/git/oh-my-git/.git" ]; then

    echo ""
    execute \
      "rm -Rf $HOME/.local/share/git/oh-my-git/.git && \
      git clone https://github.com/arialdomartini/oh-my-git.git $HOME/.local/share/git/oh-my-git/.git" \
      "cloning oh-my-git → ~/.config/git/plugins"

  else
    echo ""
    execute \
      "git -C $HOME/.local/share/git/oh-my-git/.git pull -q" \
      "Updating oh-my-git"

  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  isInFile=$(cat ~/.config/local/bash.local | grep -c "oh-my-git")
  if [ $isInFile -eq 0 ]; then

    declare -r CONFIGS="
# OH-MY-GIT

[ -f \"\$HOME/.local/share/git/oh-my-git/prompt.sh\" ] \\
    && source \"\$HOME/.local/share/git/oh-my-git/prompt.sh\"
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
