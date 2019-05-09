#!/bin/bash

active=$(pacmd list-sinks | grep "RUNNING" -B3 | grep "name:" | awk '{print $2}')

selected=$(pacmd list-sinks | grep "name:" | grep "output" | awk -F "alsa_output." '{print $2}' | awk -F ">" '{print $1}' | rofi -dmenu -width -50 -lines 10 -p "DEFAULT: $active")

# magic 20?
cmd="pacmd set-default-sink alsa_output.${selected}"
eval $cmd
