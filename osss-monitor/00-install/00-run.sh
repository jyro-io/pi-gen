#!/bin/bash -e

install -v -d "${ROOTFS_DIR}/opt/osss"
install -v -m 600 files/osss-monitor "${ROOTFS_DIR}/opt/osss/"
install -v -m 600 files/config.yaml "${ROOTFS_DIR}/opt/osss/"
install -v -m 600 files/osss-monitor.service "${ROOTFS_DIR}/lib/systemd/system/"

on_chroot << EOF
	systemctl enable osss-monitor
	update-alternatives --set iptables /usr/sbin/iptables-legacy
	ufw enable
	ufw allow from 192.168.0.0/24 to any port 7777
EOF
