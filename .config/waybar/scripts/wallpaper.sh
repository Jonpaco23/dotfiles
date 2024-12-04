#!/bin/bash

export PATH="${PATH}:${HOME}/.local/bin/"
DIR=$HOME/.wallpaper
PICS=($(ls ${DIR}))

RANDOMPICS=${PICS[ $RANDOM % ${#PICS[@]} ]}

if [[ $(pidof swww) ]]; then
  pkill swww
fi

swww img ${DIR}/${RANDOMPICS} --transition-type grow --transition-fps 60 --transition-duration 0.5 --transition-bezier 0.65,0,0.35,1 --transition-pos 0.794,0.972 --transition-step 1

sleep 1.25

wal -e -i ${DIR}/${RANDOMPICS}

pkill waybar && waybar

pywalfox update
pywal-discord -t default
${HOME}/.config/dunst/initdunst.sh
notify-send "BG Changed!"
