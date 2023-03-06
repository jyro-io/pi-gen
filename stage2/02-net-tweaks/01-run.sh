#!/bin/bash -e

## osss-monitor
echo "DAEMON_CONF=\"/etc/hostapd/hostapd.conf\"" >> /etc/default/hostapd
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

install -v -d "${ROOTFS_DIR}/etc/hostapd"
install -v -m --backup 600 files/hostapd.conf "${ROOTFS_DIR}/etc/hostapd/"
install -v -m --backup 600 files/dnsmasq.conf "${ROOTFS_DIR}/etc/"
install -v -m --backup 600 files/dhcpcd.conf "${ROOTFS_DIR}/etc/"

on_chroot << EOF
	SUDO_USER="${FIRST_USER_NAME}" iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
	SUDO_USER="${FIRST_USER_NAME}" sh -c "iptables-save > /etc/iptables.ipv4.nat"
EOF

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
