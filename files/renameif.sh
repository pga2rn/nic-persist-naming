#!/bin/ash

#
LIB="/usr/bin/genifname.sh"
NET_CLASS_DIR="/sys/class/net"

LOGGER="logger -t nic-persist-naming "

# scan through all interfaces and try to rename all the interfaces with ethX naming.
echo "$(ip l | grep -o "eth[0-9]\+")" | while read i
do
	# strip the leading "/sys" from the DEVPATH retrieved from init.d script.
	export DEVPATH=$(readlink -f $NET_CLASS_DIR/$i | sed -e 's@/sys@@')
	export DEVNAME=$i
	NNAME=$(env "$LIB")
	$LOGGER "$LIB: New device name is $NNAME."
	ip l set $i name $NNAME || $LOGGER "ERROR! Failed to rename $i."
done

exit 0