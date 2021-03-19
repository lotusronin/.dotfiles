#!/bin/bash
set -e

## Adapted Script from
# https://github.com/yschaeff/sway_screenshots/blob/master/screenshot.sh

## USER PREFERENCES ##
MENU="bemenu"
RECORDER=wf-recorder
TARGET=~/screenrecords

NOTIFY=$(pidof mako) || true
FOCUSED=$(swaymsg -t get_tree | jq '.. | ((.nodes? + .floating_nodes?) // empty) | .[] | select(.focused and .pid) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')
OUTPUTS=$(swaymsg -t get_outputs | jq -r '.[] | select(.active) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')
WINDOWS=$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')
REC_PID=$(pidof $RECORDER) || true

notify() {
    ## if the daemon is not running notify-send will hang indefinitely
    if [ $NOTIFY ]; then
        notify-send "$@"
    else
        echo NOTICE: notification daemon not active
        echo "$@"
    fi
}

if [ -z $REC_PID ]; then
    
    CHOICE=`$MENU -l 4 -p "How to make a screen recording?" << EOF
    record-focused
    record-select-window
    record-select-output
    record-region
    EOF`


    mkdir -p $TARGET
    RECORDING="$TARGET/$(date +'%Y-%m-%d_%Hh%Mm%Ss_recording.mp4')"

    case "$CHOICE" in
        "record-select-output")
            $RECORDER -g "$(echo "$OUTPUTS"|slurp)" -f "$RECORDING" &
            REC=1 ;;
        "record-select-window")
            $RECORDER -g "$(echo "$WINDOWS"|slurp)" -f "$RECORDING" &
            REC=1 ;;
        "record-region")
            $RECORDER -g "$(slurp)" -f "$RECORDING" &
            REC=1 ;;
        "record-focused")
            $RECORDER -g "$(eval echo $FOCUSED)" -f "$RECORDING" &
            REC=1 ;;
        *)
            $RECORDER -f "$RECORDING" &
            REC=1 ;;
    esac


    if [ $REC ]; then
        notify "Recording" "Recording started: $RECORDING" -t 5000
        #wl-copy < $RECORDING
    fi

else
    echo pid: $REC_PID
    kill -SIGINT $REC_PID
    notify "Screen recorder stopped" -t 2000
    exit 0
fi
