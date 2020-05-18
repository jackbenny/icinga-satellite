#!/bin/bash

# If parent CN is not specified, default it to the parent host.
# If the zone is not specified, default it to the CN of the satellite/agent.
# Use the default port if none is specified.

if [ -z "$PARENTCN" ]; then
    PARENTCN="$PARENTHOST"
fi

if [ -z "$ZONE" ]; then
    ZONE="$CN"
fi

if [ -z "$PARENTPORT" ]; then
    PARENTPORT=5665
fi

# Set accept config and accept commands (defaults to no)
if [ "$ACCEPT_CONFIG" == "y" ]; then
    ACCEPT_CONF="--accept-config"
else
    ACCEPT_CONF=" "
fi

if [ "$ACCEPT_COMMANDS" == "y" ]; then
    ACCEPT_COMM="--accept-commands"
else
    ACCEPT_COMM=" "
fi

# Support for ticket via secrets for Docker Swarm
if [ ! -z "$TICKET_PATH" ]; then
    TICKET=$(cat $TICKET_PATH)
fi

# Defaults to disable conf.d (so use "n" or anything else other than "y" 
# to enable inclusion of conf.d directory)
if [ -z "$DISABLE_CONFD" ] || [ "$DISABLE_CONFD" == "y" ]; then
    DISABLE_CONF="--disable-confd"
else
    DISABLE_CONF=" "
fi

# Set the local timezone
if [ ! -z "$LOCAL_TIMEZONE" ]; then
	ln -sf /usr/share/zoneinfo/"$LOCAL_TIMEZONE" /etc/localtime
fi

icinga2 pki new-cert --cn "$CN" \
--key /var/lib/icinga2/certs/"${CN}".key \
--cert /var/lib/icinga2/certs/"${CN}".crt

icinga2 pki save-cert --key /var/lib/icinga2/certs/"${CN}".key \
--cert /var/lib/icinga2/certs/"${CN}".crt \
--trustedcert /var/lib/icinga2/certs/"${PARENTCN}".crt \
--host "${PARENTHOST}"

icinga2 node setup --ticket "$TICKET" \
--cn "$CN" \
--endpoint "${PARENTCN}","${PARENTHOST}","${PARENTPORT}" \
--zone "$ZONE" \
--parent_zone "$PARENTZONE" \
--parent_host "$PARENTHOST" \
--trustedcert /var/lib/icinga2/certs/"${PARENTCN}".crt \
$ACCEPT_CONF \
$ACCEPT_COMM \
$DISABLE_CONF
