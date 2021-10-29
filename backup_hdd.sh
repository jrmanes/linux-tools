#!/bin/bash
##########
#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
grayColour="\e[0;37m\033[1m"
##########
SOURCE_FOLDER_INPUT=$1
SOURCE_FOLDER="${SOURCE_FOLDER_INPUT:-/media/Cifrado}"
DEST_FOLDER_INPUT=$2
DEST_FOLDER="${DEST_FOLDER_INPUT:-/tmp/Cifrado}"

MODE=azrh
MODE_DEBUG=azvP
##########

clear

echo -e "${grayColour}[********************************************************************************]${endColour}"
echo -e "${blueColour}[INFO]${endColour} ${grayColour}Preparing Backup...${endColour} ${greenColour} $SOURCE_FOLDER ${endColour} into ${greenColour} $DEST_FOLDER ${endColour}"
echo -e "${grayColour}[********************************************************************************]${endColour}"

sleep 2

for i in $(ls $SOURCE_FOLDER);do
    echo -e "${blueColour}[INFO]${endColour} ${grayColour}Backing up folder:${endColour} ${yellowColour}$i${endColour} ${grayColour} => Size:${endColour} ${greenColour}$(du -sh $SOURCE_FOLDER/$i | cut -d'/' -f1)${endColour}"
    rsync -$MODE $SOURCE_FOLDER/$i $DEST_FOLDER/ &
done; wait

echo -e "${grayColour}[********************************************************************]${endColour}"
echo -e "${blueColour}[INFO]${endColour} ${grayColour}Total data:${endColour} ${greenColour}"
echo -e "${grayColour}[********************************************************************]${endColour}"
echo -e "${blueColour}[INFO]${endColour} ${grayColour}$(du -sh $SOURCE_FOLDER)${endColour} ${greenColour}"
echo -e "${blueColour}[INFO]${endColour} ${grayColour}$(du -sh $DEST_FOLDER)${endColour} ${greenColour}"
echo -e "${grayColour}[********************************************************************]${endColour}"
