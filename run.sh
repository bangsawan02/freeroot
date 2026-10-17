#!/bin/sh

ROOTFS_DIR=$(pwd)
export PATH=$PATH:~/.local/usr/bin
max_retries=50
timeout=1
ARCH=$(uname -m)

if [ "$ARCH" = "x86_64" ]; then
  ARCH_ALT=amd64
elif [ "$ARCH" = "aarch64" ]; then
  ARCH_ALT=arm64
else
  printf "Unsupported CPU architecture: ${ARCH}\n"
  exit 1
fi

if [ ! -e "$ROOTFS_DIR/.installed" ]; then
  if [ ! -f "$ROOTFS_DIR/rootfs.tar.gz" ]; then
    echo "rootfs.tar.gz not found in $ROOTFS_DIR"
    exit 1
  fi
  echo "Extracting Ubuntu rootfs..."
  tar -xzf "$ROOTFS_DIR/rootfs.tar.gz" -C "$ROOTFS_DIR"
fi

mkdir -p "$ROOTFS_DIR/usr/local/bin"
if [ ! -x "$ROOTFS_DIR/usr/local/bin/proot" ]; then
  echo "proot binary not found after extraction."
  exit 1
fi
chmod 755 "$ROOTFS_DIR/usr/local/bin/proot"

mkdir -p "$ROOTFS_DIR/etc"
printf "nameserver 1.1.1.1\nnameserver 1.0.0.1" > "$ROOTFS_DIR/etc/resolv.conf"
touch "$ROOTFS_DIR/.installed"

CYAN='\e[0;36m'
WHITE='\e[0;37m'
RESET_COLOR='\e[0m'

display_gg() {
  echo -e "${WHITE}___________________________________________________${RESET_COLOR}"
  echo -e ""
  echo -e "           ${CYAN}-----> Mission Completed ! <----${RESET_COLOR}"
  echo -e ""
  echo -e "${WHITE}___________________________________________________${RESET_COLOR}"
}

clear
display_gg

exec "$ROOTFS_DIR/usr/local/bin/proot" \
  --rootfs="${ROOTFS_DIR}" \
  -0 -w "/root" -b /dev -b /sys -b /proc -b /etc/resolv.conf --kill-on-exit "$@"