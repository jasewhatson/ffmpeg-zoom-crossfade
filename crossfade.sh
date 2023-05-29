#!/bin/bash

vidlen=15
transitionduration=3
offset=0

count=0
find . -name '*.mp4' | while read line; do

  #increment the counter
  ((count++))

  #Copy the first video into place. Then continue the loop to the next videos
  if [ $count -eq 1 ]; then
    cp ${line:2} final_joined_1.mp4
    continue
  fi

  prev=$((count - 1))

  offset=$((offset + (vidlen - transitionduration))) #Calc new offset from pervious offset

  ffmpeg -i final_joined_${prev}.mp4 -i ${line:2} \
  -filter_complex "[0:v][1:v]xfade=transition=fade:duration=3:offset=${offset}" \
  -vcodec libx264 -pix_fmt yuv420p final_joined_${count}.mp4 < /dev/null;

   rm final_joined_${prev}.mp4

done