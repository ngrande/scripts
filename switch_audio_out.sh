#!/bin/bash

analog_name="ANALOG"
usb_name="USB"

# hard coded - bit tricky to get these values dynamically
usb="usb-Logitech_Inc._Logitech_USB_Headset_H340-00.iec958-stereo"
analog="pci-0000_00_1b.0.analog-stereo"

active=$(pacmd list-sinks | grep "RUNNING" -B3 | grep "name:" | awk '{print $2}')

toggle_out=0
active_name=""
toggle_name=""

if [ "$active" == "<alsa_output.$usb>" ]; then
	toggle_out=$analog
	active_name=$usb_name
	toggle_name=$analog_name
elif [ "$active" == "<alsa_output.$analog>" ]; then
	toggle_out=$usb
	active_name=$analog_name
	toggle_name=$usb_name
fi



# script to toggle output between USB logitech and Analog Headphone
if [ "$1" != "1" ]; then
	echo $active_name
	exit 0
fi

# first get the active
#echo $active


if [ $toggle_out == 0 ]; then
	# could not determine current state
	echo "ERROR"
else
	echo $toggle_name
	# magic 20?
	cmd="pactl move-sink-input 20 alsa_output.$toggle_out"
	eval $cmd
fi
