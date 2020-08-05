#!/usr/bin/env bash
APT="DEBIAN_FRONTEND=noninteractive apt-get"
APTOPTS="-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold""
APTINST="--ignore-missing -yy -qq --allow-unauthenticated --assume-yes"

curl -Ls https://ftp-master.debian.org/keys/archive-key-9.asc https://ftp-master.debian.org/keys/archive-key-9-security.asc https://ftp-master.debian.org/keys/archive-key-10.asc https://ftp-master.debian.org/keys/archive-key-10-security.asc | sudo apt-key add - > /dev/null 2>&1
INSTPKGS="apt-utils apt-transport-https debian-archive-keyring debian-keyring bzip2 git curl wget net-tools rpimonitor uptimed downtimed mailutils ntp gnupg cron openssh-server cowsay fortune-mod figlet geany fonts-hack-ttf fonts-hack-otf fonts-hack-web tmux neofetch vim-nox powerline fonts-powerline fish zsh nodejs npm"

for i in $INSTPKGS; do
  sudo $APT $APTOPTS $APTINST install $i < /dev/null >/dev/null 2>&1
done
sudo $APT $APTOPTS $APTINST install -f >/dev/null 2>&1
sudo dpkg --configure -a >/dev/null 2>&1
sudo touch /etc/apt/.srckeys
