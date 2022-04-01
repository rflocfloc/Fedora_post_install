#!/bin/bash

DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=120

echo "SUDO priviledges & dialog package required!"
if $(dnf list installed | grep dialog | wc -l) == 0; then
	sudo dnf install dialog
else
	sudo
fi


OPTIONS=(1 "DNF & RPM Fusion - Enables DNF max_parallel and RPM Fusion Repos"
         2 "Upgrade - Upgrades the system"
         3 "Media Codecs & Supports - Installs RPM Fusion suggested codecs & some utils (git, sshfs, exfat, etc.)"
         4 "Enable Flathub - Adds Flathub repos"
         5 "Install Software - Installs a bunch of programs from Flatpak"
         6 "R & RStudio - Installs R, blas backends, and RStudio"
         7 "Fedora ToolBox - Adds Fedora ToolBox containers"
         8 "Miniconda - Installs Miniconda and Mamba"
         9 "Exit & Reboot - Reboots the system")


display_result() {
  dialog --title "$1" \
    --no-collapse \
    --msgbox "Yeeee!" 0 0
}

APPS=(Firmware "GUI for firmware drivers" off 
      FontDownloader "FontDownloader app" off
      Fragments "Torrent client" off
      org.gimp.GIMP "GIMP Photo editing app" off
      Inkscape "Vector graphics app" off
      com.visualstudio.code "VSCode" off
      com.github.marktext.marktext "Markdown app" off
      com.github.tchx84.Flatseal "Manage Flatpak apps permissions " off
      org.onlyoffice.desktopeditors "Office suite replacement" off
      com.slack.Slack "Slack" off
      org.telegram.desktop "Telegram" off
      zoom "Zoom" off
      Spotify "Spotify" off
      PDFArranger "PDF merger" off)

while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "Fedora Post Install Tasks" \
    --title "Tasks Menu" \
    --clear \
    --cancel-label "Exit" \
    --menu "Choose one of the following options:" $HEIGHT $WIDTH 4 \
    "${OPTIONS[@]}" \
    2>&1 >/dev/tty)
  exit_status=$?
  exec 3>&-
  case $exit_status in
    $DIALOG_CANCEL)
      clear
      echo "Program terminated."
      exit
      ;;
    $DIALOG_ESC)
      clear
      echo "Program aborted." >&2
      exit 1
      ;;
  esac
  clear
  case $selection in
    1)   echo "DNF & RPM Fusion"
            sudo echo 'max_parallel_downloads=20' | sudo tee -a /etc/dnf/dnf.conf
            sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
            display_result "DNF & RPM Fusion Enabled" 
           ;;
        2)  echo "Upgrade"
            sudo dnf -y upgrade --refresh
	    sudo dnf check
	    sudo dnf autoremove -y
	    sudo fwupdmgr get-devices
	    sudo fwupdmgr refresh --force
	    sudo fwupdmgr get-updates
	    sudo fwupdmgr update -y
            display_result "System Upgraded" 
           ;;
        3)  echo "Media Codecs & Supports"
            sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
	    sudo dnf install -y lame\* --exclude=lame-devel
            sudo dnf group upgrade --with-optional Multimedia -y
            sudo dnf groupupdate core -y
	    sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
	    sudo dnf groupupdate sound-and-video -y
	    sudo dnf install dnf-plugins-core -y
	    sudo dnf install -y ffmpeg intel-media-driver git openssl-devel libcurl-devel ssh sshfs exfat-utils fuse-exfat neofetch
	    sudo dnf upgrade --refresh -y
            display_result "Codecs and Support Installed" 
           ;;
        4)  echo "Enabling Flathub"
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            flatpak update
            display_result "Flathub Repos Added"
           ;;
        5)  appsel=$(dialog --separate-output --checklist "Select the groups they belong:" 0 0 0 "${APPS[@]}" 2>&1 >/dev/tty)
        clear
        for opt in $appsel; do
 		flatpak install -y $opt
 	done
 	#display_result "Flatpak Apps Added"
           ;;
        6) echo "Setting up R & RStudio"
           sudo dnf install R -y
           sudo dnf install R-flexiblas -y # install FlexiBLAS API interface for R
	   sudo dnf install flexiblas-*  -y # install all available optimized backends
	   sudo dnf install rstudio-desktop -y
	   display_result "R & RStudio have been installed" 
           ;;
        7) echo "Installing Fedora ToolBox"
           sudo dnf install toolbox -y
           display_result "Fedora ToolBox added"
           ;;
        8) echo "Installing Miniconda"
           curl -sL "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" > "Miniconda3.sh"
	   bash Miniconda3.sh
	   source $HOME/.bashrc
	   conda update conda
	   conda config --append channels conda-forge
	   conda config --add channels bioconda
	   conda install mamba -y
	   rm Miniconda3.sh
	   display_result "Miniconda Up & Running" 
           ;;
        9) echo "My pleasure, see ya!"
           sudo reboot
           ;;
  esac
done
