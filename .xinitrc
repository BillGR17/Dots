# Never Turn Off The Monitor's
xset s off&&xset -dpms
# Set Language Laytout & Switch Option
setxkbmap -layout us,gr;setxkbmap -option 'grp:alt_shift_toggle'
# Faster Key-press Repeat Rate
xset r rate 250 90
# Disable mouse Scroll left and right clicks
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap
# Turns the Num-lock on
xdotool key Num_Lock
# Enable bluetooth
bluetoothctl power on
# Use the xterm settings
xrdb -merge .Xresources
# Start i3
exec i3 > ~/.cache/i3.log
