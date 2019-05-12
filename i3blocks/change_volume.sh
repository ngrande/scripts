#!/bin/bash

# using PulseAudio to control the volume

delta=5
signal=$1

case "$2" in
	"up")
		pactl set-sink-volume 0 +${delta}%
		;;
	"down")
		pactl set-sink-volume 0 -${delta}%
		;;
	"mute")
		pactl set-sink-mute 0 toggle
		;;
esac

pkill -SIGRTMIN+$signal i3blocks
