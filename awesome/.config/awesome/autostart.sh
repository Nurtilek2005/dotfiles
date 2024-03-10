#!/bin/bash

CHECK_FILE="/tmp/awesome_autostart_executed"

if [ ! -e "$CHECK_FILE" ]; then
    touch "$CHECK_FILE"
    echo "Executing awesome-client to restart AwesomeWM..."
    awesome-client "awesome.restart()"
else
    echo "AwesomeWM already restarted, skipping..."
fi

xrdb -merge ~/.Xresources &

restart() {
    local app_name=$1
    echo "Restarting $app_name..."
    killall "$app_name"
    "$app_name" &
}

restart xscreensaver -no-splash &
restart xfce4-power-manager &
restart numlockx on &
restart nm-applet &
restart lxpolkit &
restart picom -b &
restart dunst &

#trap "rm -f $CHECK_FILE" EXIT
