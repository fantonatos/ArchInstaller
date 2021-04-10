#!/bin/sh

read -p "Have you checked your Internet connection? "
read -p "Have you formatted your disks? If not, do so now. "

echo "Syncing time" 
timedatectl set-ntp true
sleep 5

echo "-------------------"
echo "Updating packages"
pacman -Syu --noconfirm

echo "---------------------------------"
lsblk -f
echo "---------------------------------"
read -p "Select the operating system partition: " DISK
read -p "Select the swap partition: " SWAP

mount ${DISK} /mnt
swapon ${SWAP}

pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab

# Copy chroot.sh into the new system and run it
echo "-------------------------------------"
echo "chrooting into the new system"
echo "-------------------------------------"
cp chroot.sh /mnt/chroot.sh
chmod +x /mnt/chroot.sh
arch-chroot /mnt ./chroot.sh

# We are back out of the chroot
rm /mnt/chroot.sh
umount -l /mnt
echo "====================================="
echo "Installation scripts done."
echo "Remove installation media and reboot."
