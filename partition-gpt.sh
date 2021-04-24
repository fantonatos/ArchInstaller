#!/bin/sh

echo ""
lsblk -f
echo ""
read -p "Select a Disk [Example /dev/sda]: " DISK

echo "-------------------------------"
echo "Running sgdisk"
sgdisk -Z ${DISK}               # Erase partition table
sgdisk -a 2048 -o ${DISK}       # Create GUID Partition Table

sgdisk -n 1:0:+1000M ${DISK}    # Create 1000MB Boot partition
sgdisk -n 2:0:+9GB ${DISK}      # 9GB Swap
sgdisk -n 3:0:0 ${DISK}         # Filesystem

sgdisk -t 1:ef00 ${DISK}        # Set partition types
sgdisk -t 3:8200 ${DISK}
sgdisk -t 3:8300 ${DISK}

sgdisk -c 1:"UEFISYS" ${DISK}   # Apply partition labels
sgdisk -c 2:"SWAP" ${DISK}
sgdisk -c 3:"ROOT" ${DISK}

echo "-------------------------------"
echo "Format Partitions and Make Swap"
mkfs.vfat -F32 -n "UEFISYS" "${DISK}1"      # Format partitions
mkswap ${DISK}2
swapon ${DISK}2
mkfs.ext4 -L "ROOT" "${DISK}3"

echo "-------------------------------------------"
echo "${DISK}: Created and formatted partitions."
echo "${DISK}1: UEFI Boot Partition"
echo "${DISK}2: Linux Swap"
echo "${DISK}3: ext4"
