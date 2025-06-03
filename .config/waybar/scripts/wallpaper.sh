#!/bin/bash

export PATH="${PATH}:${HOME}/.local/bin/"
DIR=$HOME/.wallpaper
LOGSEQ=$HOME/logseq/logseq
PICS=($(ls ${DIR}))

RANDOMPICS=${PICS[ $RANDOM % ${#PICS[@]} ]}


if [[ $(pidof swww) ]]; then
  pkill swww
fi

if ! [[ $(pidof swww-daemon) ]]; then
  swww-daemon
fi

if [[ $(pidof waybar) ]]; then
  pkill waybar
fi

swww img ${DIR}/${RANDOMPICS} --transition-type grow --transition-fps 60 --transition-duration 0.5 --transition-bezier 0.65,0,0.35,1 --transition-pos 0.794,0.972 --transition-step 1

# sleep 1.25

wal -e -i ${DIR}/${RANDOMPICS}

sed -i 's,''path = .*,''path = '"${DIR}/${RANDOMPICS}"',1' ${HOME}/.config/hypr/hyprlock.conf
ln -sf ${DIR}/${RANDOMPICS} $HOME/.config/.current_wallpaper

ags -q
pywalfox update
pywal-discord -t default
${HOME}/.config/dunst/initdunst.sh
${HOME}/Youwal/youwal
#cat ~/.cache/wal/colors.css > $LOGSEQ/custom.css
#cat $LOGSEQ/colors.css >> $LOGSEQ/custom.css

waybar

notify-send "BG Changed!"
