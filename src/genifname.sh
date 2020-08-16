#!/bin/bash

# needed env vars
# DEVPATH, DEVNAME

# predictable interfacing naming on openwrt using hotplug
# using net hook
# example:
# /devices/pci0000:00/0000:00:0a.2/net/eth3 (with dev_port 2)
# enp0s10f2d2
# meanwhile, function 0 of this multiport nic should be: enp0s10f0

# sys_class_net
NET_CLASS_DIR="/sys/class/net"
# ethernet device
NET_PREFIX="en"

# get pci slot
pci_slot=$(echo $DEVPATH | sed -e "s@/@\n@g" | grep "[0-9a-fA-F]\{4\}:[0-9a-fA-F]\{2\}" | tail -n1)
# pslot: 0000:xx:xx.x
p=$( printf "%d" \
    "0x$(echo $pci_slot | cut -d':' -f2)"
    )
# slot and function
sf=$(echo $pci_slot | cut -d':' -f3)
s=$( printf "%d" \
    "0x$(echo $sf | cut -d'.' -f1)"
    )
f=$( printf "%d" \
    "0x$(echo $sf | cut -d'.' -f2)"
    )

# check if the nic has multiple ports
# generate DEVPATH for port 1, and check whether it exists or not
p1pci_slot=$(echo $pci_slot | sed -e 's@\.[0-9a-fA-F]\{1,\}@\.1@')
p1dev_path=$(echo $DEVPATH | sed -e "s@$pci_slot@\|@" | cut -d'|' -f1)$p1pci_slot
# if the dev_path for nic port 1 exists, we treat this nic as an multi ports nic.
[ -n "$p1dev_path" -a -d "/sys$p1dev_path" ] && mp=1

# get dev_port
d=$(cat $NET_CLASS_DIR/$DEVNAME/dev_port)

# build the ID_NET_NAME_PATH
ID_NET_NAME_PATH=enp${p}s${s}
[ "$f" != "0" -o "$mp" == "1" ] && ID_NET_NAME_PATH=${ID_NET_NAME_PATH}f$f
[ -n "$d" -a "$d" != "0" ] && ID_NET_NAME_PATH=${ID_NET_NAME_PATH}d$d

# export new dev name
echo $ID_NET_NAME_PATH

exit 0