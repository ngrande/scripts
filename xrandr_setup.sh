#!/bin/bash

if [ $(xrandr --query | grep ' connected' | wc -l) -gt 3 ];
then
	# left is 1-2
	# right is 1-1
	xrandr --output eDP-1 --off
	xrandr --output DP-1-3 --auto --primary --rotate normal
	xrandr --output DP-1-1 --auto --right-of DP-1-3 --rotate right
	xrandr --output DP-1-2 --auto --left-of DP-1-3 --rotate normal
else
	dis=`xrandr | grep  "disconnected" | awk '{print $1}'`
	for d in $dis; do
		xrandr --output $d --off
		echo $d
	done
	xrandr --output eDP-1 --primary
fi

# in case the above mointors were not existing - we will setup every monitor we find
# this should cover it if we dock to different monitors!
for mon in $(xrandr --query | grep " connected" | awk '{print $1}')
do 
	xrandr --output $mon --auto
done


# reload the background, otherwise it is displayed awkardly on displays with
# another resolution
if [ -f ~/.fehbg ];
then
	~/.fehbg
fi

# this gets messed up
setxkbmap -layout de
