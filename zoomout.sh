#!/bin/bash

#Make sure files end in .jpg and there is no spaces in the file names

# Set your desired resolution here
resolution_width=1920
resolution_height=1080

# Set your video length here
video_length=15

find . -name '*.jpg' | while read line; do
  echo ${line:2}
  ffmpeg -y -threads 8 -nostdin -r 25 -i ${line:2} \
  -filter_complex \
  "scale=-2:10*ih, \
  zoompan=z='if(gte(zoom,1.5),1.5,zoom+0.001)':d=$((25 * $video_length)):x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':s=${resolution_width}x${resolution_height}, \
  scale=-2:$resolution_height, \
  reverse" \
  -c:v libx264 -t $video_length -pix_fmt yuv420p ${line:2}.mp4
done

wait
echo "All done"
