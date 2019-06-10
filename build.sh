#!/bin/sh

if [ $# -gt 0 ]; then
    echo "Build from scratch."
    ./boot.sh
    ./configure --with-linux=/lib/modules/$(uname -r)/build
fi
make -j `nproc`
if [ $? -ne 0 ]; then
    exit 0
fi
dmesg -c >/dev/null
make install
make modules_install
rm -f /usr/local/var/log/openvswitch/ovs-vswitchd.log
ovs-ctl force-reload-kmod
ip link set dev ovs-system up
ip link set dev br0 up
ip addr add 1.2.3.4/24 dev br0
