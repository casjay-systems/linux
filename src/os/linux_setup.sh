#!/usr/bin/env bash
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
DOTFILES="$HOME/.local/dotfiles/desktop"

##################################################################################################

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
# Define colors
PURPLE='\033[0;35m'
BLUE='\033[0;34m'
RED='\033[0;31m'
GREEN='\033[32m'
NC='\033[0m'
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ -f ~/.config/dotfiles/env ]; then
   source ~/.config/dotfiles/env
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Automatic linux install

####################################################################################################
clear                                                                                              #
printf "\n\n\n\n\n   ${BLUE}      *** Initializing the installer please wait *** ${NC} \n\n\n\n "  #
####################################################################################################
# Remove previous installs
if [ -d $DOTFILES.git ]; then cd $DOTFILES && git pull ; else rm -Rf $DOTFILES; fi
if [ -d $HOME/.config/bash/profile ]; then rm -Rf $HOME/.config/bash/profile/zz-*; fi
if [ -d $HOME/.config/bash/profile ]; then rm -Rf $HOME/.config/bash/profile/00-*; fi
if [ -d $HOME/.config/bash/profile ]; then rm -Rf $HOME/.config/bash/profile/*.win; fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -z $UPDATE ]; then
  if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' > /dev/null; then
#Define the package manager and install option
   if [ -f /usr/bin/apt ]; then
    LSBPAC=lsb-release
    pkgmgr="DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" --ignore-missing --allow-unauthenticated --assume-yes"
    instoption="-yy -qq install"
    instupdateoption="update && sudo $pkgmgr dist-upgrade -yy -qq"
    instchkupdatecmd="$(sudo apt-get update > /dev/null && apt-get --just-print upgrade | grep "Inst " | wc -l)"
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
    instchkupdatecmd="$(checkupdates 2> /dev/null | wc -l)"
   fi

if [[ "$instchkupdatecmd" != 0 ]]; then
    printf "\n${RED}  *** Please update your system before runng this installer ***${NC}\n"
    printf "\n${RED}  *** You have $instchkupdatecmd update available ***${NC}\n\n\n\n"
    exit 1
   fi
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Welcome message

clear

wait_time=10 # seconds
temp_cnt=${wait_time}
    printf "\n\n\n\n\n${GREEN}         *** ${RED}•${GREEN} Welcome to my dotfiles Installer for linux ${RED}•${GREEN} ***${NC}\n"
while [[ ${temp_cnt} -gt 0 ]];
do
    printf "\r  ${GREEN}*** ${RED}•${GREEN} You have %2d second(s) remaining to hit Ctrl+C to cancel ${RED}•${GREEN} ***" ${temp_cnt}
    sleep 1
    ((temp_cnt--))
done
printf "${NC}\n\n"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Dependency check

dotfilesDirectory="$DOTFILES"
srcdir="$dotfilesDirectory/src"
linuxosdir="$srcdir/os/linux"

##### for when I'm forgetful
if [ -z $dotfilesDirectory ]; then printf "\n${RED}  *** dotfiles directory not specified ***${NC}\n"; fi
if [ -z $srcdir ]; then printf "\n${RED}  *** dotfiles src directory not specified ***${NC}\n"; fi
if [ -z $linuxosdir ]; then printf "\n${RED}  *** dotfiles linuxos directory not specified ***${NC}\n"; fi
#####
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

GIT=$(which git 2>/dev/null)
CURL=$(which curl 2>/dev/null)
WGET=$(which wget 2>/dev/null)
VIM=$(which vim 2>/dev/null)
TMUX=$(which tmux 2>/dev/null)
ZSH=$(which zsh 2>/dev/null)
FISH=$(which fish 2>/dev/null)
SUDO=$(which sudo 2>/dev/null)
LSBR=$(which lsb_release 2>/dev/null)
POLYBAR=$(which polybar 2> /dev/null)
JGMENU=$(which jgmenu 2>/dev/null)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# no sudo can't continue
SUDU=$(which sudo 2>/dev/null)
if ! (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' > /dev/null; then
 if [[ -z "$SUDU" ]] && [[ -z "$UPDATE" ]]; then
   printf "\n${GREEN} *** ${RED}•${GREEN} UPDATE=yes bash -c "$(curl -LsS https://$GITREPO/raw/master/src/os/setup.sh)" ${RED}•${GREEN} ***${NC}\n"
   printf "\n${GREEN}  *** ${RED}•${GREEN} to install just the dotfiles ${RED}•${GREEN} ***${NC}\n"
   printf "\n${RED}  *** ${RED}•${GREEN} No sudo or root privileges ${RED}•${GREEN} ***${NC}\n\n"
  exit
 fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -z "$UPDATE" ]; then
 if ! (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' > /dev/null && [ -z "$POLYBAR" ]; then
  printf "
  ${RED}\n • Please run one of the following commands as root:${NC}
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
 if [[ ! "$GIT" ]]; then MISSING="$MISSING git" ; fi
 if [[ ! "$CURL" ]]; then MISSING="$MISSING curl" ; fi
 if [[ ! "$WGET" ]]; then MISSING="$MISSING wget" ; fi
 if [[ ! "$VIM" ]]; then MISSING="$MISSING vim" ; fi
 if [[ ! "$TMUX" ]]; then MISSING="$MISSING tmux" ; fi
 if [[ ! "$ZSH" ]]; then MISSING="$MISSING zsh" ; fi
 if [[ ! "$FISH" ]]; then MISSING="$MISSING fish" ; fi
 if [[ ! "$SUDO" ]]; then MISSING="$MISSING sudo" ; fi
 if [[ ! "$LSBR" ]]; then MISSING="$MISSING $LSBPAC" ; fi

if [ -z "$LSBR" ] || [ -z "$GIT" ] || [ -z "$CURL" ] || [ -z "$WGET" ] || [ -z "$VIM" ] || [ -z "$TMUX" ] || [ -z "$ZSH" ] || [ -z "$FISH" ] || [ -z "$SUDO" ]; then
 printf "\n${RED}  *** • The following are needed: • ***${NC}\n"
 printf "\n${RED}  *** • ${MISSING} • ***${NC}\n"
 printf "\n${RED}  *** • Attempting to install the missing package[s] • ***${NC}\n\n"
if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' > /dev/null; then
    sudo $pkgmgr $instoption ${MISSING} >/dev/null 2>&1
else
    printf "${RED}  *** • I can't get root access You will have to manually install the missing programs • ***${NC}\n"
    printf "${RED}  *** • ${MISSING} • ***${NC}\n\n\n"
    exit
 fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Grab the OS detection script if it doesn't exist script

if [ -f $srcdir/os/osdetect.sh ]; then
    source $srcdir/os/osdetect.sh
else
    curl -Lsq https://$GITREPO/raw/master/src/os/osdetect.sh -o /tmp/osdetect.sh
    source /tmp/osdetect.sh
    rm -Rf /tmp/osdetect.sh
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set version from git

CURDOTFVERSION="$(echo $(curl -Lsq https://$GITREPO/raw/master/src/os/version.txt |grep -v "#" | tail -n 1))"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Print distro info

printf "\n\n${PURPLE}  *** • Your Distro is $distroname and is based on $DISTRO • ***${NC}\n\n"
printf "${GREEN}  *** • git, curl, wget, vim, tmux, zsh, fish, sudo are present • ***${NC}\n\n"
printf "${GREEN}  *** • Installing version $CURDOTFVERSION • ***${NC}\n\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup the dotfiles Directory

if [ -d  $dotfilesDirectory/.git ]; then
    printf "\n${PURPLE} • Updating the git repo - $dotfilesDirectory${NC}\n\n"
cd "$srcdir/os" && source "utils.sh"

  echo ""
 execute \
 "cd $dotfilesDirectory && \
  git pull --recursive -q && \
  cd ~" \
  "Updating dotfiles"
 NEWVERSION="$(echo $(cat $srcdir/os/version.txt | tail -n 1))"
 REVER="$(cd $dotfilesDirectory && git rev-parse --short HEAD)"
 printf "${GREEN}   [✔] Updated to $NEWVERSION - revision: $REVER${NC}\n\n"

else

 printf "\n${PURPLE} • Cloning the git repo - $dotfilesDirectory${NC}\n"
 rm -Rf $dotfilesDirectory
 git clone --recursive -q $GITURL $dotfilesDirectory > /dev/null 2>&1
 printf "\n${GREEN}   [✔] clone $GITURL  → $dotfilesDirectory \n"
 NEWVERSION="$(echo $(cat $srcdir/os/version.txt | tail -n 1))"
 REVER="$(cd $dotfilesDirectory && git rev-parse --short HEAD)"
 printf "${GREEN}   [✔] downloaded version $NEWVERSION - revision: $REVER${NC}\n\n"
 cd "$srcdir/os" && source "utils.sh"
fi

# grab the modules

for config in awesome bash geany git gtk-2.0 gtk-3.0 htop i3 neofetch nitrogen openbox qtile \
remmina smplayer smtube terminology termite Thunar transmission variety vifm xfce4 xmonad zsh
do git clone -q https://github.com/casjay-dotfiles/$config $dotfilesDirectory/src/config/$config
done

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Make Directories and fix permissions

mkdir -p ~/.gnupg ~/.ssh 2> /dev/null
find "$HOME" -xtype l -delete 2> /dev/null
find ~/.gnupg ~/.ssh -type f -exec chmod 600 {} \; 2> /dev/null
find ~/.gnupg ~/.ssh -type d -exec chmod 700 {} \; 2> /dev/null
find $dotfilesDirectory/ -iname "*.sh" -exec chmod 755 {} \; 2> /dev/null

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Check for then get root permissions
if [ -z $UPDATE ]; then
 if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' > /dev/null; then
 printf "\n${RED} • Getting root privileges${NC}\n\n"
 ask_for_sudo
 printf "\n${GREEN} • Received root privileges${NC}\n\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Install Packages
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Arch linux and derivatives setup
  if [[ "$DISTRO" = Arch ]]; then
  printf "\n${PURPLE} • Setting up for $DISTRO${NC}\n\n"
if [[ ! -f  /etc/pacman.d/.srcinstall ]]; then
  echo ""
      execute \
      "sudo pacman-key --init 2> /dev/null && \
       sudo pacman-key --populate 2> /dev/null && \
       sudo pacman-key --refresh-keys 2> /dev/null &&
       sudo touch /etc/pacman.d/.srckeys" \
      "Initializing pacman keys..... This may take some time"
fi

  echo ""
      execute \
      "sudo pacman -Syy --noconfirm 2> /dev/null" \
      "Updating the package manager"

# Lets install main packages
  echo ""
      execute \
      "sudo bash -c $linuxosdir/pkgs/lists/arch-sys.sh 2> /dev/null" \
      "Installing Packages.... This May take awhile please be patient... Possibly 20+ Minutes"

  echo ""

# Now for aur packages
      execute \
      "sudo bash -c $linuxosdir/pkgs/lists/arch-yay.sh 2> /dev/null" \
      "Installing aur Packages.... This May take awhile please be patient... Possibly 20+ Minutes"

# BlackArch Setup
#      execute \
#      "curl  https://blackarch.org/strap.sh -O /tmp/blackarch.sh && \
#       chmod +x /tmp/blackarch.sh && \
#       sudo /tmp/blackarch.sh && \
#       sudo pacman-key --init && \
#       sudo pacman-key --populate && \
#       sudo pacman-key --refresh-keys" \
#       "Setting up backarch"

### TODO
# Add if statements no point in running if already done
###

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Debian and derivatives setup - debgen.simplylinux.ch
  elif [[ "$DISTRO" = Debian ]]; then
   if [[ "$CODENAME" == "na" ]]; then CODENAME=buster ; fi
  printf "\n${PURPLE} • Setting up for $CODENAME${NC}\n\n"
if [[ ! -f  /etc/apt/.srcinstall ]]; then
  echo ""
      execute \
      "sudo $linuxosdir/pkgs/repos/debian_keys.sh 2> /dev/null" \
      "Adding secondary keys"

  echo ""
      execute \
      "sudo cp -Rf $linuxosdir/pkgs/repos/debian/sources.list.d/google-chrome.list /etc/apt/sources.list.d/ && \
       sudo cp -Rf $linuxosdir/pkgs/repos/debian/sources.list.d/opera-stable.list /etc/apt/sources.list.d/ && \
       sudo cp -Rf $linuxosdir/pkgs/repos/debian/sources.list.d/typora.list /etc/apt/sources.list.d/ && \
       sudo cp -Rf $linuxosdir/pkgs/repos/debian/sources.list.d/vscode.list /etc/apt/sources.list.d/ && \
       sudo cp -Rf $linuxosdir/pkgs/repos/debian/sources.list.d/vivaldi.list /etc/apt/sources.list.d/ && \
       sudo touch /etc/apt/.srcinstall" \
      "Adding secondary repos"
fi

# - - - - - - - - - - - - - - - - - -
# Debian functions
   if [[ "$CODENAME" != "kali" ]] && [[ "$CODENAME" != "parrot" ]]; then
  echo ""
      execute \
      "sudo cp -Rf $linuxosdir/pkgs/repos/debian/sources.list /etc/apt/sources.list && \
       sudo sed -i "s#mydebiancodename#${CODENAME}#g" /etc/apt/sources.list && \
       sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null && \
       sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null && \
       sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null" \
      "Updating the package manager"

  echo ""
      execute \
      "sudo bash -c $linuxosdir/pkgs/lists/debian-sys.sh 2> /dev/null" \
      "Installing Packages.... This May take awhile please be patient... Possibly 20+ Minutes"

   fi

# - - - - - - - - - - - - - - - - - -
# Kali functions
   if [[ "$CODENAME" == "kali" ]]; then
  echo ""
       execute \
      "sudo cp -Rf $linuxosdir/pkgs/repos/debian/sources.list /etc/apt/sources.list && \
       sudo cp -Rf $linuxosdir/pkgs/repos/debian/sources.list.d/kali.list /etc/apt/sources.list.d/ && \
       sudo sed -i "s#mydebiancodename#buster#g" /etc/apt/sources.list" \
      "Adding kali repo"

  echo ""
       execute \
      "sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null && \
       sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null && \
       sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null" \
      "Updating the package manager"

  echo ""
       execute \
      "sudo bash -c $linuxosdir/pkgs/lists/debian-sys.sh 2> /dev/null" \
      "Installing Packages.... This May take awhile please be patient... Possibly 20+ Minutes"
   fi

# - - - - - - - - - - - - - - - - - -
# Parrot functions
   if [[ "$CODENAME" == "parrot" ]]; then
  echo ""
      execute \
      "sudo cp -Rf $linuxosdir/pkgs/repos/debian/sources.list.d/parrot.list /etc/apt/sources.list && \
       sudo sed -i "s#mydebiancodename#parrot#g" /etc/apt/sources.list" \
      "Adding parrot repo"

  echo ""
       execute \
      "sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null && \
       sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null && \
       sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null" \
      "Updating the package manager"

  echo ""
       execute \
      "sudo bash -c $linuxosdir/pkgs/lists/debian-sys.sh 2> /dev/null" \
      "Installing Packages.... This May take awhile please be patient... Possibly 20+ Minutes"
   fi

################## End of Debian and derivatives setup

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ubuntu and derivatives setup - repogen.simplylinux.ch
  elif [[ "$DISTRO" = Ubuntu ]]; then
  printf "${PURPLE}\n • Setting up for $CODENAME${NC}\n\n"
if [[ ! -f  /etc/apt/.srcinstall ]]; then
  echo ""
      execute \
      "sudo bash -c $linuxosdir/pkgs/repos/debian_keys.sh 2> /dev/null && \
       sudo bash -c $linuxosdir/pkgs/repos/ubuntu_keys.sh 2> /dev/null" \
      "Adding secondary keys"

  echo ""
      execute \
      "sudo cp -Rf $linuxosdir/pkgs/repos/ubuntu/* /etc/apt/ && \
       sudo sudo sed -i "s#mydebiancodename#${CODENAME}#g" /etc/apt/sources.list &&
       sudo touch /etc/apt/.srcinstall" \
       "Adding secondary repos"
fi

  echo ""
      execute \
      "sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null && \
       sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null && \
       sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null" \
      "Updating the package manager"

  echo ""
      execute \
      "sudo bash -c $linuxosdir/pkgs/lists/ubuntu-sys.sh 2> /dev/null" \
      "Installing Packages.... This May take awhile please be patient... Possibly 20+ Minutes"

 # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # Raspbian

  elif [[ "$DISTRO" = Raspbian ]]; then
  printf "${PURPLE}\n • Setting up for $DISTRO${NC}\n\n"
if [[ ! -f  /etc/apt/.srcinstall ]]; then
  echo ""
      execute \
      "sudo cp -Rf $linuxosdir/pkgs/repos/raspbian/* /etc/apt/ && \
       sudo touch /etc/apt/.srcinstall" \
      "Setting up repos"
fi

  echo ""
      execute \
      "sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null && \
       sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null && \
       sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null" \
      "Updating the package manager"

  echo ""
      execute \
      "sudo bash -c $linuxosdir/pkgs/lists/raspbian-sys.sh" \
      "Installing Packages.... This May take awhile please be patient... Possibly 20+ Minutes"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Redhat and derivatives setup
 elif [[ "$DISTRO" = RHEL ]]; then
 printf "${PURPLE}\n • Setting up for $DISTRO${NC}\n\n"
 ELRELEASE="$(rpm -q --whatprovides redhat-release --queryformat "%{VERSION}\n" | sed 's/\/.*//' | sed 's/\..*//' | sed 's/Server*//')"

  echo ""
      execute \
      "sudo curl -Ls https://github.com/CasjaysDev/rpm-devel/blob/master/docs/ZREPO/RHEL/rhel/casjay.repo -o /etc/yum.repos.d/casjay.repo && \
       sudo yum makecache" \
      "Adding repos"

  echo ""
      execute \
      "sudo yum install -y -q --skip-broken thefuck powerline fontawesome-fonts fish vim zsh git tmux neofetch 2> /dev/null" \
      "Installing Packages.... This May take awhile please be patient... Possibly 20+ Minutes"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Fedora and derivatives
 elif [[ "$DISTRO" = Fedora ]]; then
 printf "${PURPLE}\n • Setting up for $DISTRO${NC}\n\n"
  echo ""
      execute \
      "sudo sudo cp -Rf $linuxosdir/pkgs/repos/fedora/* /etc/yum.repos.d/ && \
       sudo yum makecache 2> /dev/null" \
      "Adding yum repos"

  echo ""
      execute \
      "sudo bash -c $linuxosdir/pkgs/lists/fedora-sys.sh 2> /dev/null" \
      "Installing Packages.... This May take awhile please be patient... Possibly 20+ Minutes"

  fi
   printf "${PURPLE}\n • Done Setting up for $DISTRO${NC}\n\n"
 fi
