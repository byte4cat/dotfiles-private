cam_addr="rtsp://neil1226:neil0315@192.168.100.101:554/stream1"
# nohup mpv --volume=${1:-100} "$cam_addr" >/dev/null 2>&1 &
# nohup ffplay -volume ${1:-100} "$cam_addr" >/dev/null 2>&1 &
nohup mpv --volume=0 "$cam_addr" >/dev/null 2>&1 &
