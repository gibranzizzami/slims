#!/bin/bash

apin=sudo pacman -Qe | grep apache

if [[ -z "$apin" ]]; then
    echo "apache belum terinstall."
    sudo pacman -S apache
else 
    echo "apache sudah terinstall"
fi