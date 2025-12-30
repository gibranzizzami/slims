#!/bin/bash

# install apache
apin=$(sudo pacman -Qe | grep apache)

if [[ -z "$apin" ]]; then
    echo "apache is not exist"
    sudo pacman -S apache --noconfirm
else 
    echo "apache already installed"
fi
    sudo systemctl enable httpd &&
    sudo systemctl start httpd

# install mariadb
marin=$(sudo pacman -Qe | grep mariadb)

if [[ -z "$marin" ]]; then
    echo "mariadb is not exist"
    sudo pacman -S mariadb --noconfirm
else 
    echo "mariadb already installed"
fi
    sudo systemctl enable mariadb &&
    sudo systemctl start mariadb

# install php
phpin=${php php-gd php-fpm}

if [[ -z "$phpin" ]]; then
    echo "php is not exist"
    sudo pacman -S ${phpin[@]} --noconfirm
else
   echo "php already exist"
fi

#install_php () {
 #   package="php" "php-gd" "php-fpm"
  #  if sudo pacman -Qe "$package" > /dev/null; then
   #    echo "package already installed"
    #else
     #   echo "package not installed"
      #  sudo pacman -S "$PACKAGE" --noconfirm
    #fi
#}