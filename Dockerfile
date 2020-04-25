FROM ubuntu:18.04
RUN apt-get update && apt-get upgrade -y && apt-get install wget gnupg expect -y && \
    wget -O - https://packages.icinga.com/icinga.key | apt-key add -
RUN printf "deb http://packages.icinga.com/ubuntu icinga-bionic main\ndeb-src http://packages.icinga.com/ubuntu icinga-bionic main" > /etc/apt/sources.list.d/icinga2.list && \
    apt-get update && apt-get install icinga2 -y && \
    mkdir /run/icinga2 && chown nagios:nagios /run/icinga2 && \
    mkdir -p /var/lib/icinga2/certs && \
    chown -R nagios:nagios /var/lib/icinga2/certs

COPY create-satellite.sh /create-satellite.sh
COPY run-icinga.sh /run-icinga.sh
RUN chmod +x /create-satellite.sh ; chmod +x /run-icinga.sh

ENTRYPOINT ["/run-icinga.sh"]
