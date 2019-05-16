#!/bin/bash

# using PulseAudio to control the volume

delta=5
signal=$1
dev=$2 # sink or source
action=$3
amixer_dev=""

case "$BLOCK_BUTTON" in
	"1")
		action="up"
		;;
	"3")
		action="down"
		;;
	"2")
		action="mute"
		;;
esac

case "$dev" in
	"source")
		amixer_dev="Capture"
		;;
	"sink")
		amixer_dev="Master"
		;;
	*)
		echo "invalid 2nd parameter!"
		exit 1
		;;
esac

get_volume() {
	# just get the last line...
	line=$(amixer get $amixer_dev | tail -n 1)
	if [[ $line =~ \[off\] ]];
	then
		echo "MUTE"
	else
		echo $(echo $line | awk -F "%" '{print $1}' | awk -F "[" '{print $2"%"}') # | head -c -2 | tail -c +2)
	fi
}

toggle() {
	amixer set ${amixer_dev} toggle &>/dev/null
}

toggle_if_mute() {
	if [ "$(get_volume)" == "MUTE" ];
	then
		toggle
	fi
}

case "$action" in
	"up")
		amixer set ${amixer_dev} ${delta}%+ &>/dev/null
		;;
	"down")
		amixer set ${amixer_dev} ${delta}%- &>/dev/null
		;;
	"mute")
		toggle
		;;
	"show")
		get_volume
		;;
esac

# if user changes volume of device but it's muted - we toggle it
case "$action" in
	"up" | "down")
		toggle_if_mute
	;;
esac

get_volume

pkill -SIGRTMIN+$signal i3blocks
