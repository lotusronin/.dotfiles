#!/bin/bash
set -e

## Adapted Script from
# https://github.com/yschaeff/sway_screenshots/blob/master/screenshot.sh

## USER PREFERENCES ##
MENU="bemenu"
#TARGET=$(xdg-user-dir PICTURES)/screenshots
TARGET=~/screenshots

NOTIFY=$(pidof mako) || true
FOCUSED=$(swaymsg -t get_tree | jq '.. | ((.nodes? + .floating_nodes?) // empty) | .[] | select(.focused and .pid) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')
OUTPUTS=$(swaymsg -t get_outputs | jq -r '.[] | select(.active) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')
WINDOWS=$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')

notify() {
    ## if the daemon is not running notify-send will hang indefinitely
    if [ $NOTIFY ]; then
        notify-send "$@"
    else
        echo NOTICE: notification daemon not active
        echo "$@"
    fi
}

CHOICE=`$MENU -l 5 -p "How to make a screenshot?" << EOF
fullscreen
focused
select-window
select-output
region
EOF`


mkdir -p $TARGET
FILENAME="$TARGET/$(date +'%Y-%m-%d_%Hh%Mm%Ss_screenshot.png')"

case "$CHOICE" in
    "fullscreen")
        grim "$FILENAME" ;;
    "region")
        slurp | grim -g - "$FILENAME" ;;
    "select-output")
        echo "$OUTPUTS" | slurp | grim -g - "$FILENAME" ;;
    "select-window")
        echo "$WINDOWS" | slurp | grim -g - "$FILENAME" ;;
    "focused")
        grim -g "$(eval echo $FOCUSED)" "$FILENAME" ;;
    *)
        grim -g "$(eval echo $CHOICE)" "$FILENAME" ;;
esac


notify "Screenshot" "File saved as $FILENAME\nand copied to clipboard" -t 6000 -i $FILENAME
wl-copy < $FILENAME
feh $FILENAME
