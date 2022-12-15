#!/bin/bash

FILENAME="/tmp/lockscreen_screenshot.png"
grim $FILENAME
magick $FILENAME -blur 2x3 $FILENAME
swaylock -i $FILENAME --clock
