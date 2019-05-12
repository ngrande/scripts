#!/bin/bash

# assuming you have rofi and cal

# show the calendar nicley in the top right corner

echo $(date '+%Y-%m-%d %H:%M:%S')

if [ "$BLOCK_BUTTON" == "1" ]; 
then
	cal | rofi \
		-dmenu \
		-lines 7 \
		-p "$(date +%A" - "%d".")" \
		-location 3 \
		-yoffset 20 \
		-width -22
fi
