#!/bin/bash

$HOME/.config/polybar/launch.sh &
xsetroot -cursor_name left_ptr &
xrdb -merge ~/.Xresources &
nitrogen --restore &
numlockx on &
flameshot &
compfy -b &
dunst &