#!/bin/bash -e

install -v -d "${ROOTFS_DIR}/usr/local/etc/motion/"
install -v -d "${ROOTFS_DIR}/opt/osss"
install -v -m 600 files/osss-camera "${ROOTFS_DIR}/opt/osss/"
install -v -m 600 files/config.yaml "${ROOTFS_DIR}/opt/osss/"
install -v -m 600 files/osss-camera.service "${ROOTFS_DIR}/lib/systemd/system/"
install -v -m 600 files/motion.service "${ROOTFS_DIR}/lib/systemd/system/"

install -v -d "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/videos"
install -v -d "${ROOTFS_DIR}/var/log/motion"
install -v -m 600 files/motion.conf "${ROOTFS_DIR}/etc/motion/"

chmod -v +x ${ROOTFS_DIR}/opt/osss/osss-camera

on_chroot << EOF
	SUDO_USER="${FIRST_USER_NAME}" systemctl enable osss-camera
	SUDO_USER="${FIRST_USER_NAME}" systemctl enable motion
	chown -Rv motion:motion /var/log/motion /home/${FIRST_USER_NAME}/videos /etc/motion
EOF

