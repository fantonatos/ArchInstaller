#!/bin/bash
# Script to automate the ArchLinux installation process.
# Usage: installer.sh <boot> <swap> <root>

if [ "$#" -ne 3 ]; then
    echo "Usage: installer.sh <boot> <swap> <root>"
    echo "    boot, swap, root:"
    echo "      Path to device (/dev/device_name)"
    exit
fi

if [[ ! -d /sys/firmware/efi/efivars ]]
then
    echo "System is not booted in UEFI mode."
    exit
fi

UEFI=$1
SWAP=$2
ROOT=$3
echo "boot partition: ${UEFI:?}"
echo "swap partition: ${SWAP:?}"
echo "root partition: ${ROOT:?}"

read -rp "Are these correct? "
read -rp "Have you checked your Internet connection? "
read -rp "Have you partitioned and formatted your disks? "
read -rp "Proceed with the installation? Press CTRL-C to cancel. "

echo "Enabling network time"
timedatectl set-ntp true

mount "${ROOT}" /mnt
mkdir -p /mnt/boot && mount "${UEFI}" /mnt/boot
swapon "${SWAP}"

pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab

# 1st chroot: Copy chroot.sh into the new system and run it
echo "-------------------------------------"
echo "chrooting into the new system"
echo "-------------------------------------"
cp -r files/ /mnt/
cp chroot.sh /mnt/chroot.sh
chmod +x /mnt/chroot.sh
arch-chroot /mnt ./chroot.sh "${UEFI}" "${ROOT}"

# We are back out of the chroot
rm /mnt/chroot.sh
rm -rf /mnt/files/
echo ""
echo "Minimal installation completed."
echo "Next step will install xorg and GNOME desktop."
read -rp "If you wish to make further changes, or do not want a graphical environment, press CTRL-C to exit and leave partitions mounted. "

# 2nd chroot: run desktop.sh
cp desktop.sh /mnt/desktop.sh
arch-chroot /mnt ./desktop.sh "$(ls /home)"
rm /mnt/desktop.sh


read -rp "Full installation completed. If you need to make further changes, press CTRL-C to exit and leave partitions mounted. "
umount -l /mnt
echo ""
echo "Partitions were unmounted."
echo "You can remove installation media and reboot into the new system."

