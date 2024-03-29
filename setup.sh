#!/bin/bash

#Check sudo
if [[ "$EUID" = 0 ]]; then
    echo "(1) already root"
else
    sudo -k # make sure to ask for password on next sudo
    if sudo true; 
    then echo "(2) correct password"
    else echo "(3) wrong password" && exit 1
    fi
fi
# Do your sudo stuff here. Password will not be asked again due to caching.

#Variables
$Keyboard=fr;

#Functions:
reboot () { echo 'Reboot? (y/N)' && read x && [[ "$x" == "y" ]] && /sbin/reboot; }

#Install working driver for VMWare
echo 'Install correct vmware driver? (y/N)' && read x && [[ "$x" == "y" ]] && apt install open-vm-tools && apt install open-vm-tools-desktop ;

#Change keyboard country
sed -i 's/XKBLAYOUT=.*/XKBLAYOUT="fr"/' /etc/default/keyboard;

#Full update system
apt update -y && apt full-upgrade -y --allow-downgrades && apt autoremove -y && apt autoclean -y;

#Install usefull tools
apt install $(cat tools.list | tr "\n" " ") -y;

#Alias and function
echo 'alias nm="nmap"' >> ~/.bash_aliases
echo 'alias maj="sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt autoclean -y"' >> ~/.bash_aliases
echo 'alias gobusterz="gobuster dir --wordlist /usr/share/dirbuster/wordlists/directory-list-lowercase-2.3-medium.txt --url "' >> ~/.bash_aliases
echo 'alias s="sudo"' >> ~/.bash_aliases
echo 'alias nmapz="nmap -sC -p- -sV $1"' >> ~/.bash_aliases
#echo 'function mkcd { mkdir -p -- "$1" && cd -P -- "$1" }' >> ~/.bash_aliases

#Reboot
reboot;

exit 0;
