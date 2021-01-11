#!bin/bash

echo 'Enable fstrim.timer'
sudo systemctl enable fstrim.timer

echo ''
echo 'Add flag max download to dnf'
sudo echo 'max_parallel_downloads=20' | sudo tee -a /etc/dnf/dnf.conf

echo ''
echo 'Upgrade system'
sudo dnf upgrade -y

echo ''
echo 'Add RPM fusion'
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf upgrade -y

echo ''
echo 'Add media codecs'
sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
sudo dnf install -y lame\* --exclude=lame-devel
sudo dnf group upgrade --with-optional Multimedia -y

echo ''
echo 'Enable suggested RPM fusion configurations'
sudo dnf groupupdate core -y
sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
sudo dnf groupupdate sound-and-video -y

echo ''
echo 'Enable exFat support'
sudo dnf install -y exfat-utils fuse-exfat

echo ''
echo 'Driver search'
sudo dnf upgrade --refresh -y
sudo dnf check
sudo dnf autoremove -y
sudo fwupdmgr get-devices -y
sudo fwupdmgr refresh --force
sudo fwupdmgr get-updates
sudo fwupdmgr update -y

echo ''
echo 'Enable flathub'
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update

echo ''
echo 'Enable snap'
sudo dnf install snapd -y
sudo ln -s /var/lib/snapd/snap /snap
 
echo ''
echo 'Reboot system'
sudo reboot now

