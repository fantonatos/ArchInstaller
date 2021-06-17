#!/bin/bash
# This script runs inside the target machine
# How to run: ./chroot.sh efi-dev root-dev

echo "---------------------------------"
echo "chroot: Running inside new system"

# Configure the system time and localization
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
touch /etc/locale.conf
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# Setup hostname and user accounts
echo ""
read -rp "Enter the hostname: " HOSTNAME

touch /etc/hostname
echo "${HOSTNAME}" >> /etc/hostname

touch /etc/hosts
{
    echo "127.0.0.1	localhost"
    echo "::1		localhost"
    echo "127.0.1.1	${HOSTNAME}.localdomain	${HOSTNAME}"
} >> /etc/hosts

echo "Set up password for root user..."
passwd

echo "Adding new user..."
read -rp "Enter username: " USERNAME
useradd -m "${USERNAME}"
echo "Set up password for ${USERNAME}."
passwd "${USERNAME}"
usermod -aG wheel,audio,video,optical,storage "${USERNAME}"

# Install Packages
pacman -S --noconfirm man-db man-pages git vim nano openssh ranger wpa_supplicant wireless_tools iw iproute2 dialog

echo "-------------------"
echo "Configuring Network"
echo "-------------------"
cp files/*.network /etc/systemd/network/
systemctl enable systemd-networkd
systemctl enable systemd-resolved

cp files/wpa_supplicant-*.conf /etc/wpa_supplicant/
systemctl enable wpa_supplicant


# Install UEFI Bootloader
echo "-----------------------------"
echo "Installing Bootloader..."
echo ""
bootctl --path=/boot install

{
    echo "timeout 3" 
    echo "default arch-*"
} > /boot/loader/loader.conf

{
    echo "title Arch Linux"
    echo "linux /vmlinuz-linux"
    echo "initrd    /initramfs-linux.img"
    echo "options   root=$2 rw"
} > /boot/loader/entries/arch.conf

echo "Finished Essential Configuration... Exiting chroot."
echo "Bootloader installed to $1"
exit
