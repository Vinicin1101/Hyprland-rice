#!/bin/bash

export WALLPAPER=$(swww query | awk '{print $8}')
sleep 1s
exec swaylock -c $HOME/.config/swaylock/config
