#!/bin/bash

DIR="$HOME/Pictures/wallpapers/"
if [ ! -z "$1" ]; then
	DIR="$DIR$1"
fi

PICS=($(find ${DIR} -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.webp" \)))
WALLPAPER_PATH=${PICS[ $RANDOM % ${#PICS[@]} ]}

# Transition
FPS=75
TYPE="any"
DURATION=1
SWWW_TRANSITION="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

wallust run ${WALLPAPER_PATH}
swww query || swww init && swww img ${WALLPAPER_PATH} $SWWW_TRANSITION
pkill waybar
pkill swaync
waybar
swaync
