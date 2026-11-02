#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

# Keep the image lean. These packages are not needed on a headless audio node.
apt-get -y purge \
    build-essential manpages-dev gdb pkg-config \
    ncdu htop strace ntfs-3g p7zip-full zip unzip \
    rpi-connect-lite man-db || true
apt-get -y autoremove || true
rm -rf /usr/share/doc/* /usr/share/man/* /var/cache/apt/archives/* /var/lib/apt/lists/*
