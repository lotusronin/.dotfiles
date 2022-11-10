#!/bin/bash
#

operator='+'
if [[ $# -ge 1 ]];
then
    operator=$1
fi

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

volume=$(get_current_volume)
#echo "Vol: $volume"
if [[ $operator = '+' ]]; then
        if [[ $volume -ge 96 ]]; then
            wpctl set-volume @DEFAULT_SINK@ 100%
        else 
            wpctl set-volume @DEFAULT_SINK@ 5%+
        fi
else
        if [[ $volume -lt 6 ]]; then
            wpctl set-volume @DEFAULT_SINK@ 0%
        else
            wpctl set-volume @DEFAULT_SINK@ 5%-
        fi
fi

volume=$(get_current_volume)
level=$(get_volume_intensity)
#echo $operator
#echo $volume
#echo $level

makoctl dismiss --all && \
  notify-send -i audio-volume-$level-symbolic.symbolic "$volume %"
