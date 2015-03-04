#!/bin/bash

source config/zymp3.conf

if [[ $EUID -eq 0 ]]; then
   echo "$0 : Do not run this script as root" 
   exit 1
fi

if [ -d .git ];then
  git pull
  if [ $? = 1 ];then
    echo "Git was unable to complete successfully."
  else
    echo "Please run 'install.sh' to apply updated files"
    
  fi
else
  echo "This is not a git repo, aborting"
  exit 0;
fi
