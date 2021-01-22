#!bin/bash

echo ''
echo 'Add fonts copr and install'
sudo dnf copr enable adrienverge/some-nice-fonts -y
sudo dnf copr enable dawid/better_fonts -y
sudo dnf update -y

sudo dnf install some-nice-fonts -y
sudo dnf install fontconfig-font-replacements -y

echo ''
echo 'Install materia gtk theme'
sudo dnf install -y materia-gtk-theme

echo ''
echo 'Install arc gtk theme'
sudo dnf install -y arc-theme

echo ''
echo 'Install paper icon theme'
sudo dnf install -y paper-icon-theme

echo ''
echo 'Install papirus icon theme'
sudo dnf install -y papirus-icon-theme

echo ''
echo 'Install folder color'
sudo dnf copr enable kleong/folder-color -y 
sudo dnf install -y folder-color-common folder-color-nautilus

echo ''
echo 'Install and remove some apps'
sudo dnf config-manager --set-enabled google-chrome 
sudo dnf config-manager --set-enabled rpmfusion-nonfree-steam 
sudo dnf udpate -y
sudo dnf install -y gnome-tweaks htop R timeshift steam google-chrome-stable git gparted openssl-devel libcurl-devel
sudo dnf remove -y libreoffice-*

echo ''
echo 'Install flatpak apps'
flatpak install -y com.discordapp.Discord com.github.jeromerobert.pdfarranger com.skype.Client com.spotify.Client nl.hjdskes.gcolor3 org.gimp.GIMP org.inkscape.Inkscape org.onlyoffice.desktopeditors org.telegram.desktop us.zoom.Zoom com.transmissionbt.Transmission org.videolan.VLC

echo ''
echo 'Install snap apps'
sudo snap install -y geforcenow
sudo snap install -y code --classic

echo ''
echo 'Reboot'
sudo reboot now
