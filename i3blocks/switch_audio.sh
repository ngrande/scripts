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
	name=$( echo $1 | awk -F "alsa_output." '{print $2}' | awk -F ">" '{print $1}')
	if [ "x$name" == "x" ];
	then
		name=$(echo $1 | awk -F "bluez_sink." '{print $2}' | awk -F ">" '{print $1}')
	fi
#	echo $name
	echo $(echo $1 | sed -E 's+(<|>)++g')
}

if [ $? ];
then
	# when more than one is actively linked, i will just show the first?
	linked=$(pacmd list-${mode}s | grep -E "linked by: [1-9][0-9]?" -B 19 | head -n 1)

	active=$(filter_name $(echo $linked | awk '{print $2}'))
fi

avail=$(pacmd list-${mode}s | grep "name:" | egrep "output|bluez" | awk -F "name:" '{print $2}')
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

# this command sometimes work, sometimes it has no effect
pacmd set-default-${mode} ${selected}
# thus we have to assign each sink input to the new sink
pactl list short sink-inputs | while read stream; do
	stream_id=$(echo $stream | cut '-d ' -f1)
	pactl move-sink-input "$stream_id" "${selected}"
done
