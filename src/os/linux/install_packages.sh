#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" &&
  . "../utils.sh"

srcdir="$(cd .. && pwd)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ -f "$(command -v apt)" ]; then
  ID="$(grep ID= /etc/os-release | sed 's#ID=##')"
  ID_LIKE="$(grep ID_LIKE= /etc/os-release | sed 's#ID_LIKE=##')"
  if [[ "$ID" =~ Debian ]] && [[ "$ID_LIKE" =~ Debian ]]; then
    sudo cp -Rf $linuxosdir/pkgs/repos/debian/sources.list.d/google-chrome.list /etc/apt/sources.list.d/
    sudo cp -Rf $linuxosdir/pkgs/repos/debian/sources.list.d/opera-stable.list /etc/apt/sources.list.d/
    sudo cp -Rf $linuxosdir/pkgs/repos/debian/sources.list.d/typora.list /etc/apt/sources.list.d/
    sudo cp -Rf $linuxosdir/pkgs/repos/debian/sources.list.d/vscode.list /etc/apt/sources.list.d/
    sudo cp -Rf $linuxosdir/pkgs/repos/debian/sources.list.d/vivaldi.list /etc/apt/sources.list.d/
  fi
  if [[ "$ID" =~ Ubuntu ]] && [[ "$ID_LIKE" =~ Ubuntu ]]; then
    sudo cp -Rf $linuxosdir/pkgs/repos/ubuntu/* /etc/apt/
    sudo sudo sed -i 's#mydebiancodename#${CODENAME}#g' /etc/apt/sources.list
  fi

  # Visual Studio Code
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
  sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'

  # vivaldi web browser
  wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | sudo apt-key add - >/dev/null 2>&1
  echo 'deb https://repo.vivaldi.com/archive/deb/ stable main' | sudo tee /etc/apt/sources.list.d/vivaldi.list >/dev/null 2>&1
  #

  # google chrome browser
  wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add - >/dev/null 2>&1
  echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list >/dev/null 2>&1

  # typora
  wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add - >/dev/null 2>&1
  echo 'deb https://typora.io/linux ./' | sudo tee /etc/apt/sources.list.d/typora.list >/dev/null 2>&1

fi

# Arch linux and derivatives setup
if [[ "$DISTRO" = Arch ]]; then
  printf "${GREEN}  *** • This May take awhile please be patient...${NC}\n"
  printf "${GREEN}  *** • Possibly 20+ Minutes.. So go have a nice cup of coffee!${NC}\n"

  if [[ ! -f /etc/pacman.d/.srcinstall ]] || [ "$1" = "--force" ]; then
    execute \
      "sudo pacman-key --init 2> /dev/null && \
      sudo pacman-key --populate 2> /dev/null && \
      sudo pacman-key --refresh-keys 2> /dev/null &&
      sudo touch /etc/pacman.d/.srckeys" \
      "Initializing pacman keys..... This may take some time"
  fi

  execute \
    "sudo pacman -Syy --noconfirm 2> /dev/null" \
    "Updating the package manager"

  # Lets install main packages
  execute \
    "sudo bash -c $linuxosdir/pkgs/lists/arch-sys.sh 2> /dev/null" \
    "Installing Packages"

  # Now for aur packages
  execute \
    "sudo bash -c $linuxosdir/pkgs/lists/arch-yay.sh 2> /dev/null" \
    "Installing aur Packages"

  ### TODO: Add if statements no point in running if already done

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Debian and derivatives setup - debgen.simplylinux.ch
elif [[ "$DISTRO" = Debian ]]; then
  if [[ "$CODENAME" == "na" ]]; then CODENAME=buster; fi
  printf "\n${PURPLE} • Setting up for $CODENAME${NC}\n\n"
  printf "${GREEN}  *** • This May take awhile please be patient...${NC}\n"
  printf "${GREEN}  *** • Possibly 20+ Minutes.. So go have a nice cup of coffee!${NC}\n"

  if [[ ! -f /etc/apt/.srcinstall ]] || [ "$1" = "--force" ]; then
    execute \
      "sudo $linuxosdir/pkgs/repos/debian_keys.sh 2> /dev/null" \
      "Adding secondary keys"

    execute \
      "sudo touch /etc/apt/.srcinstall" \
      "Adding secondary repos"
  fi

  # - - - - - - - - - - - - - - - - - -
  # Debian functions
  if [[ "$CODENAME" != "kali" ]] && [[ "$CODENAME" != "parrot" ]]; then
    execute \
      "sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null && \
      sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null && \
      sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null" \
      "Updating the package manager"

    execute \
      "sudo bash -c $linuxosdir/pkgs/lists/debian-sys.sh 2> /dev/null" \
      "Installing Packages"

  fi

  # - - - - - - - - - - - - - - - - - -
  # Kali functions
  if [[ "$CODENAME" == "kali" ]]; then
    execute \
      "sudo cp -Rf $linuxosdir/pkgs/repos/debian/sources.list /etc/apt/sources.list && \
      sudo cp -Rf $linuxosdir/pkgs/repos/debian/sources.list.d/kali.list /etc/apt/sources.list.d/ && \
      sudo sed -i 's#mydebiancodename#buster#g' /etc/apt/sources.list" \
      "Adding kali repo"

    execute \
      "sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null && \
      sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null && \
      sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null" \
      "Updating the package manager"

    execute \
      "sudo bash -c $linuxosdir/pkgs/lists/debian-sys.sh 2> /dev/null" \
      "Installing Packages"
  fi

  # - - - - - - - - - - - - - - - - - -
  # Parrot functions
  if [[ "$CODENAME" == "parrot" ]]; then
    execute \
      "sudo cp -Rf $linuxosdir/pkgs/repos/debian/sources.list.d/parrot.list /etc/apt/sources.list && \
      sudo sed -i 's#mydebiancodename#parrot#g' /etc/apt/sources.list" \
      "Adding parrot repo"

    execute \
      "sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null && \
      sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null && \
      sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null" \
      "Updating the package manager"

    execute \
      "sudo bash -c $linuxosdir/pkgs/lists/debian-sys.sh 2> /dev/null" \
      "Installing Packages"
  fi

  ################## End of Debian and derivatives setup

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Ubuntu and derivatives setup - repogen.simplylinux.ch
elif [[ "$DISTRO" = Ubuntu ]]; then
  printf "${PURPLE}\n • Setting up for $CODENAME${NC}\n"
  printf "${GREEN}  *** • This May take awhile please be patient...${NC}\n"
  printf "${GREEN}  *** • Possibly 20+ Minutes.. So go have a nice cup of coffee!${NC}\n"

  if [[ ! -f /etc/apt/.srcinstall ]] || [ "$1" = "--force" ]; then
    execute \
      "sudo bash -c $linuxosdir/pkgs/repos/debian_keys.sh 2> /dev/null && \
      sudo bash -c $linuxosdir/pkgs/repos/ubuntu_keys.sh 2> /dev/null" \
      "Adding secondary keys"

    execute \
      "sudo touch /etc/apt/.srcinstall" \
      "Adding secondary repos"
  fi

  execute \
    "sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null && \
    sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null && \
    sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null" \
    "Updating the package manager"

  execute \
    "sudo bash -c $linuxosdir/pkgs/lists/ubuntu-sys.sh 2> /dev/null" \
    "Installing Packages"

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Raspbian

elif [[ "$DISTRO" = Raspbian ]]; then
  printf "${PURPLE}\n • Setting up for $DISTRO${NC}\n"
  printf "${GREEN}  *** • This May take awhile please be patient...${NC}\n"
  printf "${GREEN}  *** • Possibly 20+ Minutes.. So go have a nice cup of coffee!${NC}\n"

  if [[ ! -f /etc/apt/.srcinstall ]] || [ "$1" = "--force" ]; then
    execute \
      "sudo cp -Rf $linuxosdir/pkgs/repos/raspbian/* /etc/apt/ && \
      sudo touch /etc/apt/.srcinstall" \
      "Setting up repos"
  fi

  execute \
    "sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null && \
        sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null && \
        sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null" \
    "Updating the package manager"

  execute \
    "sudo bash -c $linuxosdir/pkgs/lists/raspbian-sys.sh" \
    "Installing Packages"

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #Redhat and derivatives setup
elif [[ "$DISTRO" = RHEL ]]; then
  printf "${PURPLE}\n • Setting up for $DISTRO${NC}\n"
  printf "${GREEN}  *** • This May take awhile please be patient...${NC}\n"
  printf "${GREEN}  *** • Possibly 20+ Minutes.. So go have a nice cup of coffee!${NC}\n"

  ELRELEASE="$(rpm -q --whatprovides redhat-release --queryformat "%{VERSION}\n" | sed 's/\/.*//' | sed 's/\..*//' | sed 's/Server*//')"

  execute \
    "sudo curl -Ls https://github.com/CasjaysDev/rpm-devel/blob/master/docs/ZREPO/RHEL/rhel/casjay.repo -o /etc/yum.repos.d/casjay.repo && \
    sudo yum makecache" \
    "Adding repos"

  execute \
    "sudo yum install -y -q --skip-broken thefuck powerline fontawesome-fonts fish vim zsh git tmux neofetch 2> /dev/null" \
    "Installing Packages"

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Fedora and derivatives
elif [[ "$DISTRO" = Fedora ]]; then
  printf "${PURPLE}\n • Setting up for $DISTRO${NC}\n"
  printf "${GREEN}  *** • This May take awhile please be patient...${NC}\n"
  printf "${GREEN}  *** • Possibly 20+ Minutes.. So go have a nice cup of coffee!${NC}\n"

  execute \
    "sudo sudo cp -Rf $linuxosdir/pkgs/repos/fedora/* /etc/yum.repos.d/ && \
        sudo yum makecache 2> /dev/null" \
    "Adding yum repos"

  execute \
    "sudo bash -c $linuxosdir/pkgs/lists/fedora-sys.sh 2> /dev/null" \
    "Installing Packages"

fi
