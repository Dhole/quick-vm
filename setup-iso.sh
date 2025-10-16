#!/bin/sh

set -ex

# Based on https://www.skreutz.com/posts/unattended-installation-of-alpine-linux/

VERSION="3.22"
VERSION_MINOR="2"
ALPINE_ISO="alpine-virt-${VERSION}.${VERSION_MINOR}-x86_64.iso"

if [ ! -f ${ALPINE_ISO} ]; then
    curl --location --remote-name-all \
        https://dl-cdn.alpinelinux.org/alpine/v${VERSION}/releases/x86_64/${ALPINE_ISO}
fi

# Clean up previous files
rm -r ovl || true
rm answers || true
mv -b id_ed25519 id_ed25519.bak || true
mv -b id_ed25519.pub id_ed25519.pub.bak || true
rm localhost.apkovl.tar.gz || true
rm alpine-unattended.iso || true

# create a so-called overlay file. This is essentially a tarball to be
# extracted in the file system root. See the wiki page on Alpine’s local backup
# utility.
mkdir ovl

# Enable the default boot services as described in
# https://wiki.alpinelinux.org/w/index.php?title=How_to_make_a_custom_ISO_image_with_mkimage&oldid=25379#Create_the_ISO
mkdir -p ovl/etc
touch ovl/etc/.default_boot_services

# Enable the local service. This service will run our custom installation script on boot.
mkdir -p ovl/etc/runlevels/default
ln -sf /etc/init.d/local ovl/etc/runlevels/default

# Configure the APK repositories
mkdir -p ovl/etc/apk
cat > ovl/etc/apk/repositories << EOF
/media/cdrom/apks
https://dl-cdn.alpinelinux.org/alpine/v${VERSION}/main
https://dl-cdn.alpinelinux.org/alpine/v${VERSION}/community
EOF

# Add our custom installation script ovl/etc/local.d/auto-setup-alpine.start.
# Feel free to adapt the script to your personal needs. Take care though. You
# cannot see the script's output on the console.
mkdir -p ovl/etc/local.d
cp auto-setup-alpine.start ovl/etc/local.d/auto-setup-alpine.start
chmod 755 ovl/etc/local.d/auto-setup-alpine.start

ssh-keygen -t ed25519 -N '' -f id_ed25519
cp answers.tmpl answers
sed -i.bak "s#{{SSHKEY}}#$(cat id_ed25519.pub)#g" answers
rm answers.bak

mkdir -p ovl/etc/auto-setup-alpine
cp answers ovl/etc/auto-setup-alpine/answers

# Create the actual overlay file using GNU tar
tar --owner=0 --group=0 -czf localhost.apkovl.tar.gz -C ovl .

# Add the overlay file to the ISO 9660 image using GNU xorriso. Note that the
# prefix of the overlay file name must be the hostname of the target machine,
# in this case localhost.
xorriso \
  -indev ${ALPINE_ISO} \
  -outdev alpine-unattended.iso \
  -map localhost.apkovl.tar.gz /localhost.apkovl.tar.gz \
  -boot_image any replay
