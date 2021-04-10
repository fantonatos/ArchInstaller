#!/bin/sh

read -p "Device to Partition: " DEV
echo "-----------------------------"

# Create MBR and partitions
echo "Running sfdisk"
sfdisk -qf $DEV << STOP
label: dos

${DEV}1 : size= +7GB, type= 83, bootable
${DEV}2 : type= 82
STOP

echo "-------------------------------"
echo "Format Partitions and Make Swap"
mkfs.ext4 -F ${DEV}1
mkswap -f ${DEV}2

echo "-------------------------------------------"
echo "${DEV}: Created and formatted partitions."
echo "${DEV}1: ext4"
echo "${DEV}2: Linux Swap"
