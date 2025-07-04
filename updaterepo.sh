#!/bin/bash
mount /dev/sr0 /mnt || echo please connect the ISO file as CDRom drive in virtualbox

# removing current read-only stuff
umount /repo
sed -i '/repo/' /etc/fstab

# generating repo index files
dnf install -y createrepo

createrepo --update /repo/BaseOS
createrepo --update /repo/AppStream
