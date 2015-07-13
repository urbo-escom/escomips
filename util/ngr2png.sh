#!/bin/sh
#
# Convert Xilinx NGR files to png's by starting Xvfb
#
# Usage: ngr2png <ngr> <pinout-png> <full-png>
#

[ -z "$1" ] && echo "Usage: $0 <ngr> <pinout-png> <full-png>" && exit 1
[ -z "$2" ] && echo "Usage: $0 <ngr> <pinout-png> <full-png>" && exit 1
[ -z "$3" ] && echo "Usage: $0 <ngr> <pinout-png> <full-png>" && exit 1

set -o xtrace

dwm &
DWM_PID=$!
sleep 5

ise -open $1 &
ISE_PID=$!
if [ ! -z "${ISIM_SLEEP}" ]; then
	sleep ${ISIM_SLEEP}
else
	sleep 25
fi

delay=500
xdotool \
	key --delay ${delay} alt \
	key --delay ${delay} v \
	key --delay ${delay} a \
	key --delay ${delay} Tab \
	key --delay ${delay} Down \
	key --delay ${delay} Down \
	key --delay ${delay} Down \
	key --delay ${delay} Down \
	key --delay ${delay} Return \

import -display ${DISPLAY} -window root $2

xdotool \
	key --delay ${delay} ctrl+a \
	key --delay ${delay} alt \
	key --delay ${delay} e \
	key --delay ${delay} Up \
	key --delay ${delay} Up \
	key --delay ${delay} Up \
	key --delay ${delay} Up \
	key --delay ${delay} Right \
	key --delay ${delay} s \
	key --delay ${delay} F6 \

import -display ${DISPLAY} -window root $3

kill $ISE_PID
kill $DWM_PID
