# ArchInstaller

Very simple and fast way to install ArchLinux. Runs in about 5 minutes on my PC and Internet connection.

# Specs

Minimal installation:
 - Linux kernel, glibc, coreutils, binutils, systemd
 - bash, ssh, git, vim and nano
 - Microcode for Intel® CPUs
 - systemd-networkd, systemd-resolved, and iwd for networking
 - systemd-boot bootloader
 - Enough programs to have a mostly POSIX-compliant PC

Complete installation:
 - GNOME desktop environment, firefox
 - Proprietary nvidia graphics drivers
 - Fonts and wallpapers

# Steps
0. Get the scripts

	You can do that by installing git and cloning this repo, or curl'ing the files in this repo.

1. Partition and format your drives
   
	This script will not format any partitions. Use whatever file system you like.

2. Run `./installer.sh <boot> <swap> <root>` 
   
	`boot`, `swap`, and `root` are paths to the partitions you want to use. For example, /dev/sda1.

The script will first install a minimally working system, you can finish at that point or continue to install a desktop environment.

## Example:

```
git clone https://github.com/fantonatos/ArchInstaller.git && cd ArchInstaller
chmod +x installer.sh
./installer.sh
```

You will be prompted several times to enter system-specific information. When the scripts indicate that the installation is complete, you can remove the installation media and reboot into the working system.

# Issues:

 - The eduroam JoinNow script uses NetworkManager, which this script does not install.