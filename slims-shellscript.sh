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
sudo mv /srv/http/slims9_bulian-9.7.2 /srv/http/slims &&
sudo chown -R http:http /srv/http/slims &&

# CONFIGURATION APACHE
APACHE_CONF="/etc/httpd/conf/httpd.conf"

# BACKUP FILE KONFIGURASI
sudo cp $APACHE_CONF ${APACHE_CONF}.bak

# ENABLE REQUIRED MODULES
sudo sed -i \
-e 's/^#LoadModule rewrite_module/LoadModule rewrite_module/' \
$APACHE_CONF

# Tambahkan proxy & proxy_fcgi setelah AddHandler php
sudo sed -i '/AddHandler php-script .php/a \
LoadModule proxy_module modules/mod_proxy.so\n\
LoadModule proxy_fcgi_module modules/mod_proxy_fcgi.so' \
$APACHE_CONF

# ENABLE PHP-FPM HANDLER
sudo tee -a $APACHE_CONF > /dev/null <<EOF

<FilesMatch "\.php$">
    SetHandler "proxy:unix:/run/php-fpm/php-fpm.sock|fcgi://localhost/"
</FilesMatch>
EOF

# SET AllowOverride All
sudo sed -i \
-e 's/AllowOverride None/AllowOverride All/' \
$APACHE_CONF

# SET DIRECTORY INDEX
sudo sed -i \
-e 's/DirectoryIndex index.html/DirectoryIndex index.php index.html index.htm/' \
$APACHE_CONF

# RESTART APACHE
sudo systemctl enable php-fpm &&
sudo systemctl start php-fpm &&
sudo systemctl restart httpd