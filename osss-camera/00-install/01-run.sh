#!/bin/bash -e

install -v -d "${ROOTFS_DIR}/opt/osss"
install -v -m 600 files/osss-camera "${ROOTFS_DIR}/opt/osss/"
install -v -m 600 files/config.yaml "${ROOTFS_DIR}/opt/osss/"
install -v -m 600 files/osss-camera.service "${ROOTFS_DIR}/lib/systemd/system/"

chmod -v +x ${ROOTFS_DIR}/opt/osss/osss-camera

on_chroot << EOF
	SUDO_USER="${FIRST_USER_NAME}" systemctl enable osss-camera
EOF

