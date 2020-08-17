#!/bin/bash

#
LIB="/usr/bin/genifname.sh"
NET_CLASS_DIR="/sys/class/net"

LOGGER="logger -t renameif "
IP="/sbin/ip "

# scan through all interfaces and try to rename all the interfaces with ethX naming.
nr_if=($($IP l | grep -o -e ' eth[0-9]\{1,\}:' | sed -e "s@:@@g"))

# try to rename the interfaces we found.
for i in ${nr_if[@]}
do
    # strip the leading "/sys" from the DEVPATH retrieved from init.d script.
    export DEVPATH=$(readlink -f $NET_CLASS_DIR/$i | sed -e 's@/sys@@')
    export DEVNAME=$i
    NNAME=$(env "$LIB")
    $LOGGER "$LIB: finished. New device name is $NNAME."
    $IP l set $i name $NNAME || \
        $LOGGER "ERROR! Failed to rename $i."
done

exit 0