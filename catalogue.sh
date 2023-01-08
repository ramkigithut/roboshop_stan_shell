#!/usr/bin/env bash
conf_file_location=$(pwd)
set -e
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
#useradd roboshop
mkdir -p /app
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.
cd /app
npm install

cp ${conf_file_location}/files/catalogue.service /etc/systemd/system/catalogue.service
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue