#!/bin/bash

read -p "Do you wish to use Laravel?(y/n): " answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    read -p "Do you also want install Laravel?(y/n): " install
    if [ "$install" != "${answer#[Yy]}" ] ;then
        read -p "Paste in the Github repo link you want to use: " github
    fi
fi

sudo chmod +x install.sh
sudo './install.sh'

#Configute nginx
sudo unlink /etc/nginx/sites-enabled/default

if [ "$answer" != "${answer#[Yy]}" ] ;then
    if [ "$install" != "${install#[Yy]}" ] ;then
        #Create Laravel Project
        composer create-project --prefer-dist laravel/laravel
        sudo mv laravel /var/www/
        sudo chown -R www-data.www-data /var/www/laravel/storage
        sudo chown -R www-data.www-data /var/www/laravel/bootstrap/cache
    else
        git clone $github ~/laravel
        sudo chown -R $USER.www-data ~/laravel
        sudo mv ~/laravel /var/www/
        sudo chown -R www-data.www-data /var/www/laravel/storage
        sudo chown -R www-data.www-data /var/www/laravel/bootstrap/cache
        cd /var/www/laravel
        mv .env.example .env
        php artisan key:generate
        comoser install
        yarn
    fi
    
    sudo mv laravel-php /etc/nginx/sites-available/
    sudo ln -s /etc/nginx/sites-available/laravel-php /etc/nginx/sites-enabled/
else
    sudo mv default-php /etc/nginx/sites-available/
    sudo ln -s /etc/nginx/sites-available/default-php /etc/nginx/sites-enabled/
    sudo chown -R $USER.www-data /var/www/html
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