#!/bin/bash

# Update the package list
apt-get update -y

# Install PPTP VPN server
apt-get install -y ppp pptpd

# Configure PPTP server settings
echo "localip 192.168.0.1" | tee -a /etc/pptpd.conf
echo "remoteip 192.168.0.100-200" | tee -a /etc/pptpd.conf
echo "ms-dns 1.1.1.1" | tee -a /etc/ppp/pptpd-options
echo "ms-dns 1.0.0.1" | tee -a /etc/ppp/pptpd-options

# Set up user credentials
echo "rendy pptpd password123 *" | tee -a /etc/ppp/chap-secrets

# Restart PPTP service
/etc/init.d/pptpd restart

# Enable IP forwarding
echo "net.ipv4.ip_forward=1" | tee -a /etc/sysctl.conf
sysctl -p

# Set up firewall rules
iptables -t nat -A POSTROUTING -j MASQUERADE
iptables -I INPUT -s 192.168.0.0/24 -i ppp0 -j ACCEPT
iptables -A FORWARD -i eth0 -j ACCEPT

# Download and set up additional user script
wget -q -O /usr/bin/add-vpn-user "http://rendymandolang.my.id/tools/vpn/adduser.sh"
chmod +x /usr/bin/add-vpn-user

echo "VPN setup completed."
