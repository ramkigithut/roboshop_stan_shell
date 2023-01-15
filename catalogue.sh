source common.sh

print_head "Configuring nodejs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
status_check

print_head "Install nodejs"
yum install nodejs -y &>>${log}
status_check

print_head "Add Application user"
id roboshop &>>${log}
if [ $? -ne 0 ]; then
  useradd roboshop &>>${log}
fi
status_check

mkdir -p /app &>>${log}

print_head "Downloading App Content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log}
status_check

print_head "Cleanup Old Content"
rm -rf /app/* &>>${log}
status_check

print_head "CleaExtracting App Content"
cd /app &>>${log}
unzip /tmp/catalogue.zip &>>${log}
status_check

print_head "Installing nodejs Dependencies"
cd /app &>>${log}
npm install -g npm@9.2.0 &>>${log}
status_check

print_head "Configuring catalogue service file"
cp ${conf_file_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${log}
status_check

print_head "Reload SystemD"
systemctl daemon-reload &>>${log}
status_check


print_head "Enable catalogue service"
systemctl enable catalogue &>>${log}
status_check


print_head "start catalogue service"
systemctl start catalogue &>>${log}
status_check

print_head "Configuring mongo repos"
cp ${conf_file_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log}
status_check

print_head "Installing mongo client"
yum install mongodb-org-shell -y &>>${log}
status_check

print_head "load schema"
mongo --host mongodb-dev.practicaldevops.online </app/schema/catalogue.js &>>${log}
status_check