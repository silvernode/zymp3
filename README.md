
## Zymp3
### A frontend for youtube-dl and ffmpeg/avconv



### Dependencies  


* youtube-dl (required)
* zenity (required)
* yad (optional)
* xdg-utils (required)
* libnotify (optional)
* ffmpeg or avconvert (required)


## Install  

#### Easy Copy Pasta  

Copy and paste the following commands into your terminal all at once.
```
wget https://github.com/silvernode/zymp3/archive/v0.1.7.tar.gz && \
tar xvzf v0.1.7.tar.gz && \
cd zymp3-0.1.7 && \
sudo ./install.sh
```
Once completed, an icon will be added to your applications menu (if you have one)  
This command block will be updated every new release  

### Install from Master  

Install git from your distribution repository  
for Ubuntu run:  
```
sudo apt-get install git
```

Next, use git to make a clone of this repository  
This will download a copy of the repository into a directory named "zymp3":  

```
git clone https://github.com/silvernode/zymp3.git
```
Change to the new directory  
```
cd zymp3
```

Then run the installer script:
  
```
./install.sh
```

### Updating  

To update to a new version, first change to the repo directory:  
```
cd zymp3
```
then run the pull command:
```
git pull
```
This will merge any changes that have been made to files and put you up to date.  
Alternatively you can run the update script (which just runs git pull)  
I added this in case you have a bad memory.  
```
./update.sh
```

### Uninstall  

To uninstall run the uninstall script located in the repo or the installation directory: 

```
./uninstall.sh
```

### Config  

A config file can be found in:  

#### /opt/zymp3/config  

------------------------

```  
#!/bin/bash
#config.sh

# Zymp3 Configuration File

# FILE PATHS

# choose your own install path
INSTALLPATH="/opt/zymp3"

# You can change this but icon may not appear
IMGDIR="/usr/share/pixmaps"

# Desktop icon directory ( default recommended)
DESKTOPFILEDIR="/usr/share/applications"

# Default gui - switch between zenity or yad
SET_GUI_BIN="yad"

# ogg, mp3, flac
EXTENSION="ogg"


# 96 - 320 (kilobytes)
BITRATE="192"


# Output directory for audio files
# must have a trailing slash /
MUSICDIR="/home/$USER/Music/"

# VIDEO TMP DIRECTORY

# You shouldn't need to change this but you can
VIDEOFILE=/tmp/youtube-dl-$RANDOM-$RANDOM.flv
CONVERTED=/tmp

# USE FILEBROWSER TO NAME AND SAVE MP3

USE_FILE_BROWSER="no" #options- yes, no

# GUI SETTINGS

# Change dimensions of the URL and filename dialogs
URL_BOX_HEIGHT="64"

URL_BOX_WIDTH="512"

FILENAME_BOX_HEIGHT="64"

FILENAME_BOX_WIDTH="326"
```  
-----------------
Please submit any issues you find, thanks
