#!/bin/bash
VIDEO_NAME=$1

echo "Video to convert: $VIDEO_NAME"

ffmpeg -i $VIDEO_NAME -vcodec mpeg4 -acodec mp3 ./$VIDEO_NAME.avi
