#!/usr/bin/env bash

# // TODO: Add the ability to specify custom git repo

# Detect the platform (similar to $OSTYPE)
OS="`uname`"
case $OS in
  'Linux')
    OS='Linux'
    if [ -z $UPDATE ]; then
    echo "Detected os is $OS"
    echo "Running the installer" && sleep 3 && bash -c "$(curl -LsS https://github.com/casjay-systems/linux/raw/master/src/os/linux_setup.sh)"
    else
    echo "Detected os is $OS"
    echo "Running the Updater" && sleep 3 && UPDATE=yes bash -c "$(curl -LsS https://github.com/casjay-systems/linux/raw/master/src/os/linux_setup.sh)"
    fi
    ;;
  'Darwin')
    OS='Mac'
    if [ -z $UPDATE ]; then
    echo "Detected os is $OS"
    echo "Running the installer" && sleep 3 && bash -c "$(curl -LsS https://github.com/casjay-systems/macos/raw/master/src/os/mac_setup.sh)"
    else
    echo "Detected os is $OS"
    echo "Running the Updater" && sleep 3 && UPDATE=yes bash -c "$(curl -LsS https://github.com/casjay-systems/macos/raw/master/src/os/mac_setup.sh)"
    fi
    ;;
  'WindowsNT')
    OS='Windows'
    powershell.exe -Command Invoke-WebRequest https://github.com/casjay-systems/windows/raw/master/install.cmd -o  %USERPROFILE%\Downloads\install.cmd
    %USERPROFILE%\Downloads\install.cmd
    ;;
  'FreeBSD')
    OS='FreeBSD'
    echo "Not Supported"
    ;;
  'SunOS')
    OS='Solaris'
    echo "Not Supported"
    ;;
  'MING*')
    OS='Windows'
    echo "Not Supported"
    ;;
  'AIX') ;;
  *)
  echo "Unknown"
  ;;
esac
