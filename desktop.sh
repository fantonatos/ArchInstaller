#!/bin/bash
# Installs desktop environment and useful graphical programs
# Usage: desktop.sh <username>

pacman -S --noconfirm xorg nvidia
pacman -S --noconfirm gnome mpv firefox \
	ttf-ubuntu-font-family ttf-roboto ttf-roboto-mono ttf-opensans \
	ttf-dejavu ttf-cascadia-code \
	archlinux-wallpaper cutefish-wallpapers deepin-wallpapers

