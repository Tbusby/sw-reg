#!/bin/env bash
#
# This script will register one of Aptavists ubuntu 14 servers with the spacewalk server

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "##### This script needs to run as root"
    exit 1
fi

# Install the ubuntu/spacewalk packages rhnreg etc 
apt-get install software-properties-common -y
add-apt-repository ppa:aaronr/spacewalk -y
apt-get update -y
apt-get install apt-transport-spacewalk rhnsd python-libxml2 -y

mkdir /var/lock/subsys

#get the ssl cert from spacewalk
wget http://avst-prod10.adaptavist.com/pub/RHN-ORG-TRUSTED-SSL-CERT -P /usr/share/rhn/

# Register with spacewalk server
if grep -q "^DISTRIB_RELEASE=12." /etc/lsb-release; then
  rhnreg_ks --serverUrl=https://avst-prod10.dyn.adaptavist.com/XMLRPC --sslCACert=/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT --activationkey=1-fa0695be578268a708c985bda99d87ae
  echo 'deb spacewalk://avst-prod10.adaptavist.com/XMLRPC channels: precise precise-updates precise-security' > /etc/apt/sources.list.d/spacewalk.list
else
  rhnreg_ks --serverUrl=https://avst-prod10.dyn.adaptavist.com/XMLRPC --sslCACert=/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT --activationkey=1-c5e4ae3168148946471d7cbd2a489391
  echo 'deb spacewalk://avst-prod10.adaptavist.com/XMLRPC channels: trusty trusty-updates trusty-security' > /etc/apt/sources.list.d/spacewalk.list
fi

apt-get update -y 


