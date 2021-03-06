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
echo "LANG=en_US.UTF-8" >> /etc/locale.conf


# Setup hostname and user accounts
echo ""
read -rp "Enter the hostname: " HOSTNAME
echo "${HOSTNAME}" >> /etc/hostname

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
pacman -S --noconfirm man-db man-pages git vim nano openssh ranger iwd wireless_tools iw iproute2 dialog intel-ucode

echo "-------------------"
echo "Configuring Network"
echo "-------------------"
cp files/*.network /etc/systemd/network/
systemctl enable systemd-networkd
systemctl enable systemd-resolved
systemctl enable iwd


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
    echo "initrd    /intel-ucode.img"
    echo "initrd    /initramfs-linux.img"
    echo "options   root=$2 rw"
} > /boot/loader/entries/arch.conf

echo "Finished Essential Configuration... Exiting chroot."
echo "Bootloader installed to $1"
exit
