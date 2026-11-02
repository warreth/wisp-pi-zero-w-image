#!/bin/bash -e

install -d "${ROOTFS_DIR}/usr/local/bin"
install -d "${ROOTFS_DIR}/usr/local/sbin"
install -d "${ROOTFS_DIR}/etc/systemd/system"
install -d "${ROOTFS_DIR}/etc/systemd/system/wispd.service.d"
install -d "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants"
install -d "${ROOTFS_DIR}/boot/firmware"

install -m 755 files/wispd "${ROOTFS_DIR}/usr/local/bin/wispd"
install -m 644 files/wispd.service "${ROOTFS_DIR}/etc/systemd/system/wispd.service"
install -m 755 files/wisp-firstboot "${ROOTFS_DIR}/usr/local/sbin/wisp-firstboot"
install -m 644 files/wisp-firstboot.service "${ROOTFS_DIR}/etc/systemd/system/wisp-firstboot.service"
install -m 644 files/wispd-after-firstboot.conf "${ROOTFS_DIR}/etc/systemd/system/wispd.service.d/after-firstboot.conf"
install -m 644 files/wisp.conf "${ROOTFS_DIR}/boot/firmware/wisp.conf"

ln -sf /etc/systemd/system/wispd.service \
    "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/wispd.service"
ln -sf /etc/systemd/system/wisp-firstboot.service \
    "${ROOTFS_DIR}/etc/systemd/system/multi-user.target.wants/wisp-firstboot.service"
