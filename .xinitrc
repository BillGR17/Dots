# Never Turn Off The Monitor's
xset s off&&xset -dpms
# Set Language Laytout & Switch Option
setxkbmap -layout us,gr;setxkbmap -option 'grp:alt_shift_toggle'
# Faster Key-press Repeat Rate
xset r rate 250 90
# Turns the Num-lock on
xdotool key Num_Lock
# Set resolutions primary and refresh rate
xrandr --output eDP-1-1 --primary --mode 1920x1080 --rate 60
# Use the xterm settings
xrdb .Xresources
#Start i3
exec i3
