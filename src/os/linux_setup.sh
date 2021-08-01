#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename "$0")"
VERSION="031220211542-git"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#set opts

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 031220211542-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.com
# @License       : LICENSE.md
# @ReadME        : template --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created       : Friday, Apr 02, 2021 13:11 EDT
# @File          : template
# @Description   : Linux setup script
# @TODO          : Refactor the code
# @Other         :
# @Resource      :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/local/sbin:/usr/sbin:/sbin

#Modify and set if using the auth token
AUTHTOKEN=""
# either http https or git
GITPROTO="https://"
#Your git repo
GITREPO="github.com/casjay-systems/linux"
# Git Command - Private Repo
#GITURL="$GITPROTO$AUTHTOKEN:x-oauth-basic@$GITREPO"
#Public Repo
GITURL="$GITPROTO$GITREPO"
# Default NTP Server
NTPSERVER="0.casjay.pool.ntp.org"
# Set the temp directory
DOTTEMP="/tmp/dotfiles-desktop-$USER"
# Default dotfiles dir
# Set primary dir - not used
DOTFILES="$HOME/.local/dotfiles/linux"

SUDO_PROMPT="$(printf "\033[1;36m")   • [sudo]$(printf "\033[0m") password for %p: "

dotfilesDirectory="$DOTFILES"
srcdir="$dotfilesDirectory/src"
linuxosdir="$srcdir/os/linux"
backupsdir="$HOME/.local/backups/dotfiles/linux"

export DOTFILES DOTTEMP dotfilesDirectory srcdir linuxosdir backupsdir SUDO_PROMPT

##################################################################################################

# Define colors
PURPLE='\033[0;35m'
BLUE='\033[0;34m'
RED='\033[0;31m'
GREEN='\033[32m'
YELLOW='\033[0;33m'
NC='\033[0m'
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [[ ! "$OSTYPE" =~ ^linux ]]; then
  printf "\n\t\t${RED}   This script is for Linux ${NC}\n\n"
  exit 1
fi

# Grab the OS detection script if it doesn't exist script

if [ -f "$srcdir/os/osdetect.sh" ] && [ -f "$srcdir/os/utils.sh" ]; then
  source "$srcdir/os/utils.sh"
  source "$srcdir/os/osdetect.sh"
else
  curl -Lsq "https://$GITREPO/raw/main/src/os/utils.sh" -o /tmp/utils.sh
  curl -Lsq "https://$GITREPO/raw/main/src/os/osdetect.sh" -o /tmp/osdetect.sh
  if [ -f "/tmp/osdetect.sh" ] && [ -f "/tmp/utils.sh" ]; then
    source /tmp/utils.sh
    source /tmp/osdetect.sh
    rm -Rf /tmp/utils.sh /tmp/osdetect.sh
  else
    clear
    printf "\n\n\n\n${BLUE}   Could not source the files needed${NC}\n\n\n\n"
    exit 1
  fi
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [[ "$(python3 -V 2>/dev/null)" =~ "Python 3" ]]; then
  PYTHONVER="python3"
  PIP="pip3"
  export PATH="${PATH}:$(python3 -c 'import site; print(site.USER_BASE)')/bin"
elif [[ "$(python2 -V 2>/dev/null)" =~ "Python 2" ]]; then
  PYTHONVER="python"
  PIP="pip"
  export PATH="${PATH}:$(python -c 'import site; print(site.USER_BASE)')/bin"
fi

##################################################################################################

if [ -f "$HOME/.config/dotfiles/env" ]; then
  source "$HOME/.config/dotfiles/env"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Automatic linux install

###############################################################################################
clear                                                                               #
printf "\n\n\n\n\n${BLUE}   *** Initializing the installer please wait *** ${NC}\n" #
###############################################################################################
if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null; then
  printf "\n${RED}   • Getting root privileges •${NC}\n" &&
    ask_for_sudo
  if [ "$?" -eq 0 ]; then
    printf "${GREEN}   • Received root privileges •${NC}\n\n"
  else
    printf "${GREEN}   • Can not get access to sudo •${NC}\n\n"
    exit 1
  fi
else
  printf "${GREEN}   • Can not get access to sudo •${NC}\n\n"
  exit 1
fi

# Remove previous installs
if [ ! -d "$DOTFILES/.git" ]; then
  rm -Rf "$DOTFILES"
fi

if [ -d $HOME/.config/bash/profile ]; then rm -Rf $HOME/.config/bash/profile/zz-*; fi
if [ ! -d "$HOME/.config/dotfiles/backups/configs" ]; then mkdir -p "$HOME/.config/dotfiles/backups/configs"; fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -z $UPDATE ]; then
  if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null; then
    #Define the package manager and install option
    if [ -f /usr/bin/apt ]; then
      LSBPAC=lsb-release
      pkgmgr="DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" --ignore-missing --allow-unauthenticated --assume-yes"
      instoption="-yy -qq install"
      instupdateoption="update && sudo $pkgmgr dist-upgrade -yy -qq"
      instchkupdatecmd="$(sudo apt-get update >/dev/null && apt-get --just-print upgrade | grep "Inst " | wc -l)"
      ##
    elif [ -f /usr/bin/yum ]; then
      LSBPAC=redhat-lsb
      pkgmgr="yum"
      instoption="install -y -q"
      instupdateoption="install -y -q --skip-broken"
      instchkupdatecmd="$(sudo yum check-update -q | grep -v Security | wc -l)"
      ##
    elif [ -f /usr/bin/dnf ]; then
      LSBPAC=redhat-lsb
      pkgmgr="dnf"
      instoption="install -y -q --skip-broken"
      instupdateoption="update -y -q"
      instchkupdatecmd="$(sudo dnf check-update -q | grep -v Security | wc -l)"
      ##
    elif [ -f /usr/bin/pacman ]; then
      LSBPAC=lsb-release
      pkgmgr="pacman"
      instoption="-Syy --needed --noconfirm"
      instupdateoption="--Syyu --noconfirm"
      instchkupdatecmd="$(checkupdates 2>/dev/null | wc -l)"
    fi

    if [[ "$instchkupdatecmd" != 0 ]]; then
      printf "\n${RED}   *** Please update your system before runng this installer ***${NC}\n"
      printf "\n${RED}   *** You have $instchkupdatecmd update available ***${NC}\n\n\n\n"
      exit 1
    fi
  fi
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Welcome message

wait_time=10 # seconds
temp_cnt=${wait_time}
printf "\n\n\n${GREEN}   *** ${RED}•${GREEN} Welcome to my dotfiles Installer for linux ${RED}•${GREEN} ***${NC}\n"
printf "${YELLOW}   *** • Your Distro is $distroname and is based on $DISTRO • ***${NC}\n\n\n"

while [[ ${temp_cnt} -gt 0 ]]; do
  printf "\r${GREEN}   *** ${RED}•${GREEN} You have %2d second(s) remaining to hit Ctrl+C to cancel ${RED}•${GREEN} ***" ${temp_cnt}
  sleep 1
  ((temp_cnt--))
done
printf "${NC}\n\n\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

##### for when I'm forgetful
if [ -z $dotfilesDirectory ]; then printf "\n${RED}   *** dotfiles directory not specified ***${NC}\n"; fi
if [ -z $srcdir ]; then printf "\n${RED}   *** dotfiles src directory not specified ***${NC}\n"; fi
if [ -z $linuxosdir ]; then printf "\n${RED}   *** dotfiles linuxos directory not specified ***${NC}\n"; fi
#####
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

GIT=$(command -v git 2>/dev/null)
CURL=$(command -v curl 2>/dev/null)
WGET=$(command -v wget 2>/dev/null)
VIM=$(command -v vim 2>/dev/null)
TMUX=$(command -v tmux 2>/dev/null)
ZSH=$(command -v zsh 2>/dev/null)
FISH=$(command -v fish 2>/dev/null)
SUDO=$(command -v sudo 2>/dev/null)
LSBR=$(command -v lsb_release 2>/dev/null)
POLYBAR=$(command -v polybar 2>/dev/null)
JGMENU=$(command -v jgmenu 2>/dev/null)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# no sudo can't continue
if ! (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null; then
  if [[ -z "$SUDU" ]] && [[ -z "$UPDATE" ]]; then
    printf "\n${GREEN}   *** ${RED}•${GREEN} UPDATE=yes bash -c "$(curl -LsS https://$GITREPO/raw/main/src/os/setup.sh)" ${RED}•${GREEN} ***${NC}\n"
    printf "\n${GREEN}   *** ${RED}•${GREEN} to install just the dotfiles ${RED}•${GREEN} ***${NC}\n"
    printf "\n${RED}   *** ${RED}•${GREEN} No sudo or root privileges ${RED}•${GREEN} ***${NC}\n\n"
    exit
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -z "$UPDATE" ]; then
  if ! (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null && [ -z "$POLYBAR" ]; then
    printf "
  ${RED}\n   • Please run one of the following commands as root:${NC}
  ${GREEN}if running Arch you can just do${RED} su -c $srcdir/os/linux/pkgs/lists/arch.sh${NC}
  ${GREEN}if running Centos you can just do${RED} su -c $srcdir/os/linux/pkgs/lists/rhel.sh${NC}
  ${GREEN}if running Debian you can just do${RED} su -c $srcdir/os/linux/pkgs/lists/debian-sys.sh${NC}
  ${GREEN}if running Fedora you can just do${RED} su -c $srcdir/os/linux/pkgs/lists/fedora-sys.sh${NC}
  ${GREEN}if running Ubuntu you can just do${RED} su -c $srcdir/os/linux/pkgs/lists/ubuntu-sys.sh${NC}
  ${GREEN}if running Raspbian you can just do${RED} su -c $srcdir/os/linux/pkgs/lists/raspbian-sys.sh${NC}
                          \n${RED}then come back to this installer ${NC}\n\n"
    exit
  fi
fi

# Lets check for git, curl, wget
unset MISSING
if [[ ! "$GIT" ]]; then MISSING="$MISSING git"; fi
if [[ ! "$CURL" ]]; then MISSING="$MISSING curl"; fi
if [[ ! "$WGET" ]]; then MISSING="$MISSING wget"; fi
if [[ ! "$VIM" ]]; then MISSING="$MISSING vim"; fi
if [[ ! "$TMUX" ]]; then MISSING="$MISSING tmux"; fi
if [[ ! "$ZSH" ]]; then MISSING="$MISSING zsh"; fi
if [[ ! "$FISH" ]]; then MISSING="$MISSING fish"; fi
if [[ ! "$SUDO" ]]; then MISSING="$MISSING sudo"; fi
if [[ ! "$LSBR" ]]; then MISSING="$MISSING $LSBPAC"; fi

if [ -z "$LSBR" ] || [ -z "$GIT" ] || [ -z "$CURL" ] || [ -z "$WGET" ] || [ -z "$VIM" ] || [ -z "$TMUX" ] || [ -z "$ZSH" ] || [ -z "$FISH" ] || [ -z "$SUDO" ]; then
  printf "${RED}   *** • The following are needed: • ***${NC}\n"
  printf "${RED}   *** • ${MISSING} • ***${NC}\n"
  if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null; then
    execute "sudo $pkgmgr $instoption ${MISSING}" "  *** • Attempting to install the missing package[s] • ***"
  else
    printf "${RED}   *** • I can't get root access You will have to manually install the missing programs • ***${NC}\n"
    printf "${RED}   *** • ${MISSING} • ***${NC}\n\n\n"
    exit
  fi
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set version from git

CURDOTFVERSION="$(curl -LSsq "https://$GITREPO/raw/main/version.txt" | grep -v "#" | head)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Print info

printf "\n${GREEN}   *** • git, curl, wget, vim, tmux, zsh, fish, sudo are present • ***${NC}\n\n"
printf "${GREEN}   *** • Installing version $CURDOTFVERSION • ***${NC}\n\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup the dotfiles Directory

if [ -d "$dotfilesDirectory/.git" ]; then
  printf "\n${PURPLE}   • Updating the git repo - $dotfilesDirectory${NC}\n"
  cd "$srcdir/os" && source "utils.sh"

  execute \
    "git -C $dotfilesDirectory reset --hard -q >/dev/null && \
    git -C $dotfilesDirectory pull --recurse-submodules -q" \
    "Updating dotfiles"

  NEWVERSION="$(cat "$DOTFILES/version.txt" | tail -n 1)"
  REVER="$(cd $dotfilesDirectory && git rev-parse --short HEAD)"
  printf "${GREEN}   [✔] Updated to $NEWVERSION - revision: $REVER${NC}\n"
  printf "${PURPLE}   • Updating the git repo completed${NC}\n\n"
else

  printf "\n${PURPLE}   • Cloning the git repo - $dotfilesDirectory${NC}\n"
  rm -Rf $dotfilesDirectory
  git clone --recursive -q $GITURL $dotfilesDirectory >/dev/null 2>&1
  printf "${GREEN}   [✔] cloned $GITURL  → $dotfilesDirectory \n"
  NEWVERSION="$(cat "$DOTFILES/version.txt" | tail -n 1)"
  REVER="$(cd $dotfilesDirectory && git rev-parse --short HEAD)"
  printf "${GREEN}   [✔] downloaded version $NEWVERSION - revision: $REVER${NC}\n"
  cd "$srcdir/os" && source "utils.sh"
  printf "${PURPLE}   • Cloning the git repo completed${NC}\n\n"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Make Directories and fix permissions

mkdir -p ~/.gnupg ~/.ssh 2>/dev/null
find "$HOME" -xtype l -delete 2>/dev/null
find ~/.gnupg ~/.ssh -type f -exec chmod 600 {} \; 2>/dev/null
find ~/.gnupg ~/.ssh -type d -exec chmod 700 {} \; 2>/dev/null
find "$dotfilesDirectory/" -iname "*.sh" -exec chmod 755 {} \; 2>/dev/null

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Check for then get root permissions
if [ -z "$UPDATE" ] || [ "$1" = "--force" ]; then
  if (sudo true && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null; then
    printf "\n${RED}   • Getting root privileges${NC}\n"
    ask_for_sudo
    printf "${GREEN}   • Received root privileges${NC}\n\n"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Install Packages
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # MacOS setup
    printf "\n${PURPLE}   • Setting up for ${DISTRO} $(get_os_version) ${NC}\n"
    source "$linuxosdir/install_packages.sh"
    printf "\n${PURPLE}   • Done Setting up for the ${DISTRO}${NC}\n\n"
  fi
fi
###################################################################

# grab the modules
printf "\n${PURPLE}   *** • Downloading additional configuration files • ***${NC}\n"
if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null; then
  systemmgr_inst() {
    sudo bash -c "$(curl -LSs https://github.com/systemmgr/installer/raw/main/install.sh)" >/dev/null 2>&1 &&
      systemmgr install installer >/dev/null 2>&1
  }

  if [ -z "$(command -v systemmgr 2>/dev/null)" ]; then
    execute "systemmgr_inst" "installing system scripts"
  else
    execute "systemmgr_inst" "Updating system scripts"
  fi
fi

for config in bash geany git htop neofetch fish tmux terminology Thunar transmission variety vifm vim zsh; do
  if [ -d "$dotfilesDirectory/src/config/$config/.git" ]; then
    execute \
      "git -C $dotfilesDirectory/src/config/$config reset --hard -q && \
      git -C $dotfilesDirectory/src/config/$config pull -q" \
      "Updating $config module"
  else
    rm -Rf "$dotfilesDirectory/src/config/$config"
    execute \
      "git clone -q https://github.com/dfmgr/$config $dotfilesDirectory/src/config/$config" \
      "Installing $config module"
  fi
done
printf "${PURPLE}   *** • Downloading additional configuration files completed • ***${NC}\n\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Install additional system files if root
if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null; then
  print_in_purple "\n   • Installing system files\n"
  sudo bash -c "$linuxosdir/install_system_files.sh"
  print_in_purple "   • Installing system files completed\n\n"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create user directories
print_in_purple "\n   • Creating directories\n"
bash -c $linuxosdir/create_directories.sh
print_in_purple "   • Creating directories completed\n"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create user .local files
print_in_purple "\n   • Create local config files\n"
bash -c $linuxosdir/create_local_config_files.sh
print_in_purple "   • Create local config files completed\n\n"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create user dotfile symlinks
print_in_purple "\n   • Backing up and creating user files\n"
bash -c $linuxosdir/create_symbolic_links.sh
print_in_purple "   • Create user files completed\n\n"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create user themes/fonts/icons or install to system if root
print_in_purple "\n   • Installing Customizations\n"
bash -c $linuxosdir/install_customizations.sh
print_in_purple "   • Installing Customizations completed\n\n"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create and Setup git
GIT=$(which git 2>/dev/null)
if [ -z "$GIT" ]; then print_in_red "\n   • The git package is not installed\n\n"; else
  print_in_purple "\n   • Installing GIT\n"
  bash -c $linuxosdir/install_git.sh
  print_in_purple "   • Installing GIT completed\n\n"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create and Setup vim
VIM=$(which vim 2>/dev/null)
if [ -z "$VIM" ]; then print_in_red "\n   • The vim package is not installed\n\n"; else
  print_in_purple "\n   • Installing vim with plugins\n"
  bash -c $linuxosdir/install_vim.sh
  print_in_purple "   • Installing vim with plugins completed\n\n"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create and Setup tmux
TMUX=$(which tmux 2>/dev/null)
if [ -z "$TMUX" ]; then print_in_red "\n   • The tmux package is not installed\n\n"; else
  print_in_purple "\n   • Installing tmux plugins\n"
  bash -c $linuxosdir/install_tmux.sh
  print_in_purple "   • Installing tmux plugins completed\n\n"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create and Setup zsh
ZSH=$(which zsh 2>/dev/null)
if [ -z "$ZSH" ]; then print_in_red "\n   • The zsh package is not installed\n\n"; else
  print_in_purple "\n   • Installing zsh with plugins\n"
  bash -c $linuxosdir/install_ohmyzsh.sh
  print_in_purple "   • Installing zsh with plugins completed\n\n"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create and Setup fish
FISH=$(which fish 2>/dev/null)
if [ -z "$FISH" ]; then print_in_red "\n   • The fish package is not installed\n\n"; else
  print_in_purple "\n   • Installing fish shell and plugins\n"
  bash -c $linuxosdir/install_ohmyfish.sh
  print_in_purple " • Installing fish shell and plugins completed\n\n"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Create and Setup Visual Studio code
CODE=$(command -v code 2>/dev/null)
if [ -z "$CODE" ]; then print_in_red "\n   • The Visual Studio code package is not installed\n\n"; else
  print_in_purple "\n   • Installing Visual Studio code and plugins\n"
  $linuxosdir/install_vscode.sh
  print_in_purple "   • Installing Visual Studio code shell and plugins completed\n"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#No point in running if no desktop
if [ -n "$DESKTOP_SESSION" ]; then
  # Compile and Install polybar
  POLYBAR=$(which polybar 2>/dev/null)
  if [ -z $UPDATE ]; then
    print_in_purple "\n   • polybar install\n\n"
    if [ -n "$POLYBAR" ]; then print_in_green "   •  polybar already installed\n"; else
      sudo bash -c $linuxosdir/make_polybar.sh
    fi
    print_in_purple "   • polybar install complete\n\n"
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # Compile and Install jgmenu
  JGMENU=$(which jgmenu 2>/dev/null)
  if [ -z $UPDATE ]; then
    print_in_purple "   • jgmenu install\n\n"
    if [ ! -z "$JGMENU" ]; then print_in_green "   •  jgmenu already installed\n"; else
      sudo bash -c $linuxosdir/make_jgmenu.sh
    fi
    print_in_purple "   • jgmenu install complete\n\n"
  fi
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ -z "$(command -v shodan 2>/dev/null)" ] || [ -z "$(command -v ytmdl 2>/dev/null)" ] || [ -z "$(command -v toot 2>/dev/null)" ] ||
  [ -z "$(command -v castero 2>/dev/null)" ] || [ -z "$(command -v rainbowstream 2>/dev/null)" ]; then
  print_in_purple "\n   • Installing terminal tools\n"
  for PIPTOOLS in git+https://github.com/sixohsix/python-irclib shodan ytmdl toot castero rainbowstream; do
    if "(sudo -vn && sudo -ln)" 2>&1 | grep -v 'may not' >/dev/null; then
      execute \
        "sudo sh -c $PIP install $PIPTOOLS >/dev/null 2>&1" \
        "Installing pip package: $PIPTOOLS"
    else
      execute \
        "sh -c $PIP install --user $PIPTOOLS >/dev/null 2>&1" \
        "Installing pip package: $PIPTOOLS"
    fi
  done
  print_in_purple "   • Installing terminal tools completed\n\n"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Update configs
print_in_purple "\n   • Update configs\n"
for confsetup in $(ls -d $srcdir/config/*); do
  if [ -f "$confsetup/install.sh" ] && [ ! -f "$confsetup/.installed" ]; then
    execute "$confsetup/install.sh" "Finalizing $confsetup setup"
  fi
done

print_in_purple "   • Update configs completed\n\n"

# Install additional
print_in_purple "\n   • Installing additional tools\n"
if [ -f "$(command -v dfmgr 2>/dev/null)" ]; then
  execute "dfmgr install misc"
fi
print_in_purple "   • Installing additional tools completed\n\n"

if [ -n "$DESKTOP_SESSION" ]; then
  case "$DESKTOP_SESSION" in
  awesome) execute "dfmgr install awesome" "Setting up for awesome" ;;
  bspwm) execute "dfmgr install bspwm" "Setting up for bspwm" ;;
  i3 | i3wm) execute "dfmgr install i3" "Setting up for i3" ;;
  qtile) execute "dfmgr install qtile" "Setting up for qtile" ;;
  xfce) execute "dfmgr install xfce" "Setting up for xfce" ;;
  openbox) execute "dfmgr install openbox" "Setting up for openbox" ;;
  xmonad) execute "dfmgr install xmonad" "Setting up for xmonad" ;;
    #jwm) execute "dfmgr install jwm" "Setting up for jwm";;
    #lxde) execute "dfmgr install lxde" "Setting up for lxde";;
    #lxqt) execute "dfmgr install lxqt" "Setting up for lxqt";;
  esac
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Go home
cd "$HOME" || false

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Fix permissions again
find "$HOME" -xtype l -delete
find ~/.gnupg ~/.ssh -type f -exec chmod 600 {} \; 2>/dev/null
find ~/.gnupg ~/.ssh -type d -exec chmod 700 {} \; 2>/dev/null
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create env file
if [ ! -d ~/.config/dotfiles ]; then mkdir -p ~/.config/dotfiles; fi
if [ ! -f ~/.config/dotfiles/env ]; then
  echo "" >~/.config/dotfiles/env
  echo "UPDATE="yes"" >>~/.config/dotfiles/env
  echo "dotfilesDirectory="$dotfilesDirectory"" >>~/.config/dotfiles/env
  echo "srcdir="$dotfilesDirectory/src"" >>~/.config/dotfiles/env
  echo "linuxosdir="$srcdir/os/linux"" >>~/.config/dotfiles/env
  echo "INSTALLEDVER="$NEWVERSION"" >>~/.config/dotfiles/env
  echo "DISTRO="$DISTRO"" >>~/.config/dotfiles/env
  echo "CODENAME="$CODENAME"" >>~/.config/dotfiles/env
  echo "GIT="$GIT"" >>~/.config/dotfiles/env
  echo "CURL="$CURL"" >>~/.config/dotfiles/env
  echo "WGET="$WGET"" >>~/.config/dotfiles/env
  echo "VIM="$VIM"" >>~/.config/dotfiles/env
  echo "TMUX="$TMUX"" >>~/.config/dotfiles/env
  echo "ZSH="$ZSH"" >>~/.config/dotfiles/env
  echo "FISH="$FISH"" >>~/.config/dotfiles/env
  echo "POLYBAR="$POLYBAR"" >>~/.config/dotfiles/env
  echo "JGMENU="$JGMENU"" >>~/.config/dotfiles/env
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#Reconfigure lxdm
#if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' > /dev/null; then
# if [[ "$distroname" =~ "Kali" ]] || [[ "$distroname" =~ "Parrot" ]] || [[ "$distroname" =~ "Debian" ]] || [[ "$distroname" =~ "Raspbian" ]] ||  [[ "$distroname" =~ "Ubuntu" ]] ; then
#sudo dpkg-reconfigure lxdm
# fi
#fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# run clean up
print_in_purple "\n   • Running cleanup\n"

# remove unwanted system files
if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null; then
  for sudocleanfile in /usr/share/xsessions/*-shmlog.desktop; do
    if [ -e "$sudocleanfile" ]; then
      execute \
        "sudo rm -Rf $sudocleanfile" \
        "Clean up cleaning up $sudocleanfile"
    fi
  done
fi

# remove unwanted user temp files
for homecleanfile in "$HOME/.cache/yay"/*; do
  if [ -e "$homecleanfile" ]; then
    execute \
      "rm -Rf $homecleanfile 2>/dev/null" \
      "cleaning up $homecleanfile"
  fi
done

print_in_purple "   • Running cleanup complete\n\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Print installed version
NEWVERSION="$(cat "$DOTFILES/version.txt" | tail -n 1)"
cp -Rf "$DOTFILES/version.txt" "$srcdir/os/version.txt"
# End Install
#RESULT=$?
printf "\n${GREEN}   *** 😃 installation of dotfiles completed 😃 *** ${NC}\n"
printf "${GREEN}   *** 😃 You now have version number: "$NEWVERSION" 😃 *** ${NC}\n\n"
printf "${RED}   *** For the configurations to take effect *** ${NC} \n "
printf "${RED}   *** you should logoff or reboot your system *** ${NC} \n\n\n\n "
##################################################################################################

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