fi

###################################################################
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Install additional system files if root
if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' > /dev/null; then
print_in_purple "\n • Installing system files\n\n"
 sudo bash -c $linuxosdir/install_system_files.sh
print_in_purple "\n • Installing system files completed\n\n"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create user directories
print_in_purple "\n • Creating directories\n"
 bash -c $linuxosdir/create_directories.sh
print_in_purple "\n • Creating directories completed\n\n"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create user .local files
print_in_purple "\n • Create local config files\n\n"
 bash -c $linuxosdir/create_local_config_files.sh
print_in_purple "\n • Create local config files completed\n\n"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create user dotfile symlinks
print_in_purple "\n • Create user files\n\n"
 bash -c $linuxosdir/create_symbolic_links.sh
print_in_purple "\n • Create user files completed\n\n"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create user themes/fonts/icons or install to system if root
print_in_purple "\n • Installing Customizations\n\n"
 bash -c $linuxosdir/install_customizations.sh
print_in_purple "\n • Installing Customizations completed\n\n"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create and Setup git
GIT=$(which git 2>/dev/null)
if [ -z "$GIT" ]; then print_in_red "\n • The git package is not installed\n\n" ; else
print_in_purple "\n • Installing GIT\n\n"
 bash -c $linuxosdir/install_git.sh
