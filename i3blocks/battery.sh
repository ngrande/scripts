#!/bin/bash

# get the battery status and show it with some nice awesome fonts!

# just using the i3blocks script...

#                     head -> full text
bat=$(/usr/lib/i3blocks/battery | head -n 1)

perc=$(echo $bat | awk -F "%" '{print $1}')
symbol=" "

if [ $perc -gt 90 ];
then
	symbol=" "
elif [ $perc -gt 75 ];
then
	symbol=" "
elif [ $perc -gt 50 ];
then
	symbol=" "
elif [ $perc -gt 10 ];
then
	symbol=" "
fi

echo "${symbol} ${bat}"