#!/bin/bash

# Construct a wallpapers path
wallpapers_dir="$HOME/Pictures/wallpapers"
wallpapers_list=$(ls -1 "$wallpapers_dir"/*/ | grep -E 'jpg|png|gif|webp|jpeg' | sed -E 's/(.jpg|.png|.gif|.webp|.jpeg)$//g') || {
  echo "Error: No wallpapers found in $wallpapers_dir"
  $(rofi -e "No wallpapers found in $wallpapers_dir")
  # exit 1
}


# Rofi #
current_wallpaper=$(swww query | awk '{print $8}' | sed -n "s/\// /g;p" | awk '{print $6}')
selected_wallpaper=$(
echo "[*] $current_wallpaper"
echo "random"
$wallpapers_list" | rofi -dmenu -p "Select your wallpaper"
)

if [[ -z "$selected_wallpaper" ]]; then
  # No wallpaper selected
  exit 1
fi

if [[ "$selected_wallpaper" == "random" ]]; then
  exec ./random $selected_wallpaper
  exit 0
fi

# Reconstruct the path #
selected_path="$wallpapers_dir/*/$selected_wallpaper.*"

# Execute the wallpaper script #
"$HOME/.config/waybar/scripts/wallpapers/swww.sh" "$selected_path"
