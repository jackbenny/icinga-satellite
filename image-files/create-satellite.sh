#!/bin/bash
icinga2 pki new-cert --cn $HOST \
--key /var/lib/icinga2/certs/${HOST}.key \
--cert /var/lib/icinga2/certs/${HOST}.crt

icinga2 pki save-cert --key /var/lib/icinga2/certs/${HOST}.key \
--cert /var/lib/icinga2/certs/${HOST}.crt \
--trustedcert /var/lib/icinga2/certs/${MASTERHOST}.crt \
--host ${MASTERHOST}

icinga2 node setup --ticket $TICKET \
--cn $HOST \
--endpoint ${MASTERHOST},${MASTERHOST},${MASTERPORT} \
--zone $HOST \
--parent_zone $PARENTZONE \
--parent_host $MASTERHOST \
--trustedcert /var/lib/icinga2/certs/${MASTERHOST}.crt \
--accept-commands --accept-config \
--disable-confd
