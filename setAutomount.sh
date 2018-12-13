#!/bin/bash

# A script for setting up  automount

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

NFS_IP="192.168.0.152"

apt install autofs

# Setup the /mnt directory as location of autofs
echo "Settin up /etc/auto.mnt"
echo "/mnt /etc/auto.mnt" >> /etc/auto.master

# Create the mount points
echo "Creating mount points"
echo "nfs1 -fstype=nfs4 $NFS_IP:/nfs1" >> /etc/auto.mnt
echo "nfs2 -fstype=nfs4 $NFS_IP:/nfs2" >> /etc/auto.mnt
echo "nfs3 -fstype=nfs4 $NFS_IP:/nfs3" >> /etc/auto.mnt
echo "nfs4 -fstype=nfs4 $NFS_IP:/nfs4" >> /etc/auto.mnt
echo "Mount points created"

# Comment out static mounts from fstab
echo "Disabling old fstab setup"
sed -i 's/192.168.0.152/#192.168.0.152/' /etc/fstab

# Unmount the static mounts
echo "Unmounting current NFS storages"
if grep -qs "/mnt/nfs1" /proc/mounts; then
  umount /mnt/nfs1
fi

if grep -qs "/mnt/nfs2" /proc/mounts; then
  umount /mnt/nfs2
fi

if grep -qs "/mnt/nfs3" /proc/mounts; then
  umount /mnt/nfs3
fi

if grep -qs "/mnt/nfs4" /proc/mounts; then
  umount /mnt/nfs4
fi
echo "Unmounting complete."

echo "Starting autofs"
sudo /etc/init.d/autofs reload
echo "setAutoMount.sh finished."
