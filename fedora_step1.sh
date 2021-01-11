#!bin/bash

#echo 'Disable Wayland and make Xorg default'
#sudo sed -i 's/#WaylandEnable=false/WaylandEnable=false/' /etc/gdm/custom.conf
#sudo sed  -i '/WaylandEnable=false/a DefaultSession=gnome-xorg.desktop' /etc/gdm/custom.conf


echo ''
echo 'Add optimized mount options to fstab'
sudo sed -i 's/subvol=@home /subvol=@home,ssd,noatime,space_cache,commit=120,compress=zstd,discard=async /' /etc/fstab
sudo sed  -i 's/subvol=@ /subvol=@,ssd,noatime,space_cache,commit=120,compress=zstd,discard=async /' /etc/fstab


echo ''
echo 'Update grub config'
sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg

echo ''
echo 'Reboot'
sudo reboot now

