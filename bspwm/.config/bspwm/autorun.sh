#!/bin/bash

$HOME/.config/polybar/launch.sh &
xsetroot -cursor_name left_ptr &
xrdb -merge ~/.Xresources &
nitrogen --restore &
polkit-gnome &
numlockx on &
flameshot &
compfy -b &
dunst &