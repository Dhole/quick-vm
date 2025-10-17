#!/bin/sh

set -ex

IMAGE_FILE="alpine.img"

qemu-system-x86_64  \
  -machine accel=kvm \
  -cpu host \
  -m 1G \
  -device virtio-net-pci,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp::2222-:22 \
  -drive if=virtio,format=qcow2,file="${IMAGE_FILE}" \
  -display none \
  -daemonize \
  -pidfile qemu-pid.txt
  # -nographic


