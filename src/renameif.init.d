#!/bin/sh /etc/rc.common
USE_PROCD=1
# execute this scripts before any network related programs init.
# right in front of dnsmasq start
START=18
#PROCD_DEBUG=1

NAME="renameif"
PROG="/usr/bin/renameif.sh"
RUN_DIR="/var/run"

start_service() {
    # init and open service instance
    procd_open_instance renameif

    procd_set_param command "$PROG"

    # redirect log to syslog
    procd_set_param stdout 1
    procd_set_param stderr 1

    procd_close_instance
}