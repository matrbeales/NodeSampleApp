#!/bin/bash

# Update the sources list
sudo apt-get update -y

# upgrade any packages available
sudo apt-get upgrade -y

# install nginx
sudo apt-get install nginx -y

# copy config in to place
sudo cp /home/ubuntu/templates/nginx.conf /etc/nginx/sites-available
sudo ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/nginx.conf

# restart nginx
sudo service nginx restart

# copy the profiles.d directory
sudo cp /home/ubuntu/profile.d/* /etc/profile.d

# install git
sudo apt-get install git -y

# install nodejs
sudo apt-get install python-software-properties -y
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install nodejs -y

# install pm2
sudo npm install pm2 -g
