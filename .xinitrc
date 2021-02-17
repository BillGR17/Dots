# Never Turn Off The Monitor's
xset s off&&xset -dpms
# Set Language Laytout & Switch Option
setxkbmap -layout us,gr;setxkbmap -option 'grp:alt_shift_toggle'
# Faster Key-press Repeat Rate
xset r rate 250 90
# Disable mouse Scroll left and right clicks
xmodmap -e "pointer = 1 2 3 4 5 0 0 8 9 10 11 12 13 14 15 16 17 18 19 20"
# Turns the Num-lock on
xdotool key Num_Lock
# Use the xterm settings
xrdb -merge .Xresources
#Start i3
exec i3 > ~/.cache/i3.log
