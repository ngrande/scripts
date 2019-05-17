#!/bin/bash
exp="vwd-archer"
if [ "$(hostname)" == "$exp" ]; then
	# this is a good config but it my right vertical monitor is then not centered
#	xrandr --output DVI-I-1 --primary
#	xrandr --output DP-2 --auto --right-of DVI-I-1 --rotate right
#	xrandr --output DP-3 --auto --left-of DVI-I-1

	# this is with fixed values, but then the right vertical monitor is centered
	# main monitor (middle)
	xrandr --output DVI-I-1 --auto --primary --pos 2560x240
	# right monitor vertical
	xrandr --output DP-2 --auto --rotate right --pos 5120x0
	# left monitor horizontal
	xrandr --output DP-3 --auto --pos 0x240
else
	echo "This script was made especially for '$exp'! Will not run here on: $(hostname)"
fi
