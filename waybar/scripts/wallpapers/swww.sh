#!/bin/bash

# Transition
FPS=75
TYPE="any"
DURATION=1
SWWW_TRANSITION="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

echo $1
if [[ ${#1} -gt 0  ]]; then
	WALLPAPER_PATH=$1
	wallust run ${WALLPAPER_PATH}
	swww query || swww init && swww img ${WALLPAPER_PATH} $SWWW_TRANSITION
	pkill waybar
	pkill swaync
	waybar
	swaync
fi
