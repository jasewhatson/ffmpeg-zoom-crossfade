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

#ChatGTP refactor 

vidlen=15
transitionduration=3
offset=0

inputs=()
filters=()
count=0
for f in *.mp4; do
  inputs+=("-i $f")
  if [ "$count" -gt 0 ]; then
    filters+=("[${count}:v][${count}a][0:v][0:a]xfade=transition=fade:duration=${transitionduration}:offset=${offset}[v$count][a$count];")
    offset=$((offset + vidlen - transitionduration))
  fi
  ((count++))
done

filterchain=$(printf "%s" "${filters[@]}")
filterchain+="[${count}:v][${count}a]concat=n=${count}:v=1:a=1[v][a]"

ffmpeg ${inputs[@]} -filter_complex "$filterchain" -map "[v]" -map "[a]" -vcodec libx264 -pix_fmt yuv420p output.mp4