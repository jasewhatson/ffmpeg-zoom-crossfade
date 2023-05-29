#!/bin/bash

find . -name '*.jpg' | while read line; do
     echo ${line:2}
     ffmpeg -y -threads 8 -nostdin -r 25 -i ${line:2} \
  -filter_complex \
    "scale=-2:10*ih, \
     zoompan=z='if(gte(zoom,1.5),1.5,zoom+0.001)':d=375:x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':s=1920x1080, \
     scale=-2:1080, \
     reverse" \
  -c:v libx264 -t 15 -pix_fmt yuv420p ${line:2}.mp4 &
done

wait 
echo "All done"

exit

#zoomout 15 secs
ffmpeg -nostdin -r 25 -i 1097098.jpg \
  -filter_complex \
    "scale=-2:10*ih, \
     zoompan=z='if(gte(zoom,1.5),1.5,zoom+0.001)':d=375:x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':s=1920x1080, \
     scale=-2:1080, \
     reverse" \
  -c:v libx264 -t 15 -pix_fmt yuv420p 1097098.mp4

# crossfade 3 secs between 2 videos
ffmpeg -i 1097098.mp4 -i output2.mp4 -i output-719833.mp4 \
  -filter_complex "[0:v][1:v]xfade=transition=fade:duration=3:offset=12" \
   -vcodec libx264 -pix_fmt yuv420p final_264.mp4
#15 + 12 - 3

   ffmpeg -i output2.mp4 -i output-719833.mp4  \
  -filter_complex "[0:v][1:v]xfade=transition=fade:duration=3:offset=12" \
   -vcodec libx264 -pix_fmt yuv420p step1.mp4 #27 secs

     ffmpeg -i step1.mp4 -i 1097098.mp4  \
  -filter_complex "[0:v][1:v]xfade=transition=fade:duration=3:offset=24" \
   -vcodec libx264 -pix_fmt yuv420p final_264_0.mp4 #27 - 3 = 24

   ###

count=0
find . -name '*.mp4' | while read line; do

  #increment the counter
  ((count++))

  #continue the loop if count is greater than 1
  if [ $count -eq 1 ]; then
    cp ${line:2} final_joined.mp4
    continue
  fi

  echo ${line:2}
     ffmpeg -i final_joined.mp4 -i ${line:2} \
  -filter_complex "[0:v][1:v]xfade=transition=fade:duration=3:offset=12" \
   -vcodec libx264 -pix_fmt yuv420p final_joined.mp4

done
   

 