# ArchInstaller

After booting into the official Arch Linux installation media, check your internet connection and partition and format your disks. Update your package repositories and install git with `pacman -Syu git`, then download and run the installer with these commands:

```
git clone https://github.com/fantonatos/ArchInstaller.git && cd ArchInstaller
chmod +x installer.sh
./installer.sh
```

You will be prompted several times to enter system-specific information. When the scripts indicate that the installation is complete, you can remove the installation media and reboot into the working system.
