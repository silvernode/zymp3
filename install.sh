#!/bin/bash

source config/zymp3.conf

if [[ $EUID -ne 0 ]]; then
   echo "$0 : This script must be run as root" 
   exit 1
fi

#List of cuntions to check dependencies (will re-work this later)
checkYoutubedl(){

  if [ ! -f /usr/bin/youtube-dl ];then
    false
  else
    true
  fi
}


checkFfmpeg(){
  if [ ! -f /usr/bin/ffmpeg ];then
    false
  else
    true
  fi
}


checkZenity(){
  if [ ! -f /usr/bin/zenity ];then
    false
  else
    true
  fi

}

checkYad(){
  if [ ! -f /usr/bin/yad ];then
    false
  else
    true
  fi
}

checkXdg(){
  if [ ! -f /usr/bin/xdg-open ];then
    false
  else
    true
  fi
}

checkNotify(){
  if [ ! -f /usr/bin/notify-send ];then
    false
  else
    true
  fi
}

checkInstall(){
  if [ ! -d ${INSTALLPATH} ];then
    false
  else
    true
  fi
}


echo "Checking dependencies...";echo

#Check the status of each function
#each variable contains a number based on exit status of each function
checkYoutubedl
if [ $? -eq "1" ];then
  YSTATUS=0
  echo -e "is youtube-dl installed?: \e[31m no \033[0m"
else
  YSTATUS=1
  echo -e "is youtube-dl installed?: \e[32m yes \033[0m"
fi

checkFfmpeg
if [ $? -eq "1" ];then
  FSTATUS=0
  echo -e "is ffmpeg installed?: \e[31m no \033[0m"
else
  FSTATUS=1
  echo -e "is ffmpeg installed?: \e[32m yes \033[0m"
fi

checkZenity
if [ $? -eq "1" ];then
  ZSTATUS=0
  echo -e "is zenity installed?: \e[31m no \033[0m"
else
  ZSTATUS=1
  echo -e "is zenity installed?: \e[32m yes \033[0m"
fi
  
checkYad
if [ $? -eq "1" ];then
  YASTATUS=0
  echo -e "is yad install?: \e[31m no \033[0m"
else
  YASTATUS=1
  echo -e "is yad installed?: \e[32m yes \033[0m (Optional)"
fi

checkXdg
if [ $? -eq "1" ];then
  XSTATUS=0
  echo -e "is xdg-utils install?: \e[31m no \033[0m"
else
  XSTATUS=1
  echo -e "is xdg-utils installed?: \e[32m yes \033[0m"
fi


checkNotify
if [ $? -eq "1" ];then
  NSTATUS=0
  echo -e "is libnotify install?: \e[31m no \033[0m"
else
  NSTATUS=1
  echo -e "is libnotify installed?: \e[32m yes \033[0m"
fi


checkInstall
if [ $? -eq "1" ];then
  ISTATUS=0
  echo -e "does ${INSTALLPATH} exist?: \e[31m no \033[0m"
else
  ISTATUS=1
  echo -e "does ${INSTALLPATH} exist?: \e[32m yes \033[0m"
fi

if [ ${ISTATUS} = 0 ];then
  echo -n "${INSTALLPATH} does not exist, do you want to create it?[y/n]: "
  read answer
  if [ ${answer} = "y" ];then
    mkdir -v ${INSTALLPATH}
    ISTATUS=1
  else
    echo "$0 : ERROR: could not create ${INSTALLPATH}"
  fi
fi

#add all exit status variables and check the sum
#if a certain number is not reached, the check fails
#if the check succeeds, files are installed 
ALLSTATUS=$(expr ${YSTATUS} + ${FSTATUS} + ${ZSTATUS} + ${XSTATUS} + ${ISTATUS})

if [ ${ALLSTATUS} != 5 ];then
  echo "$0 : ERROR : not all dependencies installed!"
  exit 0;
else
  echo
  echo -e "\e[92mEverything looks good!\033[0m"
  echo
  echo -n "Continue installation?[y/n]: "
  read confirm

  if [ "${confirm}" = "y" ];then
    cp -v zymp3 ${INSTALLPATH}
    cp -v -R lib ${INSTALLPATH}
    cp -v -R config ${INSTALLPATH}
    cp -v uninstall.sh ${INSTALLPATH}
    cp -v assets/zymp3.png ${IMGDIR}
    cp -v assets/zymp3.desktop ${DESKTOPFILEDIR}
    echo '#!/bin/bash' > ${INSTALLPATH}/zymp3-run.sh
    echo "cd ${INSTALLPATH}" >> ${INSTALLPATH}/zymp3-run.sh 
    echo "./zymp3" >> ${INSTALLPATH}/zymp3-run.sh
    chmod -R 777 /opt/zymp3
    mv ${INSTALLPATH}/zymp3-run.sh /usr/bin/zymp3
    
    if [ ! -d ${INSTALLPATH} ];then
      echo "Zymp3 not installed successfully"
      echo "Please file a bug report at: https://github.com/silvernode/zymp3/issues"
    else
      echo "====================================================="
      echo -e "\e[92mZymp3 successfully installed to: ${INSTALLPATH}\033[0m"
      echo "An icon has been created in your application menu under the multimedia category."
    fi
  else
    echo "Installation cancelled..."
    exit 0;
  fi
  
fi



