#!/bin/bash -e

## osss-monitor
install -v -d "${ROOTFS_DIR}/etc/hostapd"
install -v -m -b 600 files/hostapd.conf "${ROOTFS_DIR}/etc/hostapd/"
install -v -m -b 600 files/dnsmasq.conf "${ROOTFS_DIR}/etc/"
install -v -m -b 600 files/dhcpcd.conf "${ROOTFS_DIR}/etc/"

on_chroot << EOF
	SUDO_USER="${FIRST_USER_NAME}" brctl addbr br0
	SUDO_USER="${FIRST_USER_NAME}" brctl addif br0 eth0
EOF

cat >> /etc/network/interfaces << EOL
auto br0
iface br0 inet manual
bridge_ports eth0 wlan0
EOL
##
