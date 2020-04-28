FROM alpine:3.11
RUN apk update && \
    apk add bash && \
    apk add icinga2 && \
    mkdir /run/icinga2 && chown icinga:icinga /run/icinga2 && \
    mkdir -p /var/lib/icinga2/certs && \
    chown -R icinga:icinga /var/lib/icinga2/certs

COPY create-satellite.sh /create-satellite.sh
COPY run-icinga.sh /run-icinga.sh
RUN chmod +x /create-satellite.sh ; chmod +x /run-icinga.sh

ENTRYPOINT ["/run-icinga.sh"]
