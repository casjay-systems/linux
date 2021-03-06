#!/usr/bin/env bash
APT="DEBIAN_FRONTEND=noninteractive apt-get"
APTOPTS="-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold""
APTINST="--ignore-missing -yy -qq --allow-unauthenticated --assume-yes"

INSTPKGS="apt-transport-https openbox obmenu code google-chrome-stable opera-stable rhythmbox awesome brotli build-essential byobu caja catfish chromium-browser cmake cmake-data cmatrix conky cowsay cscope curl dmenu exo-utils figlet filezilla firefox fish flashplugin-installer font-manager fonts-powerline fortune-mod geany gimp git gmrun hollywood i3 i3blocks i3lock i3lock-fancy i3status i3-wm iftop imagemagick iperf kleopatra libasound2-dev libcairo2-dev libiw-dev libjsoncpp-dev libmpdclient-dev libnl-genl-3-dev libpulse-dev libreoffice libxcb1 libxcb1-dev libxcb-composite0-dev libxcb-cursor-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-keysyms1 libxcb-keysyms1-dev libxcb-randr0 libxcb-randr0-dev libxcb-util0-dev libxcb-util1 libxcb-util-dev libxcb-xkb-dev libxcb-xrm-dev libx11-dev libxrandr-dev libcairo2-dev libpango1.0-dev librsvg2-dev libxml2-dev libglib2.0-dev libmenu-cache-dev livestreamer lm-sensors localepurge lolcat lsb-release lxappearance mpc mpv neofetch net-tools nodejs npm nyancat pkg-config plank powerline pulseaudio-module-bluetooth pulseaudio-utils python-requests python3-pip python3-sphinx python-xcbgen ranger recordmydesktop rofi samba shellcheck sl smplayer smtube speedtest-cli terminology thefuck thunderbird tmux tor torsocks transmission variety vclt-tools vifm vim-nox vim-airline vim-airline-themes vlc xcb xcb-proto xclip xfce4 xfce4-appfinder xfce4-clipman xfce4-notifyd xfce4-pulseaudio-plugin xfce4-screenshooter xfce4-taskmanager youtube-dl zenmap zopfli zplug zsh visual-studio-code"

for i in $INSTPKGS; do
  sudo $APT $APTOPTS $APTINST install $i </dev/null >/dev/null 2>&1
done
sudo $APT $APTOPTS $APTINST install -f >/dev/null 2>&1
sudo dpkg --configure -a >/dev/null 2>&1
sudo touch /etc/apt/.srckeys
