#!/bin/bash

#install apache
apin=$(sudo pacman -Qe | grep apache)

if [[ -z "$apin" ]]; then
    echo "apache is not exist"
    sudo pacman -S apache --noconfirm
else 
    echo "apache already installed"
fi
    sudo systemctl enable httpd &&
    sudo systemctl start httpd &&

# Install php
sudo pacman -S php php-fpm php-gd --noconfirm &&

# install mariadb
marin=$(sudo pacman -Qe | grep mariadb)

if [[ -z "$marin" ]]; then
    echo "mariadb is not exist"
    sudo pacman -S mariadb --noconfirm &&
    sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
else 
    echo "mariadb already installed"
fi
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
wget https://github.com/slims/slims9_bulian/releases/download/v9.7.2/slims9_bulian-9.7.2.tar.gz &&
sudo tar -xf slims9_bulian-9.7.2.tar.gz -C /srv/http &&
sudo mv -f /srv/http/slims9_bulian-9.7.2 /srv/http/slims &&
sudo chown -R http:http /srv/http/slims &&

APACHE_CONF="/etc/httpd/conf/httpd.conf"

# Backup konfigurasi
sudo cp $APACHE_CONF ${APACHE_CONF}.bak

# Uncommenting LoadModule proxy dan proxy_fcgi
sudo sed -i \
-e 's|^#LoadModule proxy_module modules/mod_proxy.so|LoadModule proxy_module modules/mod_proxy.so|' \
-e 's|^#LoadModule proxy_fcgi_module modules/mod_proxy_fcgi.so|LoadModule proxy_fcgi_module modules/mod_proxy_fcgi.so|' \
$APACHE_CONF

# Uncommenting module rewrite
sudo sed -i \
-e 's/^#LoadModule rewrite_module/LoadModule rewrite_module/' \
$APACHE_CONF

# Menambahkan pada baris paling terakhir
sudo tee -a $APACHE_CONF > /dev/null <<EOF

<FilesMatch "\.php$">
    SetHandler "proxy:unix:/run/php-fpm/php-fpm.sock|fcgi://localhost/"
</FilesMatch>
EOF

# Mengubah aksess override pada direktori /srv/http
sudo sed -i \
-e 's/AllowOverride None/AllowOverride All/' \
$APACHE_CONF

# Menambahkan pada directory index
sudo sed -i \
-e 's/DirectoryIndex index.html/DirectoryIndex index.php index.html index.htm/' \
$APACHE_CONF

PHP_INI="/etc/php/php.ini"

# Backup php.ini
sudo cp $PHP_INI ${PHP_INI}.bak

# Uncommenting beberapan extension
sudo sed -i \
-e 's/^;extension=mysqli/extension=mysqli/' \
-e 's/^;extension=gettext/extension=gettext/' \
-e 's/^;extension=pdo_mysql/extension=pdo_mysql/' \
-e 's/^;extension=gd/extension=gd/' \
$PHP_INI

# Uncommenting extension xml dan mbstring
sudo sed -i \
-e 's/^;extension=xml/extension=xml/' \
-e 's/^;extension=mbstring/extension=mbstring/' \
$PHP_INI

# Mengaktifkan php service
sudo systemctl enable php-fpm &&
sudo systemctl start php-fpm &&

# Restart apache
sudo systemctl restart httpd &&

echo "slims successfully installed"