#!/bin/bash

# Função para obter volume e status de mudo
get_volume_status() {
    local status=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    local volume=$(echo "$status" | awk 'match($0, /Volume: ([0-9.]+)/) {print substr($0, RSTART+8, RLENGTH-8)}')
    local is_muted=$(echo "$status" | grep -o "MUTED")

    echo "$volume $is_muted"
}

# Check music status
music_status() {
    player_status=$(playerctl status 2 > /dev/null)

    if [[ "$player_status" != "Stopped" ]]; then
        echo "true $player_status"
    else
        echo false
    fi
}

while [ $# -gt 0 ] ; do
    alt="default"
    
    case "$1" in
        -mute)
            wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
            read -r volume is_muted <<< $(get_volume_status)
            ;;
        -status)
            read -r volume is_muted <<< $(get_volume_status)
            ;;
        *)
            echo "Erro: Opção desconhecida: $1"
            exit 1
    esac

    volume_percent=$(echo "$volume" | awk '{printf "%.0f", $1 * 100}')
    tooltip="Volume: $(echo "$volume_percent")%"

    # Music status
    read -r status music_status <<< $(music_status)

    if [ $status == true  ]; then
        title=$(playerctl metadata title)
        artist=$(playerctl metadata artist)

        if [ ${#title} -gt 2 ]; then

            MainArtist=$(echo $artist | awk -F',' '{print $1}')

            if [ "$music_status" == "Playing" ]; then
                alt="playing"
            elif [ "$music_status" == "Paused" ]; then
                alt="paused"
            fi

            tt="$MainArtist - $title"
            label=" $title"
            tooltip=$(echo "$tooltip | $tt")
        fi
    fi

    # Muted status
    if [ -n "$is_muted" ]; then
        tooltip=$(echo "$tooltip - muted")
        alt="mute"
    fi

    shift
done

echo "{\"text\": \"$label\", \"tooltip\": \"$tooltip\", \"alt\": \"$alt\"}"
