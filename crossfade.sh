#!/bin/bash

# ffmpeg \
# -vsync 0 \
# -i 0.mp4 \
# -i 1.mp4 \
# -i 2.mp4 \
# -filter_complex "[0:v]settb=AVTB[0v];[1:v]settb=AVTB[1v];[2:v]settb=AVTB[2v];[0v][1v]xfade=transition=fade:duration=3:offset=12[v1];[v1][2v]xfade=transition=fade:duration=3:offset=24,format=yuv420p[video]" \
# -b:v 10M \
# -map "[video]" \
# outxx.mp4

# ffmpeg -vsync 0 -i 0.mp4 -i 1.mp4 -i 2.mp4 -filter_complex "[0:v]settb=AVTB[0v];[1:v]settb=AVTB[1v];[2:v]settb=AVTB[2v];[0v][1v]xfade=transition=fade:duration=3:offset=12[v1];[v1][2v]xfade=transition=fade:duration=3:offset=24,format=yuv420p[video]" -b:v 10M -map "[video]" outxx.mp4
# ffmpeg -vsync 0 -i 0.mp4 -i 1.mp4 -i 2.mp4 -filter_complex "[0:v]settb=AVTB[0v];[1:v]settb=AVTB[1v];[2:v]settb=AVTB[2v];[0v][1v]xfade=transition=fade:duration=3:offset=12[v1];[1v][2v]xfade=transition=fade:duration=3:offset=24,format=yuv420p[video]" -b:v 10M -map "[video]" outxx.mp4
# ffmpeg -vsync 0 -i 0.mp4 -i 1.mp4 -i 2.mp4 -filter_complex "[0:v]settb=AVTB[0v];[1:v]settb=AVTB[1v];[2:v]settb=AVTB[2v];[0v][1v]xfade=transition=fade:duration=3:offset=12[v1];[v1][2v]xfade=transition=fade:duration=3:offset=24,format=yuv420p[video]" -b:v 10M -map "[video]" outxx.mp4
# ffmpeg \
# -vsync 0 \
# -i 0.mp4 \
# -i 1.mp4 \
# -i 2.mp4 \
# -filter_complex "[0:v]settb=AVTB[0v];[1:v]settb=AVTB[1v];[2:v]settb=AVTB[2v];[0v][1v]xfade=transition=fade:duration=3:offset=12[v1];[1v][2v]xfade=transition=fade:duration=3:offset=24,format=yuv420p[video]" \
# -b:v 10M \
# -map "[video]" \
# outxx.mp4

# Get a list of all MP4 files in the current directory, excluding "outxx.mp4"
files=()
for file in *.mp4; do
  if [ "$file" != "outxx.mp4" ]; then
    files+=("$file")
  fi
done

# Create the ffmpeg command
ffmpeg_command="ffmpeg -vsync 0"

# Iterate over the files and append input arguments to the ffmpeg command
for ((i=0; i<${#files[@]}; i++)); do
  ffmpeg_command+=" -i ${files[i]}"
done

# Add the filter_complex argument to the ffmpeg command
ffmpeg_command+=" -filter_complex \""

for ((i=0; i<${#files[@]}; i++)); do
  ffmpeg_command+="[${i}:v]settb=AVTB[${i}v];"
done

for ((i=0; i<${#files[@]}-1; i++)); do
  if ((i != ${#files[@]}-2)); then
    ffmpeg_command+="[${i}v][$(($i+1))v]xfade=transition=fade:duration=3:offset=$((12*(i+1)))[v$(($i+1))];"
  else
    ffmpeg_command+="[v$(($i))][$(($i+1))v]xfade=transition=fade:duration=3:offset=$((12*(${#files[@]}-1))),format=yuv420p[video]\""
  fi
done

ffmpeg_command+=" -b:v 10M -map \"[video]\" outxx.mp4"

# Print the ffmpeg command
echo "$ffmpeg_command"



