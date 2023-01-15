#!/usr/bin/env bash

source common.sh

print_head "installing redis Repo file"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log}
status_check

print_head "Enabling redis 6.2 dnf module "
dnf module enable redis:remi-6.2 -y &>>${log}
status_check

print_head "Installing redis"
yum install redis -y  &>>${log}
status_check

print_head "update redis listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>${log}
status_check

print_head "Enable redis service"
systemctl enable redis &>>${log}
status_check

print_head "start redis"
systemctl start redis &>>${log}
status_check