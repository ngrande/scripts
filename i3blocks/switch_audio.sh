#!/bin/bash

mode=""
case "$1" in 
	"sink")
		mode="sink"
		;;
	"source")
		mode="source"
		;;
	*)
		echo "Invalid! Allowed: 'sink' or 'source'"
		exit 1
		;;
esac

active="0"
pacmd list-${mode}s | grep -E "linked by: [1-9][0-9]?"

filter_name() {
	echo $( echo $1 | awk -F "alsa_output." '{print $2}' | awk -F ">" '{print $1}')
}

if [ $? ];
then
	# when more than one is actively linked, i will just show the first?
	linked=$(pacmd list-${mode}s | grep -E "linked by: [1-9][0-9]?" -B 19 | head -n 1)

	active=$(filter_name $(echo $linked | awk '{print $2}'))
fi

avail=$(pacmd list-${mode}s | grep "name:" | grep "output" | awk -F "name:" '{print $2}')
list=""
active_ind=""
i=0
for sink in $avail;
do
	sink=$(filter_name $sink)
	if [ "$active" == "$sink" ];
	then
		active_ind=$i
	fi
	i=$(($i+1))
	list="$list$sink\n"
done
selected=$( printf $list | rofi -dmenu -width -50 -lines $(printf $list | wc --lines) -p "Choose $mode" -a $active_ind)

cmd="pacmd set-default-${mode} alsa_output.${selected}"
eval $cmd
