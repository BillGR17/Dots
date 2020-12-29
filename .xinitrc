# Never Turn Off The Monitor's
xset s off&&xset -dpms
# Set Language Laytout & Switch Option
setxkbmap -layout us,gr;setxkbmap -option 'grp:alt_shift_toggle'
# Faster Key-press Repeat Rate
xset r rate 250 90
# Turns the Num-lock on
xdotool key Num_Lock
<<<<<<< HEAD
=======
# Set msi keyboard led
msi-led -m normal -c left,sky,low -c middle,sky,low -c right,sky,low
>>>>>>> 66a523f9bb91918b8ca16138ecf5a35d9d6bfa90
# Use the xterm settings
xrdb -merge .Xresources
#Start i3
exec i3 > ~/.cache/i3.log
