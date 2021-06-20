#!/bin/bash
# Installs a working desktop enviroment
# Usage: ./desktop.sh <username>

pacman -S --noconfirm xorg xorg-xinit nvidia xterm \
	openbox obconf lxappearance lxappearance-obconf \
	plank tint2 nitrogen picom \
	alacritty pcmanfm \
	ttf-ubuntu-font-family ttf-roboto ttf-roboto-mono ttf-opensans \
	ttf-ibm-plex ttf-dejavu ttf-cascadia-code \
	archlinux-wallpaper cutefish-wallpapers deepin-wallpapers \
	base-devel wget

{
	grep -v 'twm\|xclock\|xterm\|exec' /etc/X11/xinit/xinitrc
	echo 'exec openbox-session'
} > "/home/$1/.xinitrc"

mkdir -p "/home/$1/.config/openbox/"
{
	echo "picom &"
	echo "nitrogen --restore &"
	echo "plank &"
} > "/home/$1/.config/openbox/autostart"


# Get Segoe UI Fonts
SEGOE="/home/$1/.local/share/fonts/Microsoft/TrueType/Segoe UI/"
mkdir -p "$SEGOE"
wget -q https://github.com/mrbvrz/segoe-ui/raw/master/font/segoeui.ttf?raw=true -O "$SEGOE"/segoeui.ttf > /dev/null 2>&1	# regular
wget -q https://github.com/mrbvrz/segoe-ui/raw/master/font/segoeuib.ttf?raw=true -O "$SEGOE"/segoeuib.ttf > /dev/null 2>&1	# bold
wget -q https://github.com/mrbvrz/segoe-ui/raw/master/font/segoeuii.ttf?raw=true -O "$SEGOE"/segoeuii.ttf > /dev/null 2>&1	# italic
wget -q https://github.com/mrbvrz/segoe-ui/raw/master/font/segoeuiz.ttf?raw=true -O "$SEGOE"/segoeuiz.ttf > /dev/null 2>&1	# bold italic
wget -q https://github.com/mrbvrz/segoe-ui/raw/master/font/segoeuil.ttf?raw=true -O "$SEGOE"/segoeuil.ttf > /dev/null 2>&1	# light
wget -q https://github.com/mrbvrz/segoe-ui/raw/master/font/seguili.ttf?raw=true -O "$SEGOE"/seguili.ttf > /dev/null 2>&1	# light italic
wget -q https://github.com/mrbvrz/segoe-ui/raw/master/font/segoeuisl.ttf?raw=true -O "$SEGOE"/segoeuisl.ttf > /dev/null 2>&1	# semilight
wget -q https://github.com/mrbvrz/segoe-ui/raw/master/font/seguisli.ttf?raw=true -O "$SEGOE"/seguisli.ttf > /dev/null 2>&1	# semilight italic
wget -q https://github.com/mrbvrz/segoe-ui/raw/master/font/seguisb.ttf?raw=true -O "$SEGOE"/seguisb.ttf > /dev/null 2>&1	# semibold
wget -q https://github.com/mrbvrz/segoe-ui/raw/master/font/seguisbi.ttf?raw=true -O "$SEGOE"/seguisbi.ttf > /dev/null 2>&1	# semibold italic
fc-cache -f "$SEGOE"
echo "Downloaded Segoe UI to $SEGOE"
echo "Installed openbox and xorg-xinit (startx)."
