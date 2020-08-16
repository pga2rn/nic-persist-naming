#!/bin/bash

#
LIB="/usr/bin/genifname.sh"
NET_CLASS_DIR="/sys/class/net"

LOGGER="logger -t renameif "
IP="/sbin/ip "

# scan through all interfaces and try to rename non-renamed interfaces
nr_if=($($IP l | grep -o -e ' eth[0-9]\{1,\}:' | sed -e "s@:@@g"))

# try to rename
for i in ${nr_if[@]}
do
    export DEVPATH=$(readlink -f $NET_CLASS_DIR/$i)
    export DEVNAME=$i
    NNAME=$(env "$LIB")
    $LOGGER "$LIB: finished. New device name is $NNAME."
    $IP l set $i name $NNAME && \
        $LOGGER "$NNAME: rename from $i." || \
        $LOGGER "Failed to rename $i."
done

exit 0