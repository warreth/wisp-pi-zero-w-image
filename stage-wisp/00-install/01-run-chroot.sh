#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

# Never ship a usable default password. firstboot unlocks the account only
# when WISP_SSH_KEY is set (key-only SSH).
if grep -q '^wisp:' /etc/shadow && ! grep -q '^wisp:!' /etc/shadow; then
    sed -i 's/^wisp:/wisp:!/' /etc/shadow
fi

# Keep the image lean. These packages are not needed on a headless audio node.
apt-get -y purge \
    build-essential manpages-dev gdb pkg-config \
    ncdu htop strace ntfs-3g p7zip-full zip unzip \
    rpi-connect-lite man-db || true
apt-get -y autoremove || true
rm -rf /usr/share/man/* /var/cache/apt/archives/* /var/lib/apt/lists/*
