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