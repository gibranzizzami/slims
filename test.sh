#!/bin/bash

apin="sudo pacman -Qe apache"

if [[ -z "$apin" ]]; then
    echo "apache belum terinstall"
else 
    echo "apache sudah terinstall"
fi