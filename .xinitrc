# Never Turn Off The Monitor's
xset s off&&xset -dpms
# Set Language Laytout & Switch Option
setxkbmap -layout us,gr;setxkbmap -option 'grp:alt_shift_toggle'
# Faster Key-press Repeat Rate
xset r rate 250 90
# Turns the Num-lock on
xdotool key Num_Lock
# Use the xterm settings
xrdb -merge .Xresources
#Start i3
exec i3 >> ~/.local/share/logs/i3.log
