#!/bin/bash -e

## osss-monitor
echo "DAEMON_CONF=\"/etc/hostapd/hostapd.conf\"" >> /etc/default/hostapd
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

install -v -d "${ROOTFS_DIR}/etc/hostapd"
install -v -m 600 -b files/hostapd.conf "${ROOTFS_DIR}/etc/hostapd/"
install -v -m 600 -b files/dnsmasq.conf "${ROOTFS_DIR}/etc/"
install -v -m 600 -b files/dhcpcd.conf "${ROOTFS_DIR}/etc/"

on_chroot << EOF
	SUDO_USER="${FIRST_USER_NAME}" update-alternatives --set iptables /usr/sbin/iptables-legacy
	SUDO_USER="${FIRST_USER_NAME}" iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
	SUDO_USER="${FIRST_USER_NAME}" sh -c "iptables-save > /etc/iptables.ipv4.nat"
EOF
##
