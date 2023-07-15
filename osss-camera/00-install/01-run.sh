#!/bin/bash -e

install -v -d "${ROOTFS_DIR}/opt/osss"

# install gocv
cd "${ROOTFS_DIR}/opt/osss" && \
git clone https://github.com/hybridgroup/gocv.git && \
cd gocv && \
make install_raspi

# build osss-camera
install -v -m 600 files/go.mod "${ROOTFS_DIR}/opt/osss/" && \
install -v -m 600 files/main.go "${ROOTFS_DIR}/opt/osss/" && \
go mod tidy && \
env GOOS=linux GOARCH=arm GOARM=5 go build -o osss-camera . && \
chmod -v +x ${ROOTFS_DIR}/opt/osss/osss-camera

install -v -m 600 files/config.yaml "${ROOTFS_DIR}/opt/osss/"
install -v -m 600 files/osss-camera.service "${ROOTFS_DIR}/lib/systemd/system/"

on_chroot << EOF
	SUDO_USER="${FIRST_USER_NAME}" systemctl enable osss-camera
EOF

