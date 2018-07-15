#!/bin/bash

### Variables ###

if which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi

if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    red="$(tput setaf 1)"
    green="$(tput setaf 2)"
    yellow="$(tput setaf 3)"
    blue="$(tput setaf 4)"
    purple="$(tput setaf 5)"
    cyan="$(tput setaf 6)"
    grey="$(tput setaf 7)"
    bold="$(tput bold)"
    normal="$(tput sgr0)"
else
    red=""
    green=""
    yellow=""
    blue=""
    bold=""
    normal=""
fi

php_version="7.0"

### Functions ###

loading() {
    
    echo -ne '[-] \r'
    sleep 0.1
    echo -ne '[\]\r'
    sleep 0.1
    echo -ne '[|]\r'
    sleep 0.1
    echo -ne '[/]\r'
    sleep 0.1
    echo -ne '[-] \r'
    sleep 0.1
    echo -ne '[\]\r'
    sleep 0.1
    echo -ne '[|]\r'
    sleep 0.1
    echo -ne '[/]\r'
    sleep 0.1
    echo -ne '[-] \r'
    sleep 0.1
    echo -ne '[\]\r'
    sleep 0.1
    echo -ne '[|]\r'
    sleep 0.1
    
}

logo () {

	clear

	printf "${green}${bold}"
	echo '   ______                   ____                         __ '
	echo '  / ____/________  _____   / __ \____ _____ ___  _____  / /_'
	echo ' / / __/ ___/ __ \/ ___/  / /_/ / __ `/ __ `/ / / / _ \/ __/'
	echo '/ /_/ / /  / /_/ (__  )  / ____/ /_/ / /_/ / /_/ /  __/ /_  '
	echo '\____/_/   \____/____/  /_/    \__,_/\__, /\__,_/\___/\__/  '
	echo '                                       /_/                  '
	echo ''
	printf "${normal}"

}

### Script ###

if [[ $EUID -ne 0 ]]; then

    logo
	echo -e "${red}This script must be run as root.${normal}"
	echo""
    exit 1
    
fi

echo 'deb http://ftp.fr.debian.org/debian/ stable main contrib non-free
deb http://ftp.fr.debian.org/debian/ stable-updates main contrib non-free

deb http://security.debian.org/ stable/updates main
' > /etc/apt/sources.list

while true; do
	
	logo
	read -rp "Install Let's Encrypt certbot ? y/N : " certbot

	if [[ "$certbot" = "y" ]] || [[ "$certbot" = "Y" ]]; then

		echo 'deb http://ftp.debian.org/debian stretch-backports main' >> /etc/apt/sources.list
		break

	elif [[ "$certbot" = "n" ]] || [[ "$certbot" = "N" ]]; then
		
		break

	else

		logo
		echo -e "${red}Please enter y/Y or n/N.${normal}"
        sleep 3

    fi

done

logo
apt update
apt full-upgrade -y
apt install curl git zsh -y

if [[ "$certbot" = "y" ]] || [[ "$certbot" = "Y" ]]; then

	apt install python-certbot-nginx -t stretch-backports -y

fi

while true; do
	
	logo
	read -rp "Install LEMP stack ? y/N : " lemp

	if [[ "$lemp" = "y" ]] || [[ "$lemp" = "Y" ]]; then

		echo ''
		apt install mariadb-server nginx nginx-extras php$php_version php$php_version-fpm php$php_version-mysql php$php_version-curl php$php_version-json php$php_version-gd \
		php$php_version-mcrypt php$php_version-msgpack php$php_version-memcached php$php_version-intl php$php_version-sqlite3 php$php_version-gmp php$php_version-geoip \
		php$php_version-mbstring php$php_version-xml php$php_version-zip -y
		mysql_secure_installation
		break

	elif [[ "$lemp" = "n" ]] || [[ "$lemp" = "N" ]]; then
		
		break

	else

		logo
		echo -e "${red}Please enter y/Y or n/N.${normal}"
        sleep 3

    fi

done