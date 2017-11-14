#!/bin/bash
bold=$(tput bold)
normal=$(tput sgr0)
installed=$(pacman -Q linux | awk '{print $2}')
active=$(uname -r | awk -F - '{print $1"-"$2}')

if [ $active != $installed ]; then
	echo "${bold}you have a newer kernel version installed ($installed) - please restart your machine${normal}"
fi
