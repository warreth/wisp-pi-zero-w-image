#!/usr/bin/env bash
set -euo pipefail

IMG="${1:?usage: validate-image.sh <image.img>}"
LOOP=""
MNT=""

cleanup() {
    if [ -n "$MNT" ] && mountpoint -q "$MNT"; then
        sudo umount "$MNT/boot/firmware" 2>/dev/null || true
        sudo umount "$MNT" 2>/dev/null || true
    fi
    if [ -n "$LOOP" ]; then
        sudo losetup -d "$LOOP" 2>/dev/null || true
    fi
    [ -n "$MNT" ] && rmdir "$MNT" 2>/dev/null || true
}
trap cleanup EXIT

LOOP=$(sudo losetup --show -fP "$IMG")
MNT=$(mktemp -d)

sudo mount -o ro "${LOOP}p2" "$MNT"
sudo mount -o ro "${LOOP}p1" "$MNT/boot/firmware"

test -x "$MNT/usr/local/bin/wispd"
test -f "$MNT/etc/systemd/system/wispd.service"
test -f "$MNT/etc/systemd/system/wisp-firstboot.service"
test -x "$MNT/usr/local/sbin/wisp-firstboot"
test -f "$MNT/boot/firmware/wisp.conf"
test -L "$MNT/etc/systemd/system/multi-user.target.wants/wispd.service"
test -L "$MNT/etc/systemd/system/multi-user.target.wants/wisp-firstboot.service"

file "$MNT/usr/local/bin/wispd" | grep -q 'ARM'
grep -q '^WISP_SERVER=' "$MNT/boot/firmware/wisp.conf"
grep -q '^WISP_NAME=' "$MNT/boot/firmware/wisp.conf"
grep -q '^WISP_WIFI_SSID=' "$MNT/boot/firmware/wisp.conf"

echo "Image validation OK: $IMG"
