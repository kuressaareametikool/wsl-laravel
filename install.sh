#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

#Update
apt update -y
apt upgrade -y

#Add repos
apt-add-repository ppa:nginx/stable -y
apt-add-repository ppa:ondrej/php -y
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

apt-get update -y

#Install packages
apt install mariadb-server nginx php7.3-mbstring php7.3-xml php7.3-bcmath php7.3-fpm php7.3-mysql php7.3-zip unzip nodejs yarn -y

#Install Composer
cd ~
curl -sS https://getcomposer.org/installer -o composer-setup.php
php composer-setup.php --install-dir=/usr/local/bin --filename=composer