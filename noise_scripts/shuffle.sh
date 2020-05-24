# Nikhil Saini
# IIT Bombay

# Shuffle two parallel files
# Usage : ./shuffle.sh src.txt tgt.txt
#! /bin/bash

mkfifo onerandom tworandom
tee onerandom tworandom < /dev/urandom > /dev/null &
shuf --random-source=onerandom $1 > $1.shuf &
shuf --random-source=tworandom $2 > $2.shuf &
wait
echo "Shuffle complete"
