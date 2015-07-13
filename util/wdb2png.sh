#!/bin/sh
#
# Convert Xilinx WDB files to PNG
#
# Usage: wdb2png <ngr> <waveform-png>
#

[ -z "$1" ] && echo "Usage: $0 <ngr> <waveform-png>" && exit 1
[ -z "$2" ] && echo "Usage: $0 <ngr> <waveform-png>" && exit 1

set -o xtrace

dwm &
DWM_PID=$!
sleep 5

isimgui -view $1 &
ISIM_PID=$!
if [ ! -z "${ISIM_SLEEP}" ]; then
	sleep ${ISIM_SLEEP}
else
	sleep 25
fi

import -display ${DISPLAY} -window root $2

kill $ISIM_PID
kill $DWM_PID
