echo "Select a disk: "
lsblk
echo ""
read DISK

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

mkfs.vfat -F32 -n "UEFISYS" "${DISK}1"      # Format partitions
mkswap "${DISK}2"
mkfs.ext4 -L "ROOT" "${DISK}3"
