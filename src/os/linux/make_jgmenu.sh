#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

srcdir="$(cd .. && pwd)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
rm -Rf /tmp/jgmenu /tmp/polybar

jgmenu() {
rm -Rf /tmp/jgmenu
echo ""
execute \
"git clone -q https://github.com/johanmalm/jgmenu.git /tmp/jgmenu ; \
mkdir -p /tmp/jgmenu ; \
cd /tmp/jgmenu ; \
make 2> /dev/null ; \
sudo make install 2> /dev/null" \
"Be patient..... compiling and installing jgmenu → /usr/local/bin"

}

main() {

    jgmenu

}

main
