#!/usr/bin/env bash

# Setup Keys
## from debgen.simplylinux.ch
echo > /tmp/debian.key
curl -fsSL https://download.docker.com/linux/debian/gpg > /tmp/debian.key && apt-key add /tmp/debian.key
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc > /tmp/debian.key && apt-key add /tmp/debian.key
curl -LsR --url https://packagecloud.io/AtomEditor/atom/gpgkey -o /etc/apt/trusted.gpg.d/AtomEditor.pub.gpg.asc
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub > /tmp/debian.key && apt-key add /tmp/debian.key
wget -q -O - https://www.liveconfig.com/liveconfig.key > /tmp/debian.key && apt-key add /tmp/debian.key
wget -q -O - https://apt.llvm.org/llvm-snapshot.gpg.key > /tmp/debian.key && apt-key add /tmp/debian.key
wget -q -O - https://nginx.org/keys/nginx_signing.key > /tmp/debian.key && apt-key add /tmp/debian.key
wget -q -O - http://deb.opera.com/archive.key > /tmp/debian.key && apt-key add /tmp/debian.key
wget -q -O - https://packages.sury.org/php/apt.gpg > /tmp/debian.key && apt-key add /tmp/debian.key
wget -q -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc > /tmp/debian.key && apt-key add /tmp/debian.key
wget -q -O - http://download.proxmox.com/debian/key.asc > /tmp/debian.key && apt-key add /tmp/debian.key
wget -q -O - https://archive.parrotsec.org/parrot/misc/parrotsec.gpg > /tmp/debian.key && apt-key add /tmp/debian.key
wget -q -O - http://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc > /tmp/debian.key && apt-key add /tmp/debian.key
for key in \
BA300B7755AFCFAE \
72B97FD1D9672C93 \
0xF1656F24C74CD1D8 \
74A941BA219EC810 \
2CC26F777B8B44A1 \
74A941BA219EC810 \
8D04CE49EFB20B23 \
4B8EC3BAABDC4346 \
BA300B7755AFCFAE \
6494C6D6997C215E \
8D04CE49EFB20B23
do \
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $key && \
apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys $key
done

# Clean up
rm -Rf /tmp/debian.key
rm -Rf /tmp/apt-key*

#Grab multimedia package
wget -q http://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2016.8.1_all.deb -O /tmp/deb-multimedia-keyring_2016.8.1_all.deb
rm -Rf /tmp/deb-multimedia-keyring_2016.8.1_all.deb

# update apt
apt-get update && apt-get update && apt-get update
apt-get -yy -qq install apt-transport-https dirmngr
dpkg -i /tmp/deb-multimedia-keyring_2016.8.1_all.deb
apt-get install -f
