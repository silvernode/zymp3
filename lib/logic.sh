#!/bin/bash

source config/zymp3.conf

if [ ! -f /usr/bin/yad ];then
  SET_GUI_BIN="zenity"
elif [ ! -f /usr/bin/zenity ];then
  SET_GUI_BIN="yad"
else
  SET_GUI_BIN="${SET_GUI_BIN}"
fi

if [ ! -f /usr/bin/ffmpeg ];then
  SET_CONV_TOOL="avconv"
else
  SET_CONV_TOOL="ffmpeg"
fi
#convert youtube videos to mp3 with zenity progess bar
backend()
{

  youtube-dl --output=${VIDEOFILE} --format=18 "$1" | ${SET_GUI_BIN} --progress \
  --pulsate --title="Downloading..." \
  --text="Downloading video, please wait.." --auto-close

  if [ ! -f $VIDEOFILE ];then
    ${SET_GUI_BIN} --error \
    --text "Can't convert video to mp3 because it does not exist, it probably failed to download."
    exit 0;

  elif [ -f $VIDEOFILE ];then
    ${SET_CONV_TOOL} -i $VIDEOFILE -acodec libmp3lame -ac 2 -ab 128k -vn -y "${CONVERTED}/$2" | ${SET_GUI_BIN} \
    --progress --pulsate --title="Converting..." \
    --text="Converting video to mp3.." --auto-close
    rm ${VIDEOFILE}

else
  echo -e "\e[1;31mERROR: It seems the video file successfully downloaded, however it was not converted to mp3 \e[0m"
  ${SET_GUI_BIN} --error \
  --text "It seems the video file successfully downloaded, however it was not converted to mp3"
fi
}


#first zenity gui window (paste youtube link)
gui()
{
  VIDURL=$(${SET_GUI_BIN} --title="Zymp3 0.1.7" \
  --height=${URL_BOX_HEIGHT} \
  --width=${URL_BOX_WIDTH} --entry  \
  --text "Paste youtube link here: ")


  if  [[ $? == 0 ]];then
    if [[ ${VIDURL} == *"https://www.youtube.com/watch?v="* ]];then
      gui2
    
    else
      ${SET_GUI_BIN} --error --text "Invalid URL"
    fi
   
  else
     exit 0;
    
  fi




}

#second gui window to name your mp3 file

gui2()
{
  AUDIOFILENAME=$(${SET_GUI_BIN} --title="Filename" \
  --height=${FILENAME_BOX_HEIGHT} \
  --width=${FILENAME_BOX_WIDTH} \
  --entry --text "Name your file: ")

  if [[ $? == 0 ]] ; then
    dconvert
  else
    exit 0;
  fi

}




#notify the user that the mp3 file has been moved to their music folder
open()
{


  if [[ $? == 0 ]] ; then
  xdg-open "${MUSICDIR}${AUDIOFILENAME}.mp3"
  else
    exit 0;
  fi


}

#Check if MUSICDIR exists and create the directory if not
#move the mp3 file to the users music directory
move()
{
  if [ -d ${MUSICDIR} ];then
    mv -v "${CONVERTED}/${AUDIOFILENAME}.mp3" ${MUSICDIR}
  elif [ ! -d ${MUSICDIR} ];then
    mkdir ${MUSICDIR}
    mv -v "${CONVERTED}/${AUDIOFILENAME}.mp3" ${MUSICDIR}
  
  fi


}

checkFile()
{

  #check if mp3 file exists
  if [ -f "${MUSICDIR}${AUDIOFILENAME}.mp3" ];then
    notify-send "${AUDIOFILENAME}.mp3 was saved in ${MUSICDIR}"
    ${SET_GUI_BIN} --question \
    --title="Hey!" \
    --text="I moved $AUDIOFILENAME.mp3 to $MUSICDIR, do you want to play it now?"

  elif [ ! -f "${MUSICDIR}${AUDIOFILENAME}.mp3" ];then
    ${SET_GUI_BIN} --error \
  --text "The mp3 file was does not exist. Either the download failed or the video was not converted to mp3 properly"
  fi

}


dconvert()
{

  #call backend function and pass video URL and input of mp3 file
  backend "${VIDURL}" "${AUDIOFILENAME}.mp3"

  #call the move function to send mp3 files to MUSICDIR
  move

  #check if mp3 file is in MUSICDIR before prompting to play
  checkFile


 
  open
}
