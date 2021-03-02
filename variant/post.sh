#!/bin/bash

set -x
set -e

env

. /usr/share/debootstrap/functions

cat > "$TARGET/etc/apt/sources.list.d/local.list" <<EOF
deb $MIRROR stretch main
deb [trusted=yes] $APT stretch main
EOF
if [[ "${DIST##*-}" == "updates" ]]; then
  echo "deb [trusted=yes] $APT stretch-updates main" >> "$TARGET/etc/apt/sources.list.d/apt.list"
fi

in_target_nofail busybox --install -s
rm -vf $TARGET/usr/bin/readlink

in_target_nofail apt-get -oAcquire::https::Verify-Peer=false update
in_target_nofail apt-get -oAcquire::https::Verify-Peer=false -y install $PACKAGES

in_target_nofail busybox --install -s
rm -vf $TARGET/usr/bin/readlink

in_target_nofail update-rc.d mountkernfs defaults
in_target_nofail update-rc.d networking defaults
in_target_nofail update-rc.d httpd defaults

patch $TARGET/etc/nsswitch.conf <<EOF
12c12
< hosts:          files mdns4_minimal [NOTFOUND=return] dns myhostname
---
> hosts:          files mdns6_minimal mdns4_minimal [NOTFOUND=return] dns mdns6 mdns4 myhostname
EOF

patch $TARGET/etc/default/llmnrd <<EOF
10c10
< DAEMON_ARGS="-6"
---
> DAEMON_ARGS="-6 -H \$(hostname -s)"
EOF

sed -i "s/^rlimit-nproc=3$/#rlimit-nproc=3/" $TARGET/etc/avahi/avahi-daemon.conf

echo "root:root" | in_target chpasswd

in_target_nofail apt-get -q clean

rm -v "$TARGET/etc/dropbear/dropbear_rsa_host_key" "$TARGET/etc/hostname" "$TARGET/etc/resolv.conf"
rmdir "$TARGET/var/tmp"
ln -sf /tmp "$TARGET/var/"
rm -f "$TARGET/etc/apt/sources.list.d/apt.list"
