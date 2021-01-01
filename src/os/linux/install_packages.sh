#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" &&
  . "../utils.sh"

srcdir="$(cd .. && pwd)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Arch linux and derivatives setup
if [[ "$DISTRO" = Arch ]]; then
  printf "\n${PURPLE} • Setting up for $DISTRO${NC}\n\n"
  if [[ ! -f /etc/pacman.d/.srcinstall ]]; then
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
    "Installing Packages.... This May take awhile please be patient... Possibly 20+ Minutes"

  # Now for aur packages
  execute \
    "sudo bash -c $linuxosdir/pkgs/lists/arch-yay.sh 2> /dev/null" \
    "Installing aur Packages.... This May take awhile please be patient... Possibly 20+ Minutes"

  ### TODO: Add if statements no point in running if already done

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Debian and derivatives setup - debgen.simplylinux.ch
elif [[ "$DISTRO" = Debian ]]; then
  if [[ "$CODENAME" == "na" ]]; then CODENAME=buster; fi
  printf "\n${PURPLE} • Setting up for $CODENAME${NC}\n\n"
  if [[ ! -f /etc/apt/.srcinstall ]]; then
    execute \
      "sudo $linuxosdir/pkgs/repos/debian_keys.sh 2> /dev/null" \
      "Adding secondary keys"

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
    execute \
      "sudo cp -Rf $linuxosdir/pkgs/repos/debian/sources.list /etc/apt/sources.list && \
      sudo sed -i 's#mydebiancodename#${CODENAME}#g' /etc/apt/sources.list && \
      sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null && \
      sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null && \
      sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null" \
      "Updating the package manager"

    execute \
      "sudo bash -c $linuxosdir/pkgs/lists/debian-sys.sh 2> /dev/null" \
      "Installing Packages.... This May take awhile please be patient... Possibly 20+ Minutes"

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
      "Installing Packages.... This May take awhile please be patient... Possibly 20+ Minutes"
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
      "Installing Packages.... This May take awhile please be patient... Possibly 20+ Minutes"
  fi

  ################## End of Debian and derivatives setup

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Ubuntu and derivatives setup - repogen.simplylinux.ch
elif [[ "$DISTRO" = Ubuntu ]]; then
  printf "${PURPLE}\n • Setting up for $CODENAME${NC}\n\n"
  if [[ ! -f /etc/apt/.srcinstall ]]; then
    execute \
      "sudo bash -c $linuxosdir/pkgs/repos/debian_keys.sh 2> /dev/null && \
      sudo bash -c $linuxosdir/pkgs/repos/ubuntu_keys.sh 2> /dev/null" \
      "Adding secondary keys"

    execute \
      "sudo cp -Rf $linuxosdir/pkgs/repos/ubuntu/* /etc/apt/ && \
      sudo sudo sed -i 's#mydebiancodename#${CODENAME}#g' /etc/apt/sources.list &&
      sudo touch /etc/apt/.srcinstall" \
      "Adding secondary repos"
  fi

  execute \
    "sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null && \
        sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null && \
        sudo DEBIAN_FRONTEND=noninteractive apt-get -yy -qq --ignore-missing update 2> /dev/null" \
    "Updating the package manager"

  execute \
    "sudo bash -c $linuxosdir/pkgs/lists/ubuntu-sys.sh 2> /dev/null" \
    "Installing Packages.... This May take awhile please be patient... Possibly 20+ Minutes"

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Raspbian

elif [[ "$DISTRO" = Raspbian ]]; then
  printf "${PURPLE}\n • Setting up for $DISTRO${NC}\n\n"
  if [[ ! -f /etc/apt/.srcinstall ]]; then
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
    "Installing Packages.... This May take awhile please be patient... Possibly 20+ Minutes"

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #Redhat and derivatives setup
elif [[ "$DISTRO" = RHEL ]]; then
  printf "${PURPLE}\n • Setting up for $DISTRO${NC}\n\n"
  ELRELEASE="$(rpm -q --whatprovides redhat-release --queryformat "%{VERSION}\n" | sed 's/\/.*//' | sed 's/\..*//' | sed 's/Server*//')"

  execute \
    "sudo curl -Ls https://github.com/CasjaysDev/rpm-devel/blob/master/docs/ZREPO/RHEL/rhel/casjay.repo -o /etc/yum.repos.d/casjay.repo && \
        sudo yum makecache" \
    "Adding repos"

  execute \
    "sudo yum install -y -q --skip-broken thefuck powerline fontawesome-fonts fish vim zsh git tmux neofetch 2> /dev/null" \
    "Installing Packages.... This May take awhile please be patient... Possibly 20+ Minutes"

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Fedora and derivatives
elif [[ "$DISTRO" = Fedora ]]; then
  printf "${PURPLE}\n • Setting up for $DISTRO${NC}\n\n"
  execute \
    "sudo sudo cp -Rf $linuxosdir/pkgs/repos/fedora/* /etc/yum.repos.d/ && \
        sudo yum makecache 2> /dev/null" \
    "Adding yum repos"

  execute \
    "sudo bash -c $linuxosdir/pkgs/lists/fedora-sys.sh 2> /dev/null" \
    "Installing Packages.... This May take awhile please be patient... Possibly 20+ Minutes"

fi

printf "${PURPLE}\n • Done Setting up for $DISTRO${NC}\n\n"
