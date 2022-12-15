#!/bin/sh
#

brightnessctl set $1
curr=$(brightnessctl g)
max=$(brightnessctl m)
percent=$((curr*10/max))
#echo $curr
#echo $max
#echo $percent

dots="*        "
if [[ $percent -gt 8 ]]; then
    dots="* * * * *"
else
    if [[ $percent -gt 6 ]]; then
        dots="* * * *  "
    else
        if [[ $percent -gt 4 ]]; then
            dots="* * *    "
        else
            if [[ $percent -gt 2 ]]; then
                dots="* *      "
            fi
        fi
    fi
fi

makoctl dismiss --all && \
  notify-send -a "brightnesschange.sh" -i display-brightness-symbolic.symbolic "$dots"
