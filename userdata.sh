#!/bin/bash
sudo yum update –y
sudo yum upgrade
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
echo "<html><body style=\"background-color:blue;\"><h1 style=\"color:yellow;\">welcome to blue-green deployment poc v1 version of $(hostname -f) </h1></body></html>" > /var/www/html/index.html