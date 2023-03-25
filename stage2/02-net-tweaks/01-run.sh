#!/bin/bash -e

## osss-monitor
install -v -d "${ROOTFS_DIR}/etc/hostapd"
install -v -m 600 -b files/hostapd.conf "${ROOTFS_DIR}/etc/hostapd/"
install -v -m 600 -b files/dnsmasq.conf "${ROOTFS_DIR}/etc/"
install -v -m 600 -b files/dhcpcd.conf "${ROOTFS_DIR}/etc/"

on_chroot << EOF
	echo "DAEMON_CONF=\"/etc/hostapd/hostapd.conf\"" >> /etc/default/hostapd
	echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

	SUDO_USER="${FIRST_USER_NAME}" systemctl enable dhcpcd
	SUDO_USER="${FIRST_USER_NAME}" systemctl enable dnsmasq

	SUDO_USER="${FIRST_USER_NAME}" sed -i -z 's/\[Service\]\n/\[Service\]\nExecStartPre=\/bin\/sleep 15\n/' /lib/systemd/system/hostapd.service
	SUDO_USER="${FIRST_USER_NAME}" systemctl daemon-reload
	SUDO_USER="${FIRST_USER_NAME}" systemctl enable hostapd
EOF
##
