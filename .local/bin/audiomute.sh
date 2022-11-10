#!/bin/bash
#

wpctl set-mute @DEFAULT_SINK@ toggle
muted=$(wpctl get-volume @DEFAULT_SINK@ | grep MUTED)
#echo "muted: $muted"

get_current_volume() {
    volume=$(wpctl get-volume @DEFAULT_SINK@ | awk '{ print $2 }')
    volume=$(echo "$volume*100" | bc)
    volume=${volume%.*}
    echo $volume
}

get_volume_intensity() {
    volume=$(get_current_volume)
    if [[ $volume -ge 70 ]]; then
        echo high
    else
        if [[ $volume -ge 30 ]]; then
            echo medium
        else
            echo low
        fi
    fi
}

icon_type="muted"
note_text="MUTED"
if [[ $muted = "" ]]; then
    volume=$(get_current_volume)
    level=$(get_volume_intensity)
    icon_type=$level
    note_text="$volume %"
    #echo $volume
    #echo $level
fi

makoctl dismiss --all && \
  notify-send -i audio-volume-$icon_type-symbolic.symbolic "$note_text"
