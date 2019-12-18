#!/bin/sh
#grab info about user [name&pass] Host name and where to install grub
echo "Please enter the Username:"&&read user_name&&echo "Please enter the User Password"&&read user_pass&&echo "Please enter the Hostname:"&&read host_name&&fdisk -l&&echo "Please enter where to install the Grub (example: /dev/sda):"&&read disk
pacman -S --needed base-devel git go zsh sudo networkmanager linux-zen linux-zen-headers wget curl
#change default shell to zsh for root
chsh -s /usr/bin/zsh
#Make new user and use zsh as defalt shell
useradd -m $user_name -s /usr/bin/zsh -d ~/$user_name
#add to sudoers
echo "$user_name ALL=(ALL) ALL" >> /etc/sudoers
#add pass for new user
passwd $user_pass
#add hostname
echo $host_name >> /etc/hostname
#Add Langs Greek and US
echo 'el_GR.UTF-8 UTF-8'>>/etc/locale.gen&&echo 'el_GR ISO-8859-7'>>/etc/locale.gen&&echo 'en_US.UTF-8 UTF-8'>>/etc/locale.gen
#set main lang
echo -n "LANG=en_US.UTF-8" > /etc/locale.conf
#generate lang
locale-gen
#keep sudo access on
_sudo(){
  echo $user_pass|sudo --stdin --validate
}
#switch to user
su - $user_name
#make sure its on users home dir
cd ~/
#grab my dots
git clone https://github.com/BillGR17/Dots
mv -f ~/Dots/{.,}* ~/
#install aur helper
git clone https://aur.archlinux.org/yay.git
cd ~/yay
_sudo
makepkg -si
cd ~/
rm -rf yay
#hopefully this will help get pass the password prompt on yay
_sudo
#grab all my packages from dots
#sudoloop will keep yay from asking password again
yay -S $(cat .packages) --noconfirm --sudoloop
#return to root
exit
#Grub & kernel
mkinitcpio -p linux-zen&&grub-install --force --target=i386-pc $disk&&grub-mkconfig -o /boot/grub/grub.cfg
#systemd
systemctl enable NetworkManager
