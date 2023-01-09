#!/usr/bin/env bash
conf_file_location=$(pwd)
log=/tmp/roboshop.log

echo -e "\e[35m Configuring nodejs repos\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[35m Install nodejs\e[0m"
yum install nodejs -y &>>${log}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[35m Add Application user\e[0m"
useradd roboshop &>>${log}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

mkdir -p /app &>>${log}

echo -e "\e[35m Downloading App Content\e[0m"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[35m Cleanup Old Content\e[0m"
rm -rf /app/* &>>${log}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[35m CleaExtracting App Content\e[0m"
cd /app &>>${log}
unzip /tmp/catalogue.zip &>>${log}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[35m Installing nodejs Dependencies\e[0m"
cd /app &>>${log}
npm install -g npm@9.2.0 &>>${log}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[35m Configuring catalogue service file\e[0m"
cp ${conf_file_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${log}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[35m Reload SystemD\e[0m"
systemctl daemon-reload &>>${log}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[35m Enable catalogue service\e[0m"
systemctl enable catalogue &>>${log}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi


echo -e "\e[35m start catalogue service\e[0m"
systemctl start catalogue &>>${log}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[35m Configuring mongo repos\e[0m"
cp ${conf_file_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[35m Installing mongo client\e[0m"
yum install mongodb-org-shell -y &>>${log}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi

echo -e "\e[35m load schema\e[0m"
mongo --host mongodb-dev.practicaldevops.online </app/schema/catalogue.js &>>${log}
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
exit
fi