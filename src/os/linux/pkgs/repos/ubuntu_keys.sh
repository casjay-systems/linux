#!/usr/bin/env bash

# Setup Keys
echo > /tmp/ubuntu.key
curl -fsSL https://packagecloud.io/AtomEditor/atom/gpgkey > /tmp/debian.key && apt-key add /tmp/ubuntu.key 
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc > /tmp/debian.key && apt-key add /tmp/ubuntu.key 
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub > /tmp/debian.key && apt-key add /tmp/ubuntu.key 
wget -q -O - http://deb.opera.com/archive.key > /tmp/debian.key && apt-key add /tmp/ubuntu.key 
for key in \
BA300B7755AFCFAE \
8D04CE49EFB20B23 \
886DDD89
do \
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $key  && \
apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys $key 
done
#
rm -Rf /tmp/ubuntu.key
rm -Rf /tmp/apt-key*
#
apt-get update && apt-get update && apt-get update 
apt-get -yy -qq install apt-transport-https dirmngr 
apt-get install -f 
