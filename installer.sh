#!/bin/bash

if [[ ! -d /sys/firmware/efi/efivars ]]
then
    echo "System is not booted in UEFI mode."
    exit
fi

read -rp "Have you checked your Internet connection? "
read -rp "Have you formatted your disks? If not, do so now. "

echo "Enabling network time"
timedatectl set-ntp true
sleep 5

echo "---------------------------------"
lsblk -f
echo "---------------------------------"
read -rp "Enter the UEFI Boot partition: " UEFI
read -rp "Enter the operating system partition: " ROOT
read -rp "Enter the swap partition: " SWAP

mount "${ROOT}" /mnt
swapon "${SWAP}"

pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab

# Copy chroot.sh into the new system and run it
echo "-------------------------------------"
echo "chrooting into the new system"
echo "-------------------------------------"
cp chroot.sh /mnt/chroot.sh
chmod +x /mnt/chroot.sh
arch-chroot /mnt ./chroot.sh "${UEFI}" "${ROOT}"

# We are back out of the chroot
read -rp "Installation Completed. If you wish to make further changes, hit CTRL-C to leave partitions mounted. "
rm /mnt/chroot.sh
umount -l /mnt
echo ""
echo "Partitions were unmounted."
echo "You can remove installation media and reboot into the new system."
