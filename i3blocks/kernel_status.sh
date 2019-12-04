#!/bin/bash

# script for i3blocks assumes you have arch linux running
# hope you have rofi installed...

if [ "$BLOCK_BUTTON" == "1" ]; then

	repo=$(pacman -Si linux | grep -i version | awk '{print $3}')
	inst=$(pacman -Q linux | awk '{print $2}')
	curr=$(uname -r)
	curr=${curr%"-ARCH"}
	echo -e "Repo: $repo\nInst: $inst\nCurr: $curr" | rofi -dmenu -lines 3 -hide-scrollbar -p "Kernel" -width -30 -a 2 &> /dev/null
	# we are done, return from here
	return

fi

active_short=$(uname -r | awk -F ".arch" '{print $1}')
active_long=$(uname -r | awk -F "-arch" '{print $1".arch"$2}')
# combine both to compare to package name (like "5.0.arch1-1")
installed=$(pacman -Q linux | awk '{print $2}')

# first check if new kernel available for download
repo=$(pacman -Si linux | grep Version | awk '{print $3}')

if [ $installed != $repo ]; then
	echo "AVAILABLE"
elif [ $active_short != $installed ] && [ $active_long != $installed ]; then
	echo "RESTART"
else
	echo "CURRENT"
fi
