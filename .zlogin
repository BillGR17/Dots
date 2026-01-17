if [[ ! $DISPLAY && $XDG_VTNR -eq 1 && ! -f /tmp/c_c ]]; then
  touch /tmp/c_c
  #exec start-hyprland > /tmp/hyprland.log 2>&1
  startx
fi
