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