#!/bin/bash

source config/zymp3.conf #get $INSTALLPATH variable from config

if [[ $EUID -ne 0 ]]; then
   echo "$0 : This script must be run as root" 
   exit 1
fi


if [ ! -d ${INSTALLPATH} ];then
  INSTALLDIR=0
else
  INSTALLDIR=1
fi

if [ ! -f /usr/bin/zymp3 ];then
  BINFILE=0
else
  BINFILE=1
fi

if [ ! -f /usr/share/applications/zymp3.desktop ];then
  DESKTOPFILE=0
else
  DESKTOPFILE=1
fi

COUNT=$(expr ${INSTALLDIR} + ${BINFILE} + ${DESKTOPFILE})

if [ "${COUNT}" = "3" ];then
  echo "Looks like zymp3 is still installed"
  echo -n "Would you like to remove all files?[y/n]: "
  read CHOICE
  
  if [ "${CHOICE}" = "y" ];then
    rm -v -R ${INSTALLPATH} && INSTALLDIR=0
    rm -v /usr/bin/zymp3 && BINFILE=0
    rm -v /usr/share/applications/zymp3.desktop && DESKTOPFILE=0
    
    COUNT=$(expr ${INSTALLDIR} + ${BINFILE} + ${DESKTOPFILE})
    
    if [ "${COUNT}" = "0" ];then
      echo "Zymp3 has been successfully is uninstalled"
    else
      echo "$COUNT"
      echo "It seems the uninstall did not go smoothly."
      echo "Please file a bug report at: https://github.com/silvernode/zymp3/issues"
    fi
  fi
else
  echo "Zymp3 is not installed, please run install.sh"
fi



