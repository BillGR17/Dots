#!/bin/bash
# Grab info about user [name&pass]Host name and where to install grub
echo "Please enter the Username:"
read user_name
echo "Please enter the User Password:"
read user_pass
echo "Please enter the Hostname:"
read host_name
fdisk -l
echo "Please enter where to install the Grub (example: /dev/sda):"
read disk
# Chose what GPU drivers to install
printf "Install GPU?\n\n0) Skip\n1) Nvidia\n2) AMD\n\n*nvidia drivers wont be installed from .packages\n" 
read_gpu=true
while $read_gpu; do
  read gpu
  if (( "$gpu" >= 0 )) && (( "$gpu" <= 3 )) ; then
    read_gpu=false
  else
    printf "Install GPU?\n0) Skip\n1) Nvidia\n2) AMD\n"
  fi
done
# Install base-devel just in case base was installed
# Also install linux-zen networkmanager go(its already needed for yay)
# And zsh shell and set it as default
# Also install mesa since its always needed
pacman -S --needed base-devel git go zsh networkmanager linux-zen linux-zen-headers wget curl mesa lib32-mesa
# Now install GPU drivers
case "$gpu" in
  1)
    pacman -S nvidia-dkms lib32-nvidia-utils lib32-opencl-nvidia
  ;;
  2)
    pacman -S xf86-video-amdgpu vulkan-randeon lib32-vulkan-radeon  libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau 
  ;;
esac
# Change default shell to zsh for root
chsh -s $(which zsh)
# Make new user and use zsh as defalt shell
useradd -m $user_name -s $(which zsh) -d ~/$user_name
# Add to sudoers allow no pass for now
# It should be changed to ALL again later on
echo "$user_name ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
# Add pass for new user
passwd $user_pass
# Add hostname
echo $host_name >> /etc/hostname
# Add Langs Greek and US
echo 'en_US.UTF-8 UTF-8'  >> /etc/locale.gen
echo 'el_GR.UTF-8 UTF-8'  >> /etc/locale.gen
echo 'el_GR ISO-8859-7'   >> /etc/locale.gen
# Set main lang
echo -n "LANG=en_US.UTF-8" > /etc/locale.conf
# Generate lang
locale-gen
# Switch to user
su - $user_name
# Make sure its on users home directory
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
# Ignore/remove all nvidia packages and vr stuff
packages=$(sed -e "s/\bnvidia\b//" -e "s/\bvr\b//g" -e "s/\bopenxr\b//g" .packages)
yay -S $packages --noconfirm
# Needed for neovim
pip install neovim
# Install all npm shit that i need the most
npm i -g eslint express-generator webpack-cli nodemon js-beautify neovim
# Return to root
exit
# Now it should ask for passwords
sed -e "s/$user_name ALL=(ALL) NOPASSWD:ALL/$user_name ALL=(ALL) ALL/" /etc/sudoers > /etc/sudoers
# Grub & kernel
mkinitcpio -p linux-zen
grub-install --force --target=i386-pc $disk
grub-mkconfig -o /boot/grub/grub.cfg
# Enable services
systemctl enable NetworkManager
# Create autologin to tty1
mkdir -p /etc/systemd/system/getty@tty1.service.d
printf "[Service]\nExecStart=\nExecStart=-/usr/bin/agetty --autologin $user --noclear %%I \$TERM\n" > /etc/systemd/system/getty@tty1.service.d/override.conf
