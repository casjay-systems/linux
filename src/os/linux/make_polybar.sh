#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

srcdir="$(cd .. && pwd)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

polybar() {
rm -Rf /tmp/polybar

echo ""
execute \
"git clone -q --recursive https://github.com/jaagr/polybar /tmp/polybar ; \
mkdir -p /tmp/polybar/build ; \
cd /tmp/polybar/build ; \
cmake .. 2> /dev/null ; \
make -j$(nproc) 2> /dev/null ; \
sudo make install 2> /dev/null" \
"Be patient..... compiling and installing polybar → /usr/local/bin"

}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
rm -Rf /tmp/jgmenu /tmp/polybar
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    polybar

}

main