print_in_purple "\n • Installing GIT completed\n\n"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create and Setup vim
VIM=$(which vim 2>/dev/null)
if [ -z "$VIM" ]; then print_in_red "\n • The vim package is not installed\n\n" ; else
print_in_purple "\n • Installing vim with plugins\n\n"
 bash -c $linuxosdir/install_vim.sh
print_in_purple "\n • Installing vim with plugins completed\n\n"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create and Setup tmux
TMUX=$(which tmux 2>/dev/null)
if [ -z "$TMUX" ]; then print_in_red "\n • The tmux package is not installed\n\n" ; else
print_in_purple "\n • Installing tmux plugins\n\n"
 bash -c $linuxosdir/install_tmux.sh
print_in_purple "\n • Installing tmux plugins completed\n\n"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create and Setup zsh
ZSH=$(which zsh 2>/dev/null)
if [ -z "$ZSH" ]; then print_in_red "\n • The zsh package is not installed\n\n" ; else
print_in_purple "\n • Installing zsh with plugins\n\n"
 bash -c $linuxosdir/install_ohmyzsh.sh
print_in_purple "\n • Installing zsh with plugins completed\n\n"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create and Setup fish
FISH=$(which fish 2>/dev/null)
if [ -z "$FISH" ]; then print_in_red "\n • The fish package is not installed\n\n" ; else
print_in_purple "\n • Installing fish shell and plugins\n\n"
 bash -c $linuxosdir/install_ohmyfish.sh
