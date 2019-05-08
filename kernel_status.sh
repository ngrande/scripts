#!/bin/bash

# get the version part (like "5.0")
uname_r=$(uname -r | awk -F - '{print $1}')
kernel_vers=$(echo $uname_r | awk -F . '{print $1"."$2}')
if [ ${#uname_r} -gt 4 ]; then
	# append patch version (like "5.0.3")
	kernel_vers=$kernel_vers"."$(echo $uname_r | awk -F . '{print $3}')
fi

# get the rel part (like "arch1-1")
kernel_rel=$(uname -r | awk -F - '{print $2"-"$3}')
# combine both to compare to package name (like "5.0.arch1-1")
installed=$(pacman -Q linux | awk '{print $2}')

active=("$kernel_vers.$kernel_rel")

# first check if new kernel available for download
repo=$(pacman -Si linux | grep Version | awk '{print $3}')

if [ $installed != $repo ]; then
	echo "AVAILABLE"
elif [ $active != $installed ]; then
	echo "RESTART"
else
	echo "CURRENT"
fi
