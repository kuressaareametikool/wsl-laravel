#!/bin/bash

read -p "Do you wish use Laravel?(y/n)" answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    read -p "Do you also want install Laravel?(y/n)" install
fi

sudo './install.sh'

#Configute nginx
sudo unlink /etc/nginx/sites-enabled/default

if [ "$answer" != "${answer#[Yy]}" ] ;then
    if [ "$install" != "${install#[Yy]}" ] ;then
        #Create Laravel Project
        composer create-project --prefer-dist laravel/laravel
    else
        mkdir laravel/public
    fi

    #Move Laravel to correct location
    sudo mv laravel /var/www/
    sudo chown -R www-data.www-data /var/www/laravel/storage
    sudo chown -R www-data.www-data /var/www/laravel/bootstrap/cache

    sudo mv ~/wsl-laravel/laravel /etc/nginx/sites-available/
    sudo ln -s /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/
else
    sudo mv ~/wsl-laravel/default /etc/nginx/sites-available/
    sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
    sudo chown -R $USER /var/www/html
fi

#Start services
sudo service nginx start
sudo service mysql start
sudo service php7.3-fpm start

sudo mysql -u root <<EOF
UPDATE mysql.user SET plugin = 'mysql_native_password' WHERE user = 'root' AND plugin = 'unix_socket';
FLUSH PRIVILEGES;
CREATE DATABASE Books;
EOF
mysql -u root Books < Books.sql