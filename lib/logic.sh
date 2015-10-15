#!/bin/bash

source config/zymp3.conf

#Codec format of audio file
#libmp3lame (mp3), libvorbis (ogg), flac (flac)
CODEC="" #this gets set in he 'changeCodec' function

#CHECK FOR YAD OR ZENITY AND DEFAULT TO ONE
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

changeCodec(){
  if [ "${EXTENSION}" = "ogg" ];then
    CODEC="libvorbis"
  elif [ "${EXTENSION}" = "mp3" ];then
    CODEC="libmp3lame"
  elif [ "${EXTENSION}" = "flac" ];then
    CODEC="flac"
  fi
}

#PROGRESS BAR
backend()
{

  youtube-dl \
  --output=${VIDEOFILE} --format=18 "$1" | ${SET_GUI_BIN}\
  --progress \
  --pulsate --title="Downloading..." \
  --text="Downloading video, please wait.." --auto-close

  if [[ $? == 1 ]];then
    exit 0;
  fi

  if [ "${USE_FILE_BROWSER}" = "no" ];then
    if [ ! -f $VIDEOFILE ];then
      ${SET_GUI_BIN} \
      --error \
      --text "Can't convert video because it does not exist,
      it probably failed to download."
      exit 0;

    elif [ -f $VIDEOFILE ];then
      changeCodec
      ${SET_CONV_TOOL} -i $VIDEOFILE -acodec ${CODEC} -ac 2 -ab ${BITRATE}k \
       -vn -y "${CONVERTED}/$2" | ${SET_GUI_BIN} \
      --progress\
      --pulsate\
      --title="Converting..." \
      --text="Converting video.."\
      --auto-close
      if [[ $? != 0 ]];then
        exit 0;
      fi

      rm ${VIDEOFILE}

    else
      echo -e "\e[1;31mERROR: It seems the video file successfully downloaded,
              however it was not converted \e[0m"

      ${SET_GUI_BIN}\
       --error \
       --text "It seems the video file successfully downloaded,
              however it was not converted."
    fi

  else
    if [ ! -f $VIDEOFILE ];then
      ${SET_GUI_BIN}\
       --error \
       --text "Can't convert video because it does not exist,
               it probably failed to download."
      exit 0;

    elif [ -f $VIDEOFILE ];then
      ${SET_CONV_TOOL}\
      -i $VIDEOFILE\
      -acodec ${CODEC}\
      -ac 2 -ab ${BITRATE}k\
      -vn -y "$2" | ${SET_GUI_BIN} \
      --progress\
      --pulsate\
      --title="Converting..." \
      --text="Converting video.."\
      --auto-close

      if [[ $? != 0 ]];then
        exit 0;
      fi
      rm ${VIDEOFILE}

    else
      echo -e\
       "\e[1;31mERROR: It seems the video file successfully downloaded,
       however it was not converted \e[0m"

      ${SET_GUI_BIN} --error \
      --text "It seems the video file successfully downloaded,
      however it was not converted"
    fi
  fi

}


#PASTE YOUTUBE LINK - WINDOW
gui()
{
  VIDURL=$(${SET_GUI_BIN} --title="Zymp3 0.1.7" \
  --height=${URL_BOX_HEIGHT} \
  --width=${URL_BOX_WIDTH}\
  --entry  \
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



#ENTER MP3 FILE NAME OR OPEN FILEBROWSER
#CAN BE SWITCHED IN CONFIG

gui2()
{

  if [ "${USE_FILE_BROWSER}" = "no" ];then
    AUDIOFILENAME=$(${SET_GUI_BIN} --title="Filename" \
    --height=${FILENAME_BOX_HEIGHT} \
    --width=${FILENAME_BOX_WIDTH} \
    --entry --text "Name your file: ")

    if [[ $? == 0 ]];then
      dconvert
    else
      exit 0;
    fi

  else
    FILEBROWSER=$(zenity --file-selection --directory \
    --title= "Where to save mp3 file? " \
    --filename=/home/$USER/Music/ \
    --file-filter='
     MP3 files (mp3) | *.mp3',
    'OGG files (ogg) | *.ogg',
    'FLAC (flac) | *.flac' \
    --save --confirm-overwrite)

    if [[ $? == 0 ]];then
      dconvert
    else
      exit 0;
    fi
  fi

}




#CHECK IF FILEBROWSER VAR IS SET
#IF NOT SET, DEFAULT TO MANUAL TO {MUSICDIR}
open()
{

  if [ "${USE_FILE_BROWSER}" = "no" ];then
    if [[ $? == 0 ]];then
    xdg-open "${MUSICDIR}${AUDIOFILENAME}.${EXTENSION}"
    else
      exit 0;
    fi

  else
    if [[ $? == 0 ]];then
      xdg-open "${FILEBROWSER}"
    else
      exit 0;
    fi

  fi


}

#MOVE MP3 FILE TO MUSICDIR
#IF MUSICDIR DOES NOT EXIST, CREATE IT
move()
{
  if [ "${USE_FILE_BROWSER}" = "no" ];then
    if [ -d "${MUSICDIR}" ];then
      mv -v "${CONVERTED}/${AUDIOFILENAME}.${EXTENSION}" "${MUSICDIR}"
    elif [ ! -d "${MUSICDIR}" ];then
      mkdir "${MUSICDIR}"
      mv -v "${CONVERTED}/${AUDIOFILENAME}.${EXTENSION}" "${MUSICDIR}"

    fi


  fi
}


#CHECK IF MP3 FILE EXISTS
checkFile()
{

  if [ "${USE_FILE_BROWSER}" = "no" ];then
    if [ -f "${MUSICDIR}${AUDIOFILENAME}.${EXTENSION}" ];then
      notify-send "${AUDIOFILENAME}.${EXTENSION} was saved in ${MUSICDIR}"
      ${SET_GUI_BIN} --question \
      --title="Hey!" \
      --text="I moved $AUDIOFILENAME.${EXTENSION} to $MUSICDIR, play it now?"
      if [[ $? != 0 ]];then
        exit 0;
      fi

    elif [ ! -f "${MUSICDIR}${AUDIOFILENAME}.${EXTENSION}" ];then
      ${SET_GUI_BIN} --error \
      --text\
       "The mp3 file was does not exist. Either the download failed or
      the video was not converted to mp3 properly"
    fi

  else
    if [ -f "${FILEBROWSER}.${EXTENSION}" ];then
      notify-send "${FILEBROWSER}.${EXTENSION} was saved"
      ${SET_GUI_BIN} --question \
      --title="Hey!" \
      --text="${FILEBROWSER}.${EXTENSION} was saved, play it now?"
      if [[ $? == 0 ]];then
        open
      else
        exit 0;
      fi

    elif [ ! -f "${FILEBROWSER}.${EXTENSION}" ];then
      ${SET_GUI_BIN} --error \
      --text\
       "The converted file does not exist. Either the download
      failed or the video was not converted properly"
    fi
  fi


}


dconvert()
{

  #PASS VIDEO URL AND FILENAME.MP3 TO BACKEND FUNCTION
  if [ "${USE_FILE_BROWSER}" = "no" ];then
    backend "${VIDURL}" "${AUDIOFILENAME}.${EXTENSION}"
    move
    checkFile
    open


  else
    backend "${VIDURL}" "${FILEBROWSER}.${EXTENSION}"
    checkFile
  fi




}
