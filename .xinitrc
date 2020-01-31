# Never Turn Off The Monitor's
xset s off&&xset -dpms
# Set Language Laytout & Switch Option
setxkbmap -layout us,gr;setxkbmap -option 'grp:alt_shift_toggle'
# Faster Key-press Repeat Rate
xset r rate 250 90
# Turns the Num-lock on
xdotool key Num_Lock
# Set resolutions primary and refresh rate
xrandr --output DP-0 --primary --mode 2560x1440 --rate 144 --left-of HDMI-0 --output HDMI-0 --mode 1920x1080 --rate 60
# Use the xterm settings
xrdb .Xresources
#Start i3
exec i3
