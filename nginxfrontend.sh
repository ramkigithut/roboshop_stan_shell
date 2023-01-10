source common.sh

print_head "Install nginx"
yum install nginx -y &>>${log}
status_check


print_head "Remove nginx default content"
rm -rf /usr/share/nginx/html/* &>>${log}
status_check

print_head "Download Frontend Content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}
status_check

cd /usr/share/nginx/html &>>${log}


print_head "Extract Frontend Content"
unzip /tmp/frontend.zip &>>${log}
status_check


print_head "Copy Roboshop nginx Config file"
cp ${conf_file_location}/files/nginx-server-roboshop.conf /etc/nginx/default.d/roboshop.conf
status_check


print_head "Enable nginx"
systemctl enable nginx &>>${log}
status_check

print_head "Start nginx"
systemctl start nginx &>>${log}
status_check


