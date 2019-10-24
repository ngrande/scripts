#!/bin/bash

# get the battery status and show it with some nice awesome fonts!

# just using the i3blocks script...

#                     head -> full text
bat=$(/usr/lib/i3blocks/battery/battery | head -n 1)
if [ $? -ne 0 ];
then
	exit $?
elif [ "$bat" == "" ];
then
	exit 127
fi

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
