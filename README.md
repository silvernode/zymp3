
##Zymp3
####A frontend for youtube-dl and ffmpeg/avconv



###Dependencies  


* youtube-dl
* zenity
* yad (optional)
* xdg-utils
* libnotify (optional)
* ffmpeg or avconvert


###Install  

####Stable Release  
Copy and paste the following commands into your terminal all at once.
```
wget https://github.com/silvernode/zymp3/archive/v0.1.7.tar.gz && \
tar xvzf v0.1.7.tar.gz && \
cd zymp3-0.1.7 && \
sudo ./install.sh
```
Once completed, an icon will be added to your applications menu (if you have one)  
This command block will be updated ever new release
####git
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

###Updating  

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

###Uninstall  

To uninstall run the uninstall script located in the repo or the installation directory: 

```
./uninstall.sh
```

Please submit any issues you find, thanks
