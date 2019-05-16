#!/bin/bash

# script to retrieve exact memory usage stats

mem_type=$1
display_mode=$2
line=""
used=0
total=0

# 2 total, 3 used, 4 free, 5 shared, 6, buff/cache, 7 available
case "$mem_type" in
	"MEM")
		line=$(free | tail -n -2 | head -n 1)
		avail=$(echo $line | awk '{print $7}')
		total=$(echo $line | awk '{print $2}')
		# this is what htop would display
		# and represents the memory which is no more
		# available to new processes
		used=$(($total - $avail))
		;;
	"SWAP")
		line=$(free | tail -n 1)
		total=$(echo $line | awk '{print $2}')
		used=$(echo $line | awk '{print $3}')
		;;
	*)
		echo "specify MEM or SWAP"
		exit 1
		;;
esac

display_with_unit() {
	value=$1
	unit="B"
	if [ $value -gt $((1024 * 1024)) ];
	then
		unit="GB"
		value=$(($value / (1024 * 1024)))
	elif [ $value -gt 1024 ];
	then 
		unit="MB"
		value=$(($value / 1024))
	fi

	echo "$value$unit"
}

res=$(display_with_unit $used)

case "$display_mode" in
	"")
		# default: do nothing fancy
		;;
	"TOTAL")
		res="$res $(echo "/ $(display_with_unit $total)")"
		;;
	"%" | "PERCENT")
		# calc the percentage
		# use bc for decimal calculations
		res="$(echo "scale=2;$used * 100 / $total" | bc)%"
		if [[ $res =~ ^\.[0-9]+ ]];
		then
			res="0$res"
		elif [[ $res =~ ^[0-9]+\.[0-9]+ ]];
		then
			res="${res%%.*}%"
		fi
		;;
	*)
		echo "INVALID MODE. Use TOTAL or % (PERCENT)"
		exit 1
		;;
esac

echo $res
