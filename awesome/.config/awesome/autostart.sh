#!/bin/bash

restart() {
    local app_name=$1
    echo "Restarting $app_name..."
    killall "$app_name"
    "$app_name" &
}

restart xrdb -merge ~/.Xresources &
restart xscreensaver -no-splash &
restart xfce4-power-manager &
restart numlockx on &
restart nm-applet &
restart lxpolkit &
restart picom -b &
restart dunst &
