#!/bin/bash
#install apache
sudo pacman -S apache --noconfirm &&
sudo systemctl enable httpd &&
sudo systemctl start httpd &&

# install mariadb
sudo pacman -S mariadb php php-fpm php-gd --noconfirm &&
sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql &&
sudo systemctl enable mariadb &&
sudo systemctl start mariadb &&

# create database & user
sudo mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS slims;
CREATE USER IF NOT EXISTS 'slims_user'@'localhost'
IDENTIFIED BY 'userslims';
GRANT ALL PRIVILEGES ON slims.* TO 'slims_user'@'localhost';
FLUSH PRIVILEGES;
EOF

# Download slims
cd /home/null/Downloads &&
wget https://github.com/slims/slims9_bulian/releases/download/v9.7.2/slims9_bulian-9.7.2.tar.gz &&
sudo tar -xf /home/null/Downloads/slims9_bulian-9.7.2.tar.gz -C /srv/http &&
sudo mv /srv/http/slims9_bulian-9.7.2 /srv/http/slims