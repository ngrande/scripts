#!/bin/bash

active=$(pacmd list-sources | grep "RUNNING" -B3 | grep "name:" | awk '{print $2}')

selected=$(pacmd list-sources | grep "name:" | grep "input" | awk -F "alsa_input." '{print $2}' | awk -F ">" '{print $1}' | rofi -dmenu -width -50 -lines 10 -p "DEFAULT: $active")

# magic 20?
cmd="pacmd set-default-source alsa_input.${selected}"
eval $cmd
