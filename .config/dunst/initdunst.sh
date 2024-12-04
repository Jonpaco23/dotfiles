#!/bin/bash

pidof dunst && killall dunst

ln -sf    "${HOME}/.cache/wal/dunstrc"    "${HOME}/.config/dunst/dunstrc"

dunst &