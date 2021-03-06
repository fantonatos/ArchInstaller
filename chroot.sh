#!/bin/bash
# This script runs inside the target machine

# Configure the system time and localization
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
touch /etc/locale.conf
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# Setup hostname and user accounts
echo ""
read -p "Enter the hostname: " HOSTNAME

touch /etc/hostname
echo "${HOSTNAME}" >> /etc/hostname

touch /etc/hosts
echo "127.0.0.1	localhost" >> /etc/hosts
echo "::1		localhost" >> /etc/hosts
echo "127.0.1.1	${HOSTNAME}.localdomain	${HOSTNAME}" >> /etc/hosts

echo "Set up password for root user..."
passwd

echo "Adding new user..."
read -p "Enter username: " USERNAME
useradd -m ${USERNAME}
echo "Set up password for ${USERNAME}."
passwd ${USERNAME}
usermod -aG wheel,audio,video,optical,storage ${USERNAME}

# Install the bootloader
echo ""
echo "Installing Grub Bootloader..."
echo ""

pacman -S grub efibootmgr dosfstools os-prober mtools

mkdir /boot/EFI
mount /dev/sda1 /boot/EFI
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager

# Install extra software
echo ""
echo "Installing more software..."
echo ""

pacman -S  vim man-db man-pages  networkmanager git

echo "Finished Installing Essential Packages... Exiting chroot."
exit