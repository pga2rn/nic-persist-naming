#!/bin/bash

# predictable interfacing naming on openwrt using hotplug
# using net hook
# example:
# /devices/pci0000:00/0000:00:0a.2/net/eth3 (with dev_port 2)
# enp0s10f2d2

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

# build the ID_NET_NAME_PATH
ID_NET_NAME_PATH=enp${p}s${s}
[ $f != 0 ] && ID_NET_NAME_PATH=${ID_NET_NAME_PATH}f${f}

# export new dev name
echo $ID_NET_NAME_PATH

exit 0