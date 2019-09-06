# WSL Setup script for laravel dev env
This is a setup script for Windows Subsystem Linux environment running on Ubuntu 18.04 LTS. This script installs nginx, mariadb, php7.3, nodejs, yarn and composer with all the modules necessary for Laravel 6 to run. 

# How to use
1. Setup WSL on your Windows PC -> https://docs.microsoft.com/en-us/windows/wsl/install-win10
2. Clone this repo to your home foler

```
cd ~/
git clone https://github.com/kuressaareametikool/wsl-laravel.git
```
3. Change directory to wsl-laravel
```
cd wsl-laravel
```
4. Give execution rights to the script
```
sudo chmod +x setup.sh
```
5. Run the script
```
./setup.sh
```
6. When install is done open http://localhost on your Windows 10 browser

# Using VS Code
It's also possible to use VS Code directly form Ubuntu. Go to any folder and type 
```
code .
``` 
If VS Code is installed on your PC it should open automatically and offer to install the WSL extension. Click on Install and you should be good to go.

# PHP

If you choose not to install Laravel then a basic modern PHP stack will be installed. Nginx will then serve the site from 
```
/var/www/html
```

# MariaDB
Latest version of MariaDB is also installed with a demo database of Books.

# Laravel
When you choose to install Laravel you have two options. First one is to create the basic structure so you can clone your own repo and the second option is to install a whole new version. The new version will be installed to: 
```
/var/www/laravel
```
With both options Nginx is configured to serve the site from the `/var/www/laravel/public` dir.
