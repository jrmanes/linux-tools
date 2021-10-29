#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
grayColour="\e[0;37m\033[1m"

SOURCE_FOLDER_INPUT=$1
SOURCE_FOLDER="${SOURCE_FOLDER_INPUT:-/media/Cifrado}"
DEST_FOLDER_INPUT=$2
DEST_FOLDER="${DEST_FOLDER_INPUT:-/tmp/Cifrado}"

MODE=azh
MODE_DEBUG=azvP

EXCLUSSIONS_INPUT=$3
DEFAULT_EXCLUSSIONS="Program*|System*"
EXCLUSSIONS="${EXCLUSSIONS_INPUT:-$DEFAULT_EXCLUSSIONS}"

TOTAL_FOLDERS_TO_BACKUP=$(ls $SOURCE_FOLDER | grep -Ev ${EXCLUSSIONS} | wc -l)
COUNTER=1

trap ctrl_c INT

function ctrl_c(){
	echo -e "\n${yellowColour}[*]${endColour}${grayColour} Exiting...${endColour}"; sleep 1
	exit 1
}

echo -e "${blueColour}[INFO]${endColour} ${grayColour}[***********************************************************] ${endColour}"
echo -e "${blueColour}[INFO]${endColour} ${grayColour}Preparing Backup...${endColour}"
echo -e "${blueColour}[INFO]${endColour} ${grayColour}Source Folder:${endColour} ${greenColour}$SOURCE_FOLDER ${endColour}"
echo -e "${blueColour}[INFO]${endColour} ${grayColour}Dest Folder:${endColour} ${greenColour}$DEST_FOLDER ${endColour}"
echo -e "${blueColour}[INFO]${endColour} ${grayColour}Exclussions to apply:${endColour} ${greenColour}$EXCLUSSIONS ${endColour}"
echo -e "${blueColour}[INFO]${endColour} ${grayColour}Total folders to backup:${endColour} ${greenColour} ${TOTAL_FOLDERS_TO_BACKUP} ${endColour}"
echo -e "${blueColour}[INFO]${endColour} ${grayColour}[***********************************************************] ${endColour}"

sleep 2

for i in $(ls $SOURCE_FOLDER | grep -Ev ${EXCLUSSIONS});do
    TMP_FOLDER=`echo $SOURCE_FOLDER/$i`
    echo -e "${blueColour}[INFO]${endColour} ${grayColour}Backing up:${endColour} ${yellowColour}$i${endColour} ${grayColour}=> Size=${endColour} ${greenColour}$(du -sh ${TMP_FOLDER} | cut -d'/' -f1) ${endColour} ${grayColour}- Folder${endColour}${greenColour} ${yellowColour}${COUNTER}${endColour}/${greenColour}${TOTAL_FOLDERS_TO_BACKUP} ${endColour}"
    rsync -$MODE $SOURCE_FOLDER/$i $DEST_FOLDER/ &
    COUNTER=$(( COUNTER + 1 ))
done; wait

echo -e "${grayColour}[********************************************************************]${endColour}"
echo -e "${blueColour}[INFO]${endColour} ${grayColour}Total data:${endColour} ${greenColour}"
echo -e "${grayColour}[********************************************************************]${endColour}"
echo -e "${blueColour}[INFO]${endColour} ${grayColour}$(du -sh $SOURCE_FOLDER)${endColour} ${greenColour}"
echo -e "${blueColour}[INFO]${endColour} ${grayColour}$(du -sh $DEST_FOLDER)${endColour} ${greenColour}"
echo -e "${grayColour}[********************************************************************]${endColour}"
