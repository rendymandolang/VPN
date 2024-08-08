#!/bin/bash
#Script Tambah PPTP User
read -p "Username : " USER
read -p "Password : " PASS
IP=`dig +short myip.opendns.com @resolver1.opendns.com`
echo "$USER    pptpd   $PASS    *" | tee -a /etc/ppp/chap-secrets
/etc/init.d/pptpd restart
echo "PPTP User Created!" 
echo -e "=========-account-=========="
echo -e "Host: $IP"
echo -e "Username: $USER"
echo -e "Password: $PASS"
