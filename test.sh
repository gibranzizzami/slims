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

# install php
phpin=$(sudo pacman -Qe | grep php php-fpm php-gd)

if [[ -z "$phpin" ]]; then
    echo "php is not exist"
    sudo pacman -S php php-fpm php-gd
else
    echo "php already installed"
fi