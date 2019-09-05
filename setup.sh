#!/bin/bash

#Update
sudo apt update -y
sudo apt upgrade -y --force-yes

#Add repos
sudo apt-add-repository ppa:nginx/stable -y
sudo apt-add-repository ppa:ondrej/php -y
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get install software-properties-common -y
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
sudo add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://mariadb.nethub.com.hk/repo/10.4/ubuntu bionic main'

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
sudo chown -R www-data.www-data /var/www/laravel/storage
sudo chown -R www-data.www-data /var/www/laravel/bootstrap/cache

#Configute nginx
sudo cat > /etc/nginx/sites-available/laravel <<'EOF'
server {
    listen 80;
    server_name localhost;
    root /var/www/laravel/public;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";

    index index.html index.htm index.php;

    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/
sudo unlink /etc/nginx/sites-enabled/default

#Start services
sudo service nginx start
sudo service mysql start
sudo service php7.3-fpm start

sudo mysql -u root <<EOF
UPDATE mysql.user SET plugin = 'mysql_native_password' WHERE user = 'root' AND plugin = 'unix_socket';
FLUSH PRIVILEGES;
EOF
exit