print_in_purple "\n • Installing fish shell and plugins completed\n\n"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Install additional system files if root
##
##
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#No point in running if no desktop
if [ ! -z $DESKTOP_SESSION ]; then
# Compile and Install polybar
POLYBAR=$(which polybar 2> /dev/null)
 if [ -z $UPDATE ]; then
 print_in_purple "\n • polybar install\n\n"
  if [ ! -z "$POLYBAR" ]; then print_in_green "    •  polybar already installed\n" ; else
  sudo bash -c $linuxosdir/make_polybar.sh
  fi
 print_in_purple "\n • polybar install complete\n\n"
 fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Compile and Install jgmenu
JGMENU=$(which jgmenu 2>/dev/null)
 if [ -z $UPDATE ]; then
 print_in_purple "\n • jgmenu install\n\n"
  if [ ! -z "$JGMENU" ]; then print_in_green "    •  jgmenu already installed\n" ; else
  sudo bash -c $linuxosdir/make_jgmenu.sh
  fi
 print_in_purple "\n • jgmenu install complete\n\n"
 fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -n "$(which rainbowstream 2>/dev/null)" ] ||  [ -n "$(which toot 2>/dev/null)" ] || [ -n "$(which castero 2>/dev/null)" ]; then
 if "(sudo -vn && sudo -ln)" 2>&1 | grep -v 'may not' > /dev/null; then
 print_in_purple "\n • terminal tools install\n\n"
   sudo sh -c ""$PIP" install shodan ytmdl toot castero rainbowstream git+https://github.com/sixohsix/python-irclib >/dev/null 2>&1"
  else
   sh -c ""$PIP" install --user shodan ytmdl toot castero rainbowstream git+https://github.com/sixohsix/python-irclib >/dev/null 2>&1"
 print_in_purple "\n • terminal tools install complete\n\n"
 fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Go home
