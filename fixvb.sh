#!/bin/bash

set -e

echo "🛠️ Installing required packages..."
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y kernel-headers kernel-devel elfutils-libelf-devel perl gcc bzip2 make

echo "🔍 Checking kernel version and headers..."
KERNEL_VERSION=$(uname -r)
HEADER_VERSION=$(rpm -q --qf "%{VERSION}-%{RELEASE}\n" kernel-devel)

if [[ "$KERNEL_VERSION" != "$HEADER_VERSION"* ]]; then
    echo "⚠️ Kernel headers don't match the running kernel."
    echo "➡️ Updating kernel and rebooting first..."
    sudo dnf update -y kernel kernel-devel
    echo "✅ Update done. Please reboot and rerun this script after reboot:"
    echo "sudo bash install-vbox-guest-additions.sh"
    exit 1
fi

echo "💿 Mounting Guest Additions ISO..."
sudo mkdir -p /mnt/cdrom
sudo mount /dev/cdrom /mnt/cdrom || { echo "❌ Failed to mount Guest Additions. Did you insert the ISO?"; exit 1; }

echo "▶️ Running Guest Additions installer..."
sudo /mnt/cdrom/VBoxLinuxAdditions.run || {
    echo "❌ Installation failed. Check if the Guest Additions ISO is correct and try again."
    exit 1
}

echo "✅ Guest Additions installed successfully."

echo ""
echo "🔁 Please reboot your VM to activate screen resizing:"
echo "sudo reboot"

