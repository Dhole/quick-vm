# quick-vm

Automated setup of an Alpine VM from scratch with qemu.

# Usage

Requirements: `qemu-img`, `qemu-system-x86_64`, `xorriso`, KVM-enabled kernel.

Prepare installation media:
```
./setup-iso.sh
```

Install Alpine to a disk image.  After boot you'll see the log of the install
script.  Upon completion the vm should poweroff automatically.
```
./install-vm.sh
```

Start the vm (password login is disabled, just leave this running):
```
./start-vm.sh
```

Ssh login:
```
./ssh-vm.sh
```

# Credits

- The unattended install is heavily based on https://www.skreutz.com/posts/unattended-installation-of-alpine-linux/
- The qemu flags are based on https://tandiljuan.github.io/en/blog/2025/07/vm-guest-os-alpine/
