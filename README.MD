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
sudo './setup.sh'
```
6. When install is done open http://localhost on your Windows 10 browser

# Using VS Code
It's also possible to use VS Code directly form Ubuntu. Go to any folder and type 
```
code .
``` 
If VS Code is installed on your PC it should open automatically and offer to install the WSL extension. Click on Install and you should be good to go.
# Laravel
Laravel will be installed into
```
/var/www/laravel
```
Nginx is configured to serve the site from the `public` dir
