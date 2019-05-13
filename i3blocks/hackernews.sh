#!/bin/bash

# get hacker news
# requires 'jq'

base_url=https://hacker-news.firebaseio.com/v0/

get_top_ids() {
	ids=$(curl -s ${base_url}/topstories.json?print=pretty)
	echo $(echo $ids | awk -F '[' '{print $2}' | awk -F ']' '{print $1}' | sed -e 's/,//g' )
}


get_headlines() {
	for id in $1
	do
		local json_res=$(curl -s ${base_url}/item/${id}.json?print=pretty) # | jq -r '.title')
#		echo $( echo $json_res | jq)
		title=$(echo $json_res| jq -r '.title')
		item_id=$(echo $json_res | jq -r '.id')
		url=$(echo $json_res | jq -r '.url')
		time=$(echo $json_res | jq -r '.time')

		# remove @ from title
		title=$(echo $title | sed -e 's/@/at/g')

		echo "$(date -d "@$time" +%H:%M) | $title | @$url"
	done
}

selected=$(get_headlines "$(get_top_ids)" | rofi -dmenu -p "Hacker News")

story_url=$(echo $selected | awk -F "@" '{print $2}')
xdg-open $story_url
