#!/bin/sh
# Grab info about user [name&pass] Host name and where to install grub
echo "Please enter the Username:"
read user_name
echo "Please enter the User Password:"
read user_pass
echo "Please enter the Hostname:"
read host_name
fdisk -l
echo "Please enter where to install the Grub (example: /dev/sda):"
read disk
# Install base-devel just in case base was installed
# Also install linux-zen
pacman -S --needed base-devel git go zsh networkmanager linux-zen linux-zen-headers wget curl
# Change default shell to zsh for root
chsh -s /usr/bin/zsh
# Make new user and use zsh as defalt shell
useradd -m $user_name -s /usr/bin/zsh -d ~/$user_name
# Add to sudoers allow no pass for now
# It should be changed to ALL again later on
echo "$user_name ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# Add pass for new user
passwd $user_pass
# Add hostname
echo $host_name >> /etc/hostname
# Add Langs Greek and US
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
echo 'el_GR.UTF-8 UTF-8' >> /etc/locale.gen
echo 'el_GR ISO-8859-7'  >> /etc/locale.gen
# Set main lang
echo -n "LANG=en_US.UTF-8" > /etc/locale.conf
# Generate lang
locale-gen
# Switch to user
su - $user_name
# Make sure its on users home dir
cd ~/
# Grab my dots
git clone https://github.com/BillGR17/Dots
mv -f ~/Dots/{.,}* ~/
# Install aur helper
git clone https://aur.archlinux.org/yay.git
cd ~/yay
makepkg -si
cd ~/
rm -rf yay
# Hopefully this will help get pass the password prompt on yay
# Grab all my packages from dots
yay -S $(cat .packages) --noconfirm
# return to root
exit
# now it should ask for passwords
cat /etc/sudoers|sed -e "s/$user_name ALL=(ALL) NOPASSWD:ALL/$user_name ALL=(ALL) ALL/"> /etc/sudoers
# Grub & kernel
mkinitcpio -p linux-zen
grub-install --force --target=i386-pc $disk
grub-mkconfig -o /boot/grub/grub.cfg
# Enable services
systemctl enable NetworkManager
