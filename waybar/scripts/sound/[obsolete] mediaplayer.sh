#!/bin/bash

icon=0
player_status=$(playerctl status 2> /dev/null)

# Player not found
if [[ $? -eq 1 ]]; then
	icon=0
	alt="stopped"
	text=""
	tooltip="Not playning"
	echo "{\"text\": \"$text\", \"percentage\": $icon, \"tooltip\": \"$tooltip\", \"alt\": \"$alt\"}"
	exit 0
fi

if [[ "$player_status" != "Stopped" ]]; then
	title=$(playerctl metadata title)
	artist=$(playerctl metadata artist)

	# main artist
	MainArtist=$(echo $artist | awk -F',' '{print $1}')
	
	if [[ "$player_status" == "Playing" ]]; then
	    # " "
	    icon=1
	    alt="playing"
	elif [[ "$player_status" == "Paused" ]]; then
	    # " "
	    icon=2
	    alt="paused"
	fi

	# Format long titles
	t="$MainArtist - $title"
	if [[ ${#t} -gt 25 ]]; then
	    text=$title
	else
	    text="$MainArtist - $title"
	fi
	class=$alt
	tooltip="$artist - $title"
	echo "{\"text\": \"$text\", \"percentage\": $icon, \"tooltip\": \"$tooltip\", \"alt\": \"$alt\", \"class\": \"$class\"}"
	exit 0
elif [[ "$player_status" == "Stopped" ]] || [[ "$player_status" == "No players found" ]]; then
	icon=0
	alt="stopped"
	text=""
	tooltip="Not playning"
	echo "{\"text\": \"$text\", \"percentage\": $icon, \"tooltip\": \"$tooltip\", \"alt\": \"$alt\"}"
	exit 0
fi

# Waybar module configuration
# "custom/spotify": {
# 	"exec": "$HOME/.config/waybar/scripts/sound/mediaplayer.sh",
# 	"exec-if": true,
# 	"interval": 3,
# 	"format": "{icon}{}",
# 	"return-type": "json",
# 	"format-icons": {
# 		"playing": " ",
# 		"paused": " ",
# 		"stopped": "󰝛"
# 	},
# 	"max-length": 25,
# 	"on-click": "exec playerctl play-pause",
# 	"on-double-click": "exec playerctl next",
# 	"on-double-click-right": "exec playerctl previous",
# 	"on-scroll-up": "exec $HOME/.config/waybar/app-vol.sh 5%+",
# 	"on-scroll-down": "exec $HOME/.config/waybar/app-vol.sh 5%-"
# }