#!/bin/bash

# assuming you have rofi installed

mod_set=$(cat ~/.config/i3/config  | grep "set \$mod" | grep -v -E "\s*#" | awk '{print $3}')
config_bindings=$(cat ~/.config/i3/config  | grep "bindsym\|mode" | grep -v -E "\s*#")

cmd=$(echo "${config_bindings//bindsym/}" | rofi -dmenu -width -100 -p "Keybindings (\$mod = $mod_set)" -i | awk '{$1=""; print $0}')

if [[ $cmd =~ \s*(i3\s+)?exec ]];
then
	# put the exec command in quotes
	cmd=$(echo $cmd | awk -F "exec" '{print $1 " exec \"" $2 "\""}')
fi

if [[ $cmd =~ ^\s*i3 ]];
then
	eval $cmd
else
	# prepend "i3"
	eval "i3 $cmd"
fi
