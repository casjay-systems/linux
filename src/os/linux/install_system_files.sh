#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

srcdir="$(cd .. && pwd)"
customizedir="$(cd ../../customize && pwd)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' > /dev/null; then
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_motd() {

if [ -f /usr/games/fortune ]; then
FORTUNE="/usr/games/fortune"
else
FORTUNE=$(which fortune 2>/dev/null)
fi
if [ -f /usr/games/cowsay ]; then
COWSAY="/usr/games/cowsay"
else
COWSAY=$(which cowsay 2>/dev/null)
fi

    declare -r FILE_PATH="/etc/motd.net"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      sudo touch /etc/motd && \
      $FORTUNE | $COWSAY > /tmp/motd && \
      sudo mv -f /tmp/motd $FILE_PATH

    print_result $? "$FILE_PATH"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_issue() {

    declare -r FILE_PATH="/etc/issue.net"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      sudo touch /etc/issue && \
      sudo cp -Rf "$(cd .. && pwd)/shell/motd" /etc/issue.net

    print_result $? "$FILE_PATH"

}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_sudo() {
    declare -r FILE_PATH="/etc/sudoers.d/insults"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      echo "Defaults    insults" > $FILE_PATH

    print_result $? "$FILE_PATH"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_user() {
    MYUSER=${SUDO_USER:-$(whoami)}
    ISINDSUDO=$(sudo grep -Re "$MYUSER" /etc/sudoers* | grep "ALL" >/dev/null)
    declare -r FILE_PATH="/etc/sudoers.d/$MYUSER"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

      echo "$MYUSER ALL=(ALL)   NOPASSWD: ALL" > $FILE_PATH
      chmod -f 440 $FILE_PATH

    print_result $? "$FILE_PATH"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_pac() {
if [ -f /usr/bin/pacman ]; then

echo ""
    execute \
        "sudo cp -f $(cd .. && pwd)/bin/pac /usr/bin/pac" \
        "Installing pac → /usr/bin/pac"
fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_boot_theme() {

 if [ -f /usr/sbin/grub-mkconfig ]; then
  GRUB="/usr/sbin/grub-mkconfig"
 else
  GRUB="/usr/sbin/grub2-mkconfig"
 fi

    if [ -f /boot/grub/grub.cfg ]; then
     if [ ! -d /boot/grub/themes ]; then
      sudo mkdir -p /boot/grub/themes
     fi

echo ""
    execute \
        "sudo cp -Rf $customizedir/boot/grub /etc/default/grub && \
         sudo cp -Rf $customizedir/boot/themes/* /boot/grub/themes && \
         sudo sed -i 's|^\(GRUB_TERMINAL\w*=.*\)|#\1|' /etc/default/grub && \
         sudo sed -i 's|grubdir|grub|g' /etc/default/grub && \
         sudo ${GRUB} -o /boot/grub/grub.cfg" \
        "Installing grub customizations"

    fi
    ########
    if [ -f /boot/grub2/grub.cfg ]; then
     if [ ! -d /boot/grub2/themes ]; then
      sudo mkdir -p /boot/grub2/themes
     fi

echo ""
    execute \
        "sudo cp -Rf $customizedir/boot/grub /etc/default/grub && \
         sudo cp -Rf $customizedir/boot/themes/* /boot/grub2/themes && \
         sudo sed -i 's|^\(GRUB_TERMINAL\w*=.*\)|#\1|' /etc/default/grub && \
         sudo sed -i 's|grubdir|grub2|g' /etc/default/grub && \
         sudo ${GRUB} -o /boot/grub2/grub.cfg" \
        "Installing grub customizations"

    fi


}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
create_login_theme() {

LXDM=$(which lxdm 2>/dev/null)
 if [ -d /usr/share/lightdm-gtk-greeter-settings ]; then
LIGHTDMG=/usr/share/lightdm-gtk-greeter-settings
 elif [ -d /usr/share/lightdm-gtk-greeter ]; then
LIGHTDMG=/usr/share/lightdm-gtk-greeter
else
LIGHTDMG=/usr/share/lightdm/lightdm-gtk-greeter.conf.d
fi

  if [ -d /etc/lightdm ]; then
echo ""
     execute \
        "sudo cp -Rf $customizedir/login/lightdm/etc/* /etc/lightdm/ && \
         sudo cp -Rf $customizedir/login/lightdm/share/lightdm/* /usr/share/lightdm/ && \
         sudo cp -Rf $customizedir/login/lightdm/share/lightdm-gtk-greeter-settings/* $LIGHTDMG/" \
        "Installing lightdm customizations"
  fi

    ########
  if [ -d /etc/lxdm ]; then
echo ""
     execute \
        "sudo cp -Rf $customizedir/login/lxdm/share/* /usr/share/lxdm/" \
        "Installing lxdm customizations"
  fi

   if [ ! -z "$LXDM" ]; then

    sudo sed -i "s|.*numlock=.*|numlock=1|g" /etc/lxdm/lxdm.conf
    sudo sed -i "s|.*bg=.*|bg=/usr/share/lxdm/themes/BlackArch/blackarch.jpg|g" /etc/lxdm/lxdm.conf
    sudo sed -i "s|.*tcp_listen=.*|tcp_listen=1|g" /etc/lxdm/lxdm.conf
    sudo sed -i "s|gtk_theme=.*|gtk_theme=Arc-Pink-Dark|g" /etc/lxdm/lxdm.conf
    sudo sed -i "s|theme=.*|theme=BlackArch|g" /etc/lxdm/lxdm.conf

    if [ -f /etc/X11/default-display-manager ]; then
    sudo sed -i "s|lightdm|lxdm|g" /etc/X11/default-display-manager
    fi
echo ""

#     execute \
#        "sudo systemctl disable -f lightdm 2>/dev/null && \
#         sudo systemctl enable -f lxdm 2>/dev/null" \
#        "Enabling the LXDM login manager"

  fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_icons() {

echo ""
    execute \
        "sudo cp -Rf $customizedir/icons/* /usr/share/icons && \
         sudo fc-cache -f /usr/share/icons/N.I.B./ && \
         sudo fc-cache -f /usr/share/icons/Obsidian-Purple/" \
        "Installing icons"

echo ""
sudo find /usr/share/icons -mindepth 1 -maxdepth 1 -type d | while read -r THEME; do
 if [ -f "$THEME/index.theme" ]; then
    execute \
        "gtk-update-icon-cache -f -q "$THEME"" \
        "Updating ICON cache"
 fi
done

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_themes() {

echo ""
    execute \
        "sudo cp -Rf $customizedir/themes/* /usr/share/themes" \
        "Installing themes"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_fonts() {

echo ""
    execute \
        "sudo cp -Rf $customizedir/fonts/* /usr/share/fonts" \
        "Installing fonts"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

fi

main() {

    sudo chmod -f 755 /etc/sudoers.d

    create_motd

    create_issue

    create_sudo

    create_user

    create_pac

    create_boot_theme

    create_login_theme

    create_icons

    create_themes

    create_fonts

}

main

