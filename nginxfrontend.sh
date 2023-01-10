source common.sh

print_head "Install nginx\e[0m"
yum install nginx -y &>>${log}
status_check


print_head "Remove nginx default content\e[0m"
rm -rf /usr/share/nginx/html/* &>>${log}
status_check

print_head "Download Frontend Content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}
status_check

cd /usr/share/nginx/html &>>${log}


print_head "Extract Frontend Content\e[0m"
unzip /tmp/frontend.zip &>>${log}
status_check


print_head "Copy Roboshop Nginx Config file\e[0m"
cp ${conf_file_location}/files/nginx-server-roboshop.conf /etc/nginx/default.d/roboshop.conf
status_check


print_head "Enable Nginx\e[0m"
systemctl enable nginx &>>${log}
status_check

print_head "Start Nginx\e[0m"
systemctl start nginx &>>${log}
status_check


