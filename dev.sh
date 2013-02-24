#!/bin/bash

t=$(zenity --entry --title="test" --text="name the file: "); zenity --file-selection --save --text="$t" --confirm-overwrite

#$t | 
zenity --file-selection --save --confirm-overwrite