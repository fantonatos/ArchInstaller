#!/bin/sh

read -p "Have you checked your Internet connection? "
read -p "Have you formatted your disks? If not, do so now. "

echo "Syncing time" 
timedatectl set-ntp true
sleep 5

echo "-------------------"
echo "Updating packages"
pacman -Sy --noconfirm

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
read -p "Installation Completed. If you wish to make further changes, hit CTRL-C to leave partitions mounted. "
rm /mnt/chroot.sh
umount -l /mnt
echo "====================================="
echo "Partitions were unmounted."
echo "You can remove installation media and reboot."
