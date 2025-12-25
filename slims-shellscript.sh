#!/bin/bash
#install apache
sudo pacman -S apache &&
sudo systemctl enable httpd &&
sudo systemctl start httpd