cd $HOME
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Fix permissions again
find "$HOME" -xtype l -delete
find ~/.gnupg ~/.ssh -type f -exec chmod 600 {} \; 2> /dev/null
find ~/.gnupg ~/.ssh -type d -exec chmod 700 {} \; 2> /dev/null
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create env file
if [ ! -d ~/.config/dotfiles ];then mkdir -p ~/.config/dotfiles ; fi
if [ ! -f ~/.config/dotfiles/env ]; then
echo "" > ~/.config/dotfiles/env
echo "UPDATE="yes"" >> ~/.config/dotfiles/env
echo "dotfilesDirectory="$dotfilesDirectory"" >> ~/.config/dotfiles/env
echo "srcdir="$dotfilesDirectory/src"" >> ~/.config/dotfiles/env
echo "linuxosdir="$srcdir/os/linux"" >> ~/.config/dotfiles/env
echo "INSTALLEDVER="$NEWVERSION"" >> ~/.config/dotfiles/env
echo "DISTRO="$DISTRO"" >> ~/.config/dotfiles/env
echo "CODENAME="$CODENAME"" >> ~/.config/dotfiles/env
echo "GIT="$GIT"" >> ~/.config/dotfiles/env
echo "CURL="$CURL"" >> ~/.config/dotfiles/env
echo "WGET="$WGET"" >> ~/.config/dotfiles/env
echo "VIM="$VIM"" >> ~/.config/dotfiles/env
echo "TMUX="$TMUX"" >> ~/.config/dotfiles/env
echo "ZSH="$ZSH"" >> ~/.config/dotfiles/env
echo "FISH="$FISH"" >> ~/.config/dotfiles/env
echo "POLYBAR="$POLYBAR"" >> ~/.config/dotfiles/env
echo "JGMENU="$JGMENU"" >> ~/.config/dotfiles/env
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
print_in_purple "\n • Running cleanup\n\n"

if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' > /dev/null; then
echo ""
    execute \
    "sudo rm -Rf /usr/share/xsessions/*-shmlog.desktop" \
    "Clean up"
fi

# remove arch aur cache
rm -Rf ~/.cache/yay 2> /dev/null

print_in_purple "\n • Running cleanup complete\n\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Print installed version
NEWVERSION="$(echo $(cat $srcdir/os/version.txt | tail -n 1))"
# End Install
#RESULT=$?
 printf "\n${GREEN}       *** 😃 installation of dotfiles completed 😃 *** ${NC}\n"
 printf "${GREEN}  *** 😃 You now have version number: "$NEWVERSION" 😃 *** ${NC}\n\n"
 printf "\n   ${RED}  *** For the configurations to take effect *** ${NC} \n "
 printf "\n   ${RED}   *** you should logoff or reboot your system *** ${NC} \n\n\n\n "
##################################################################################################

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

