#!/bin/bash

# If parent cn is not specified, default it to the parent host.
# If the zone if not specified, default it to the cn of the satellite/agent.
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
--accept-commands --accept-config \
--disable-confd
