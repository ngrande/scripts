#!/bin/bash

# assume you have feh installed

walldir=$1"/"

pictures='ls ${walldir} | grep -E "*\.(jpg|png)"'
lines=$(eval $pictures | wc --lines)
chosen=$(eval $pictures | rofi -dmenu -lines $lines -width -50 -p ${walldir})

feh --bg-fill ${walldir}$chosen
