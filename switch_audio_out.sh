#!/bin/bash

# script to toggle output between USB logitech and Analog Headphone

# show the user what's set up
echo "This is currently set:"
echo ""
echo "+++++++++++++"
echo ""
pactl info
echo ""
echo "+++++++++++++"
echo "Switching now..."

# hard coded - bit tricky to get these values dynamically
usb="usb-Logitech_Inc._Logitech_USB_Headset_H340-00.iec958-stereo"
analog="pci-0000_00_1b.0.analog-stereo"

echo "[1] <ENTER>: $usb"
echo "[2]: $analog"
echo ""
echo ""
echo "Choose audio output: "
read choice

chosen_out=$usb
if [ "$choice" == "2" ]; then
	chosen_out=$analog
fi

# magic 20?
cmd="pactl move-sink-input 20 alsa_output.$chosen_out"
echo $cmd
eval $cmd
