#!/bin/sh

# Never Turn Off The Monitor's
xset s off&&xset -dpms&

# Use the xterm settings
xrdb -merge .Xresources&

# Start wm
exec i3 > ~/.cache/wm.log 2>&1
