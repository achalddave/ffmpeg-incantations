#!/bin/bash
# Scale a directory of videos so the max dimension is below a certain size.

set -e

max_size=720
for i in *.mp4 ; do
  w=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of csv=s=x:p=0 ${i})
  h=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=s=x:p=0 ${i})
  if [[ $w -gt $max_size ]] && [[ $h -gt $max_size ]] ; then
    # We can't use "force_original_aspect_ratio" like here:
    # https://stackoverflow.com/a/42024302 because it results in output sizes
    # not divisible by 2, which causes some formats to choke.
    # Instead, we use this: https://stackoverflow.com/a/23662884
    ffmpeg -i ${i} -vf "scale='if(gt(iw,ih),${max_size},trunc(oh*a/2)*2)':'if(gt(iw,ih),trunc(ow/a/2)*2,${max_size})" ${i%.mp4}_reduced.mp4
  fi
done
