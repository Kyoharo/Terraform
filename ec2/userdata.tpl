#!/bin/bash
sudo su
apt update
apt install -y apache2
echo "Hello from AWS Cloud!" > /var/www/html/index.html