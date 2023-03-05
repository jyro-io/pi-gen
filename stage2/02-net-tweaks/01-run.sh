#!/bin/bash -e

## osss-monitor
install -v -d "${ROOTFS_DIR}/etc/hostapd"
install -v -m -b 600 files/hostapd.conf "${ROOTFS_DIR}/etc/hostapd/"
install -v -m -b 600 files/dnsmasq.conf "${ROOTFS_DIR}/etc/"
install -v -m -b 600 files/dhcpcd.conf "${ROOTFS_DIR}/etc/"
cat >> /etc/network/interfaces << EOL
auto br0
iface br0 inet manual
bridge_ports eth0 wlan0
EOL
##
