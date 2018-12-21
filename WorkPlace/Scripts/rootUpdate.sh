#!/bin/sh
c_loc_=".config/"
c_folders=(
  "i3"
  "nvim"
  "ranger"
  "compton"
)
c_files=(
  ".zshrc"
  ".tmux.conf"
  ".Xresources"
  ".xinitrc"
)
if id -u $1 > /dev/null 2>&1 && [ ! -z "$1" ] ;then
  for i in "${c_folders[@]}";do
    sudo cp -TRv /home/$1/$c_loc_$i /root/$c_loc_$i
  done
  for i in "${c_files[@]}";do
    sudo cp -v /home/$1/$i /root/$i
  done
  sudo cp -TRv /home/$1/.zshf /root/.zshf
else
  echo Wrong User
fi
