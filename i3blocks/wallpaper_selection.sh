#!/bin/bash

# assume you have feh installed

if [ "$BLOCK_BUTTON" == "1" ];
then
	walldir=$1"/"

	pictures=$(ls ${walldir} | grep -E "*\.(jpg|png)")
	lines=$(echo  "$pictures" | wc --lines)

	# find the currently set wallpaper (index)
	current_ind=""
	if [ -f ~/.fehbg ];
	then
		current=$(cat ~/.fehbg | awk '{print $3}' | xargs basename)

		ind=0
		for f in $pictures;
		do
			if [[ $current =~ $f ]]; then current_ind=$ind; break; fi
			ind=$((ind + 1))
		done
	fi

	echo "CURR: $current_ind"

	chosen=$(echo "$pictures" | rofi -dmenu -lines $lines -width -50 -p ${walldir} -a $current_ind)
	selected=$(echo $chosen | wc -w)
	if [ $selected == 1 ];
	then
		feh --bg-fill ${walldir}$chosen
	fi
else
	if [ -f ~/.fehbg ];
	then
		~/.fehbg
	fi
fi
