#!/usr/bin/env bash
#===============================================================================
#
#          FILE: install_from_src.sh
#
#         USAGE: ./install_from_src.sh
#
#   DESCRIPTION: install from source
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Casjays Devwlopments (),
#  ORGANIZATION:
#       CREATED: 11/13/2019 21:07
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

if [ -f /usr/bin/apt ]
sudo apt install -y build-essential
sudo apt-get install -y git g++ libgtk-3-dev gtk-doc-tools gnutls-bin valac intltool libpcre2-dev libglib3.0-cil-dev libgnutls-dev libgirepository1.0-dev libxml2-utils gperf libtool
fi

cd ~
git clone https://github.com/thestinger/vte-ng.git /tmp/vte-ng
echo export LIBRARY_PATH="/usr/include/gtk-3.0:$LIBRARY_PATH"
cd /tmp/vte-ng
git checkout 0.56.2.a
sudo make && sudo make install
git clone --recursive https://github.com/thestinger/termite.git /tmp/termite
cd /tmp/termite
sudo make && sudo make install
sudo ldconfig

rm -Rf /tmp/termite /tmp/vte-ng

