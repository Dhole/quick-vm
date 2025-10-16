#!/bin/sh

set -ex

ALPINE_ISO="alpine-unattended.iso"
IMAGE_FILE="alpine.img"
IMAGE_SIZE="5G"

qemu-img create -f qcow2 "${IMAGE_FILE}" "${IMAGE_SIZE}"

qemu-system-x86_64  \
  -machine accel=kvm \
  -cpu host \
  -m 1G \
  -device virtio-net-pci,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
  -cdrom "${ALPINE_ISO}" \
  -drive if=virtio,format=qcow2,file="${IMAGE_FILE}" \
  -nographic
