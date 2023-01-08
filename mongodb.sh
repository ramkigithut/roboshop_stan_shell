#!/usr/bin/env bash
conf_fie_location=$(pwd)
cp ${conf_fie_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo

yum install mongodb-org -y
systemctl enable mongod
systemctl start mongod