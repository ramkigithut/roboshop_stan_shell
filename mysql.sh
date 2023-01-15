#!/usr/bin/env bash

source common.sh

if [ -z "${root_mysql_password}" ]; then
  echo "Variable root_mysql_password is missing"
  exit
fi


print_head "Disabling Default Module MySQL 8 Version"
dnf module disable mysql -y &>>${log}
status_check

print_head "Copy MySQL Repo file"
cp $(pwd)/files/mysql.repo  /etc/yum.repos.d/mysql.repo &>>${log}
status_check

print_head "Installing MySQL Server"
yum install mysql-community-server -y &>>${log}
status_check


print_head "Enable MySQL"
systemctl enable mysqld &>>${log}
status_check

print_head "start MySQL"
systemctl start mysqld &>>${log}
status_check

print_head "Reset Default Database password"
mysql_secure_installation --set-root-pass ${root_mysql_password} &>>${log}
status_check

