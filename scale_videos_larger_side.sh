# Scale a directory of videos to be at most of a certain dimension.

max_size=720
for i in *.mp4 ; do
  w=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of csv=s=x:p=0 ${i})
  h=$(ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=s=x:p=0 ${i})
  if [[ $w -gt $max_size ]] && [[ $h -gt $max_size ]] ; then
    # https://stackoverflow.com/a/42024302
    ffmpeg -i ${i} -vf "scale=$max_size:$max_size:force_original_aspect_ratio=decrease" ${i%.mp4}_reduced.mp4
  fi
done
