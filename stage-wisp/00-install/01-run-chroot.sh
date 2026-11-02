#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

# Never ship a usable default password. Replace the build-time password with
# a random one, then lock it. firstboot unlocks it only for key-only SSH.
if id wisp >/dev/null 2>&1; then
    RANDOM_PASSWORD=$(head -c 32 /dev/urandom | base64 | tr -d '\n')
    echo "wisp:${RANDOM_PASSWORD}" | chpasswd
fi
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
