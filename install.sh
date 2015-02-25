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
  echo "is youtube-dl installed?: no"
else
  YSTATUS=1
  echo "is youtube-dl installed?: yes"
fi

checkFfmpeg
if [ $? -eq "1" ];then
  FSTATUS=0
  echo "is ffmpeg installed?: no"
else
  FSTATUS=1
  echo "is ffmpeg installed?: yes"
fi

checkZenity
if [ $? -eq "1" ];then
  ZSTATUS=0
  echo "is zenity installed?: no"
else
  ZSTATUS=1
  echo "is zenity installed?: yes"
fi
  
checkYad
if [ $? -eq "1" ];then
  YASTATUS=0
  echo "is yad install?: no"
else
  YASTATUS=1
  echo "is yad installed?: yes"
fi

checkXdg
if [ $? -eq "1" ];then
  XSTATUS=0
  echo "is xdg-utils install?: no"
else
  XSTATUS=1
  echo "is xdg-utils installed?: yes"
fi


checkNotify
if [ $? -eq "1" ];then
  NSTATUS=0
  echo "is libnotify install?: no"
else
  NSTATUS=1
  echo "is libnotify installed?: yes"
fi


checkInstall
if [ $? -eq "1" ];then
  ISTATUS=0
  echo "does ${INSTALLPATH} exist?: no"
else
  ISTATUS=1
  echo "does ${INSTALLPATH} exist?: yes"
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
#TODO add checks to verify installation 
ALLSTATUS=$(expr ${YSTATUS} + ${FSTATUS} + ${ZSTATUS} + ${YASTATUS} + ${XSTATUS} + ${NSTATUS} + ${ISTATUS})

if [ ${ALLSTATUS} != 7 ];then
  echo "$0 : ERROR : not all dependencies installed!"
  exit 0;
else
  echo "Everything looks good!"
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
      echo "Zymp3 successfully installed to: ${INSTALLPATH}"
      echo "An icon has been created in your application menu under the multimedia category."
    fi
  else
    echo "Installation cancelled..."
    exit 0;
  fi
  
fi



