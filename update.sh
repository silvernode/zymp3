#!/bin/bash

if [[ $EUID -eq 0 ]]; then
   echo "$0 : Do not run this script as root" 
   exit 1
fi

if [ -d .git ];then
  git pull
else
  echo "This is not a git repo, aborting"
  exit 0;
fi
