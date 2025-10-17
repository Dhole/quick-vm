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

Start the vm (the process will get detached):
```
./start-vm.sh
```

Ssh login (wait a few seconds until the vm has fully booted):
```
./ssh-vm.sh
```

Stop the vm:
```
./ssh-vm.sh doas poweroff
```

# Tips

You can automate waiting for the vm to be ready with this:
```
while ! (nc -i 1s localhost 2222 | grep SSH); do sleep 2; done
```

You can force stopping the vm with:
```
kill $(cat qemu-pid.txt)
```

# Credits

- The unattended install is heavily based on https://www.skreutz.com/posts/unattended-installation-of-alpine-linux/
- The qemu flags are based on https://tandiljuan.github.io/en/blog/2025/07/vm-guest-os-alpine/
