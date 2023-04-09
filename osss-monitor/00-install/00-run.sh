#!/bin/bash -e

install -v -d "${ROOTFS_DIR}/opt/osss"
install -v -m 600 files/osss-monitor "${ROOTFS_DIR}/opt/osss/"
install -v -m 600 files/config.yaml "${ROOTFS_DIR}/opt/osss/"
install -v -m 600 files/osss-monitor.service "${ROOTFS_DIR}/lib/systemd/system/"

install -v -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config/autostart/"
install -v -m 600 files/camera-stream.desktop "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config/autostart/"

chmod -v +x ${ROOTFS_DIR}/opt/osss/osss-monitor

on_chroot << EOF
	SUDO_USER="${FIRST_USER_NAME}" chown -Rv ${FIRST_USER_NAME}:${FIRST_USER_NAME} /home/${FIRST_USER_NAME}/.config
	SUDO_USER="${FIRST_USER_NAME}" systemctl enable osss-monitor
EOF
