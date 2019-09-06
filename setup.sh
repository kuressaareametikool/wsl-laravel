#!/bin/bash

sudo 'export DEBIAN_FRONTEND=noninteractive'

#Update
sudo apt update -y
sudo apt upgrade -y

#Add repos
sudo apt-add-repository ppa:nginx/stable -y
sudo apt-add-repository ppa:ondrej/php -y
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update -y

#Install packages
sudo apt install mariadb-server nginx php7.3-mbstring php7.3-xml php7.3-bcmath php7.3-fpm php7.3-mysql php7.3-zip unzip nodejs yarn -y

#Install Composer
cd ~
curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer

#Create Laravel Project
composer create-project --prefer-dist laravel/laravel

#Move Laravel to correct location
sudo mv laravel /var/www/
sudo chown -R $USER.www-data /var/www/laravel
sudo chown -R www-data.www-data /var/www/laravel/storage
sudo chown -R www-data.www-data /var/www/laravel/bootstrap/cache

#Configute nginx
sudo mv ~/wsl-laravel/laravel /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/
sudo unlink /etc/nginx/sites-enabled/default

#Start services
sudo service nginx start
sudo service mysql start
sudo service php7.3-fpm start

mysql -u root <<EOF
UPDATE mysql.user SET plugin = 'mysql_native_password' WHERE user = 'root' AND plugin = 'unix_socket';
FLUSH PRIVILEGES;
EOF
exit

cd /var/www/laravel