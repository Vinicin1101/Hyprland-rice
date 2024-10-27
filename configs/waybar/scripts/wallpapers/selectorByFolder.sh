#!/bin/bash

# Get current wallpaper #
current_wallpaper=$(swww query | awk '{print $8}' | sed -n "s/\// /g;p" | awk '{print $6}')

# wallpapers root
wallpapers_dir="$HOME/Pictures/wallpapers"

# List styles (subfolders) in wallpapers dir
styles=$(ls -1 "$wallpapers_dir") || {
  echo "Error: No subfolders found in $wallpapers_dir, If you want to group your wallpapers please separate them into folders"
  $(rofi -e "Error: No subfolders found in $wallpapers_dir, If you want to group your wallpapers please separate them into folders")
  exit 1
}

###################
# Rofi style menu #
###################
selected_style=$(echo "[*] $current_wallpaper
$styles" | rofi -dmenu -p "Select style")

if [[ -z "$selected_style" ]]; then
  exit 1
fi

# Lists the wallpapers in the selected style (subfolder)
wallpapers_list=$(ls -1 "$wallpapers_dir/$selected_style" | grep -E 'jpg|png|gif|webp|jpeg' | sed -E 's/(.jpg|.png|.gif|.webp|.jpeg)$//g') || {
  echo "Error: No wallpapers found in $wallpapers_dir/$selected_style"
  $(rofi -e "Error: Error: No wallpapers found in $wallpapers_dir/$selected_style")
  exit 1
}

########################
# Rofi wallpapers menu #
########################
selected_wallpaper=$(echo "[*] $current_wallpaper
$wallpapers_list" | rofi -dmenu -p "Select wallpaper")

# No wallpaper
if [[ -z "$selected_wallpaper" ]]; then
  exit 1
fi

# Reconstruct the path
selected_path="$wallpapers_dir/$selected_style/$selected_wallpaper.*"

# Execute the wallpaper changer script
"$HOME/.config/waybar/scripts/wallpapers/swww.sh" "$selected_path"
