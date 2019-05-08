#!/bin/bash
exp="vwd-archer"
if [ "$(hostname)" == "$exp" ]; then
	xrandr --output DVI-I-1 --primary
	xrandr --output DP-2 --auto --right-of DVI-I-1
	xrandr --output DP-3 --auto --left-of DVI-I-1
	xrandr --output DB-2 --rotate right
else
	echo "This script was made especially for '$exp'! Will not run here on: $(hostname)"
fi
