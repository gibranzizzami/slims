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
phpin=$(sudo pacman -Qe | grep php php-gd php-fpm)

if [[ -z "$phpin" ]]; then
    echo "php is not exist"
    sudo pacman -S php php-gd php-fpm --noconfirm
else
    echo "php already exist"
fi