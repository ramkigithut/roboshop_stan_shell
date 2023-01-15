#!/usr/bin/env bash

source common.sh

print_head "Copy MongoDB Repo file"
cp ${conf_fie_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log}
status_check

print_head "Install MongoDB"
yum install mongodb-org -y &>>${log}
status_check

print_head "update MongoDB listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log}
status_check

print_head "Enable MongoDB"
systemctl enable mongod &>>${log}
status_check

print_head "start MongoDB"
systemctl start mongod &>>${log}
status_check