#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#Set OS Detection
arch=$(uname -m)
kernel=$(uname -r)
if [ -n "$(command -v lsb_release)" ]; then
    distroname=$(lsb_release -s -d)
    
 elif [ -f "/etc/os-release" ]; then
    distroname=$(grep PRETTY_NAME /etc/os-release | sed 's/PRETTY_NAME=//g' | tr -d '="')

 elif [ -f "/etc/debian_version" ]; then
    distroname="Debian $(cat /etc/debian_version)"

 elif [ -f "/etc/redhat-release" ]; then
    distroname=$(cat /etc/redhat-release)

else
    distroname="$(uname -s) $(uname -r)"
    
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#Various Arch Distros
if [[ "$distroname" =~ "ArcoLinux" ]] || [[ "$distroname" =~ "Arch" ]] || [[ "$distroname" =~ "BlackArch" ]]; then
  DISTRO=Arch

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#Raspberry pi
elif [[ "$distroname" =~ "Raspbian" ]]; then
  DISTRO=Raspbian

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#Various RedHat Distros
elif [[ "$distroname" =~ "Scientific" ]] || [[ "$distroname" =~ "RedHat" ]] || [[ "$distroname" =~ "CentOS" ]] || [[ "$distroname" =~ "Casjay" ]]; then
  DISTRO=RHEL

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#Various Debian Distros
elif [[ "$distroname" =~ "Kali" ]] || [[ "$distroname" =~ "Parrot" ]] || [[ "$distroname" =~ "Debian" ]]; then
  DISTRO=Debian

 if [[ "$distroname" =~ "Debian" ]]; then
  CODENAME=$(lsb_release -a 2> /dev/null| grep Code | sed 's#Codename:##g' | awk '{print $1}')
 fi

#Kali
 if [[ "$distroname" =~ "Kali" ]]; then
  CODENAME=kali
 fi

#ParrotSec
 if [[ "$distroname" =~ "Parrot" ]]; then
  CODENAME=parrot
 fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#Various Ubuntu Distros
elif [[ "$distroname" =~ "Ubuntu" ]] || [[ "$distroname" =~ "Mint" ]] || [[ "$distroname" =~ "Elementary" ]] || [[ "$distroname" =~ "KDE neon" ]]; then
  DISTRO=Ubuntu
  CODENAME=$(lsb_release -a 2> /dev/null| grep Code | sed 's#Codename:##g' | awk '{print $1}')

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Fedora
elif [[ "$distroname" =~ "Fedora" ]]; then
  DISTRO=Fedora

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##
fi
