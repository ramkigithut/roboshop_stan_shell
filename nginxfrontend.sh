#!/usr/bin/env bash
conf_file_location=$(pwd)
log=/tmp/roboshop.log

echo -e "\e[35m Install nginx\e[0m"
yum install nginx -y &>>${log}
echo $?

echo -e "\e[35m Remove nginx default content\e[0m"
rm -rf /usr/share/nginx/html/* &>>${log}
echo $?

echo -e "\e[35m Download Frontend Content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html &>>${log}
echo $?

echo -e "\e[35m Extract Frontend Content\e[0m"
unzip /tmp/frontend.zip &>>${log}
echo $?

echo -e "\e[35m Copy Roboshop Nginx Config file\e[0m"
cp ${conf_file_location}/files/nginx-server-roboshop.conf /etc/nginx/default.d/roboshop.conf
echo $?

echo -e "\e[35m Enable Nginx\e[0m"
systemctl enable nginx &>>${log}
echo $?

echo -e "\e[35m Start Nginx\e[0m"
systemctl start nginx &>>${log}
echo $?

