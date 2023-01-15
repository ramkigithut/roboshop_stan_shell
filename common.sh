#!/usr/bin/env bash
conf_file_location=$(pwd)
log=/tmp/roboshop.log

status_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[1;32msuccess\e[0m"
  else
    echo -e "\e[1;31mfailure\e[0m"
    echo "Refer log file for more information, log is at ${log}"
    exit
  fi
}

print_head() {
  echo -e "\e[1; $1 \e[0m"
}

app_prerequisites() {

  print_head "Add Application user"
  id roboshop &>>${log}
  if [ $? -ne 0 ]; then
    useradd roboshop &>>${log}
  fi
  status_check

  mkdir -p /app &>>${log}

  print_head "Downloading App Content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
  status_check

  print_head "Cleanup Old Content"
  rm -rf /app/* &>>${log}
  status_check

  print_head "CleaExtracting App Content"
  cd /app &>>${log}
  unzip /tmp/${component}.zip &>>${log}
  status_check

}

systemd_setup() {


  print_head "Configuring ${component} service file"
  cp ${conf_file_location}/files/${component}.service /etc/systemd/system/${component}.service &>>${log}
  status_check

  print_head "Reload SystemD"
  systemctl daemon-reload &>>${log}
  status_check


  print_head "Enable ${component} service"
  systemctl enable ${component} &>>${log}
  status_check


  print_head "start ${component} service"
  systemctl start ${component} &>>${log}
  status_check


}

load_schema() {

  if [ ${schema_load} == "true" ]; then
    print_head "Configuring mongo repos"
    cp ${conf_file_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${log}
    status_check

    print_head "Installing mongo client"
    yum install mongodb-org-shell -y &>>${log}
    status_check

    print_head "load schema"
    mongo --host mongodb-dev.practicaldevops.online </app/schema/${component}.js &>>${log}
    status_check
  fi
}

NODEJS() {

  print_head "Configuring nodejs repos"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
  status_check

  print_head "Install nodejs"
  yum install nodejs -y &>>${log}
  status_check

  app_prerequisites

  print_head "Installing nodejs Dependencies"
  cd /app &>>${log}
  npm install &>>${log}
  status_check

  systemd_setup

  load_schema

}

MAVEN() {

  print_head "Install Maven"
  yum install maven -y &>>${log}
  status_check

  app_prerequisites

  print_head "Build a Package"
  mvn clean package
  status_check

  print_head "Copy App file to APP Location"
  mv target/${component}-1.0.jar shipping.jar
  status_check

  systemd_setup

  load_schema

}