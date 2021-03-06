echo ""
lsblk -f
echo ""
echo "Select the Operating System Partition: "
read DISK
echo "Select the Swap Partition: "
read SWAPDISK

mount ${DISK} /mnt
swapon ${SWAPDISK}

pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab

# Copy chroot.sh to the new system and run the script
cp chroot.sh /mnt/chroot.sh
chmod +x /mnt/chroot.sh
arch-chroot /mnt ./chroot.sh

# We are back out of the chroot.
rm /mnt/chroot.sh
umount -l /mnt
echo ""
echo "Installation Complete."
echo "Please remove installation media and reboot."