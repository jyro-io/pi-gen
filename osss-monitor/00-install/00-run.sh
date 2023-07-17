#!/bin/bash -e

install -v -d "${ROOTFS_DIR}/opt/osss"
install -v -m 600 files/go.mod "${ROOTFS_DIR}/opt/osss/"
install -v -m 600 files/go.sum "${ROOTFS_DIR}/opt/osss/"
install -v -m 600 files/main.go "${ROOTFS_DIR}/opt/osss/"
install -v -m 600 files/config.yaml "${ROOTFS_DIR}/opt/osss/"
install -v -m 600 files/osss-monitor.service "${ROOTFS_DIR}/lib/systemd/system/"

on_chroot << EOF
	# install gocv
	cd /opt/osss
	if [ ! -d "/opt/osss/gocv" ]; then
		git clone --branch release https://github.com/hybridgroup/gocv.git
	fi
	cd gocv && \
	git checkout --force 7811007fdb9f8ea1a32db0913846361be05d4973 && \
	SUDO_USER="${FIRST_USER_NAME}" make -j 4 install_raspi

	# build osss-monitor
	SUDO_USER="${FIRST_USER_NAME}" cd /opt/osss/ && \
	go mod edit -go=1.15 && \
	go mod tidy && \
	env GOOS=linux GOARCH=arm GOARM=5 go build -o osss-monitor .

	SUDO_USER="${FIRST_USER_NAME}" systemctl enable osss-monitor
EOF

chmod -v +x ${ROOTFS_DIR}/opt/osss/osss-monitor
